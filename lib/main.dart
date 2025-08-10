import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delivery_app/CommonCubit/network_cubit.dart';
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
import 'LoginScreen/Cubit/add_user_cubit.dart';
import 'LoginScreen/LoginForm.dart';
import 'Twilio/Cubit/twilio_cubit.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final navigatorKey = GlobalKey<NavigatorState>();

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
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
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
        BlocProvider<AddUserCubit>(
          create: (context) => AddUserCubit(),
        ),
        BlocProvider<DeliveryCubit>(
          create: (context) => DeliveryCubit(),
        ),
        BlocProvider<TwilioCubit>(create: (context)=>TwilioCubit(),),
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
               home: MainScreen(child: AuoLoginScreen()));

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


