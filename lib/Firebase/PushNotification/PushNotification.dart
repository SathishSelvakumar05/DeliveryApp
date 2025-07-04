import 'package:delivery_app/Components/CustomToast/CustomToast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';
import 'auth_service.dart';
import 'crud_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  // get the fcm device token
  static Future getDeviceToken({int maxRetires = 3}) async {
    try {
      String? token;
      if (kIsWeb) {
        // get the device fcm token
        token = await _firebaseMessaging.getToken(
            vapidKey:
            "BPA9r_00LYvGIV9GPqkpCwfIl3Es4IfbGqE9CSrm6oeYJslJNmicXYHyWOZQMPlORgfhG8RNGe7hIxmbLXuJ92k");
        print("for web device token: $token");
      } else {
        // get the device fcm token
        token = await _firebaseMessaging.getToken();
        print("for android device token: $token");
      }
      saveTokentoFirestore(token: token!);
      return token;
    } catch (e) {
      print("failed to get device token");
      if (maxRetires > 0) {
        print("try after 10 sec");
        await Future.delayed(Duration(seconds: 10));
        return getDeviceToken(maxRetires: maxRetires - 1);
      } else {
        return null;
      }
    }
  }

  static saveTokentoFirestore({required String token}) async {
    bool isUserLoggedin = await AuthService.isLoggedIn();
    print("User is logged in $isUserLoggedin");
    if (isUserLoggedin) {
      await CRUDService.saveUserToken(token!);
      print("save to firestore");
    }
    // also save if token changes
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedin) {
        await CRUDService.saveUserToken(token!);
        print("save to firestore");
      }
    });
  }

  // initalize local notifications
  static Future localNotiInit() async {
    final token=await _firebaseMessaging.getToken();
    print('1111111111');
    print(token.toString()??'');
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',

    );
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);


    // Create a notification channel with custom sound
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "123", // Same as used above
      'Custom Channel',
      description: 'This channel uses a custom sound.',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('custom_sound'),
      playSound: true, enableVibration: true,
    );
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    // Permission for Android 13+
    await androidPlugin?.requestNotificationsPermission();

    // // request notification permissions for android 13 or above
    // _flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()!
    //     .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // on tap local notification in foreground
  // static void onNotificationTap(NotificationResponse notificationResponse) {
  //   navigatorKey.currentState!
  //       .pushNamed("/message", arguments: notificationResponse);
  // }
  static final onClickNotification = BehaviorSubject<String>();

// on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('custom_sound'), // <-- Custom sound
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
  // to show periodic notification at regular interval
  static Future showPeriodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel 2', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        1, title, body, RepeatInterval.everyMinute, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload);
  }


  // to schedule a local notification
  // static Future showScheduleNotification({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   tz.initializeTimeZones();
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       2,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               'channel 3', 'your channel name',
  //               channelDescription: 'your channel description',
  //               importance: Importance.max,
  //               priority: Priority.high,
  //               ticker: 'ticker')),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       payload: payload);
  // }


  // to schedule a local notification

  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDateTime, // new param
  }) async {
    tz.initializeTimeZones();
    final tz.TZDateTime scheduledTime =
    tz.TZDateTime.from(scheduledDateTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_3', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // static Future showScheduleNotification({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   tz.initializeTimeZones();
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       2,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               'channel 3', 'your channel name',
  //               channelDescription: 'your channel description',
  //               importance: Importance.max,
  //               priority: Priority.high,
  //               ticker: 'ticker')),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       payload: payload);
  // }



  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  //Customized Notification
// One-time notification
  static Future showScheduledNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime dateTime,
  }) async {
    tz.initializeTimeZones();
    final schedule = tz.TZDateTime.from(dateTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      100, // ID
      title,
      body,
      schedule,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_1', 'One-time Notification',
          channelDescription: 'Notifies once at selected time',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

// Daily notification (repeat every day at same time)
  static Future showDailyNotification({
    required String title,
    required String body,
    required String payload,
    required TimeOfDay time,
  }) async {
    tz.initializeTimeZones();
    final now = tz.TZDateTime.now(tz.local);
    final scheduleTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).isBefore(now)
        ? tz.TZDateTime(
        tz.local, now.year, now.month, now.day + 1, time.hour, time.minute)
        : tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      200,
      title,
      body,
      scheduleTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_2', 'Daily Notification',
          channelDescription: 'Daily reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // <-- REPEAT DAILY
      payload: payload,
    );
    print("scheduleTime.toString()");
    print(scheduleTime.toString());
    showSuccessToast('Daily Scheduled Successfully applied');
  }

}
