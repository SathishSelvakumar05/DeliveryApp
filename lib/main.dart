import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CommonCubit/internet_cubit.dart';
import 'CustomerScreen/DeliveryScreen/Cubit/add_delivery_cubit.dart';
import 'Firebase/PushNotification/PushNotification.dart';
import 'LoginScreen/Cubit/add_user_cubit.dart';
import 'LoginScreen/LoginForm.dart';
import 'firebase_options.dart';
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
  runApp(  MyApp(connectivity: Connectivity(),));

}

class MyApp extends StatelessWidget {
  final Connectivity? connectivity;
  const MyApp({super.key,this.connectivity});
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
        BlocProvider<InternetCubit>(
          create: (context) =>
              InternetCubit(connectivity: connectivity),
        ),
      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(412, 846),
          builder: (context, child) {
            return  MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MyHomePage(),);
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


