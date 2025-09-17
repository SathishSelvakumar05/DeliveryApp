import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delivery_app/CommonCubit/network_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/GroupCubit/group_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/OfferCubit/offer_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/SingleCubit/single_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/kidsCubit/kids_cubit.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AutoLogin.dart';
import 'CommonCubit/NetworkScreen/MainScreen.dart';
import 'CustomerScreen/DeliveryScreen/Cubit/add_delivery_cubit.dart';
import 'Firebase/PushNotification/PushNotification.dart';
import 'Firebase/PushNotification/TimerNotification.dart';
import 'Firebase/PushNotification/closeNoti.dart';
import 'LoginScreen/Cubit/add_user_cubit.dart';
import 'LoginScreen/LoginForm.dart';
import 'PhotoShop/Cubit/CoupleCubit/couple_cubit.dart';
import 'PhotoShop/Cubit/wedding_cubit.dart';
import 'RBAC/cubit/permission_cubit.dart';
import 'TripNotifier.dart';
import 'Twilio/Cubit/twilio_cubit.dart';
import 'Twilio/DiseasDetectionAI/AIDetection Screen.dart';
import 'Twilio/OpenAI.dart';
import 'Twilio/chat_dialog_flow/MainChatScreen.dart';
import 'Twilio/mainLearnScreeb.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final navigatorKey = GlobalKey<NavigatorState>();
final FirebaseAuth auth = FirebaseAuth.instance;
late DialogFlowtter dialogFlowtter;
final SupaBase = Supabase.instance.client;


@pragma('vm:entry-point')
Future<void> onActionReceived(ReceivedAction receivedAction) async {
  if (receivedAction.buttonKeyPressed == 'STOP') {
    // stop any running timer here
  }
}

@pragma('vm:entry-point')
Future<void> onDismissReceived(DismissAction dismissedAction) async {
  // stop any running timer here
}


// function to listen to background changes
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  // your background logic
  print('Handling a background message: ${message.messageId}');
}

// Future _firebaseBackgroundMessage(RemoteMessage message) async {
//   if (message.notification != null) {
//     print("Some notification Received in background...");
//   }
// }

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    ),
  );
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(
    null, // use default app icon
    [
      // Basic notification channel
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Simple notifications',
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
      ),

      // Countdown notification channel
      NotificationChannel(
        channelKey: 'countdown_channel',   // 🔹 MUST MATCH usage
        channelName: 'Countdown Notifications',
        channelDescription: 'Notifications with countdown timers',
        defaultColor: Colors.deepOrange,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        ledColor: Colors.white,
      ),
    ],
  );
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initialize firebase messaging
  await PushNotifications.init();
  await PushNotification5.init();

  // initialize local notifications
  // dont use local notifications for web platform
  if (!kIsWeb) {
    await PushNotifications.localNotiInit();
  }

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });

// to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    if (message.data.containsKey("trip_start_time")) {
      try {
        print("notification");
        final tripStart = DateTime.parse(message.data["trip_start_time"]!);
        print("$tripStart");

        TripNotifier.showTripCountdown(tripStart);
      } catch (e) {
        print("Invalid trip_start_time format: $e");
      }
    }

    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      // if(message.data.containsKey("time_Epoch")){
      //   PushNotification5.showCountdownFromEpoch(title: "Trip 2 Start from 10:00 PM", epochMillis: message.data['time_Epoch'] ?? "0");
      // }
      if (message.data.containsKey('countdown')) {
        int minutes = int.tryParse(message.data['countdown'] ?? "0") ?? 0;
        if (minutes > 0) {
          PushNotification5.showCountdownNotification(
            title: message.notification!.title ?? "🔥 Flash Sale",
            duration: Duration(minutes: minutes),
          );
          return;
        }
        // if (minutes > 0) {
        //   PushNotification2.showProgressCountdown(
        //     title: message.notification!.title ?? "🔥 Flash Sale",
        //     duration: Duration(minutes: minutes),
        //   );
        //   return;
        // }
      }

      if (kIsWeb) {
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      } else {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }

    }
  });

  // for handling in terminated state
  final RemoteMessage? message =
  await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }
  runApp( BlocProvider(create: (_)=>NetworkCubit(),child: MyApp(),));

}

class MyApp extends StatelessWidget {
  // final Connectivity? connectivity;
  const MyApp({super.key,});
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<PermissionCubit>(create: (context)=>PermissionCubit()),
        BlocProvider<AddUserCubit>(
          create: (context) => AddUserCubit(),
        ),
        BlocProvider<DeliveryCubit>(
          create: (context) => DeliveryCubit(),
        ),
        BlocProvider<TwilioCubit>(create: (context)=>TwilioCubit(),),

        BlocProvider<WeddingCubit>(create: (context)=>WeddingCubit()..fetchWeddingPhotos(),),
        BlocProvider<CoupleCubit>(create: (context)=>CoupleCubit()..fetchCouplePhotos(),),
        BlocProvider<KidsCubit>(create: (context)=>KidsCubit()..fetchKidsPhotos(),),
        BlocProvider<SingleCubit>(create: (context)=>SingleCubit()..fetchSinglePhotos(),),
        BlocProvider<GroupCubit>(create: (context)=>GroupCubit()..fetchGroupPhoto(),),

        BlocProvider<OfferCubit>(create: (context)=>OfferCubit()..fetchOffersPhotos(),),
        // BlocProvider<InternetCubit>(
        //   create: (context) =>
        //       InternetCubit(connectivity: connectivity),
        // ),
      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(412, 846),
          builder: (context, child) {
            return  MaterialApp(
                    // locale: context.locale,
                    // supportedLocales: context.supportedLocales,
                    // localizationsDelegates: context.localizationDelegates,
                    // navigatorKey: navigatorsKey,
                    // theme: theme,
                    // routes: appRoutes,
                    initialRoute: '/',
                    debugShowCheckedModeBanner: false,
               home: MainScreen(child:
              // DentalDetectPage()
               // GenerateAIData()
              //  AuoLoginScreen()
               MainLearnScreen()
               // OpenAIScreen()
               //DialogFlowChat()
               ));

            // MyHomePage(),);
              // BlocBuilder<ThemeCubit, ThemeData>(
              //   builder: (context, theme) {
              //     return MaterialApp(
              //       locale: context.locale,
              //       supportedLocales: context.supportedLocales,
              //       localizationsDelegates: context.localizationDelegates,
              //       navigatorKey: navigatorsKey,
              //       theme: theme,
              //       routes: appRoutes,
              //       initialRoute: '/',
              //       debugShowCheckedModeBanner: false,
              //     );
              //   });
          }),
    );
  }

}


