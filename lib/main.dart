import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'AutoLogin.dart';
import 'CommonCubit/NetworkScreen/MainScreen.dart';
import 'Firebase/PushNotification/PushNotification.dart';
import 'PhotoShop/Cubit/CoupleCubit/couple_cubit.dart';
import 'PhotoShop/Cubit/wedding_cubit.dart';
import 'alert_overlay/location_service.dart';
import 'alert_overlay/mainScren.dart';
import 'alert_overlay/new_service.dart';
import 'alert_overlay/overlay_view.dart';
import 'alert_overlay/system_alert.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final navigatorKey = GlobalKey<NavigatorState>();
final FirebaseAuth auth = FirebaseAuth.instance;
late DialogFlowtter dialogFlowtter;
final SupaBase = Supabase.instance.client;


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
 // await initializeService();
  // initRemoteConfig();

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
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(color: Colors.red,showPerformanceOverlay: true,title: "daada",
    debugShowCheckedModeBanner: false,
    home: OverlayView(),
  ));
}






// class MyApp extends StatefulWidget {
//   // final Connectivity? connectivity;
//   const MyApp({super.key,});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return  MultiBlocProvider(
//       providers: [
//
//         BlocProvider<WeddingCubit>(create: (context)=>WeddingCubit()..fetchWeddingPhotos(),),
//         BlocProvider<CoupleCubit>(create: (context)=>CoupleCubit()..fetchCouplePhotos(),),
//         BlocProvider<KidsCubit>(create: (context)=>KidsCubit()..fetchKidsPhotos(),),
//         BlocProvider<SingleCubit>(create: (context)=>SingleCubit()..fetchSinglePhotos(),),
//         BlocProvider<GroupCubit>(create: (context)=>GroupCubit()..fetchGroupPhoto(),),
//
//         BlocProvider<OfferCubit>(create: (context)=>OfferCubit()..fetchOffersPhotos(),),
//         // BlocProvider<InternetCubit>(
//         //   create: (context) =>
//         //       InternetCubit(connectivity: connectivity),
//         // ),
//       ],
//       child: ScreenUtilInit(
//           minTextAdapt: true,
//           splitScreenMode: true,
//           designSize: const Size(412, 846),
//           builder: (context, child) {
//             return  MaterialApp(
//                     // locale: context.locale,
//                     // supportedLocales: context.supportedLocales,
//                     // localizationsDelegates: context.localizationDelegates,
//                     // navigatorKey: navigatorsKey,
//                     // theme: theme,
//                     // routes: appRoutes,
//                     initialRoute: '/',
//                     debugShowCheckedModeBanner: false,
//                home: MainScreen(child:
//               // DentalDetectPage()
//                // GenerateAIData()
//               // AuoLoginScreen()
//                    SystemAlert()
//               // MainLearnScreen()
//                // OpenAIScreen()
//                //DialogFlowChat()
//                ));
//
//             // MyHomePage(),);
//               // BlocBuilder<ThemeCubit, ThemeData>(
//               //   builder: (context, theme) {
//               //     return MaterialApp(
//               //       locale: context.locale,
//               //       supportedLocales: context.supportedLocales,
//               //       localizationsDelegates: context.localizationDelegates,
//               //       navigatorKey: navigatorsKey,
//               //       theme: theme,
//               //       routes: appRoutes,
//               //       initialRoute: '/',
//               //       debugShowCheckedModeBanner: false,
//               //     );
//               //   });
//           }),
//     );
//   }
// }


