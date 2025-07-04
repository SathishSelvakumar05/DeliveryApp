
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../PushNotification/PushNotification.dart';
import 'CustomizedNotification.dart';
import 'NotificationDatas.dart';

class LocalnotificationScreen extends StatefulWidget {
  const LocalnotificationScreen({super.key});

  @override
  State<LocalnotificationScreen> createState() => _LocalnotificationScreenState();
}

class _LocalnotificationScreenState extends State<LocalnotificationScreen> {

  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

//  to listen to any notification clicked or not
  listenToNotifications() {
    print("Listening to notification");
    PushNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherPage(payload: event,),));
      Navigator.pushNamed(context, '/another', arguments: event);
    });
  }
  DateTime? selectedDateTime;

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            ElevatedButton.icon(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                PushNotifications.showSimpleNotification(
                    title: "Simple Notification",
                    body: "This is a simple notification",
                    payload: "This is simple data");
              },
              label: Text("Simple Notification"),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.timer_outlined),
              onPressed: () {
                PushNotifications.showPeriodicNotifications(
                    title: "Periodic Notification",
                    body: "This is a Periodic Notification",
                    payload: "This is periodic data");
              },
              label: Text("Periodic Notifications"),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.timer_outlined),
              onPressed: () async {
                await _pickDateTime(context);

                if (selectedDateTime != null) {
                  PushNotifications.showScheduleNotification(
                    title: "User Scheduled Notification",
                    body: "This is your custom notification",
                    payload: "Custom payload",
                    scheduledDateTime: selectedDateTime!,
                  );
                }
              },
              label: Text("Schedule Notification"),
            ),

            // ElevatedButton.icon(
            //   icon: Icon(Icons.timer_outlined),
            //   onPressed: () {
            //     PushNotifications.showScheduleNotification(
            //         title: "Schedule Notification",
            //         body: "This is a Schedule Notification",
            //         payload: "This is schedule data");
            //   },
            //   label: Text("Schedule Notifications"),
            // ),
            ElevatedButton.icon(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  PushNotifications.cancel(1);
                },
                label: Text("Close Periodic Notifcations")),
            ElevatedButton.icon(
                icon: Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  PushNotifications.cancelAll();
                },
                label: Text("Cancel All Notifcations")),

            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomizedNotification(),));
            }, child: Text('CustomizedNotification'))

          ]
        )
      )
    );
  }
}
