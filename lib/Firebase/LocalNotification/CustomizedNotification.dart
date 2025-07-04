import 'package:flutter/material.dart';
import '../PushNotification/PushNotification.dart';

class CustomizedNotification extends StatefulWidget {
  @override
  _ScheduleNotificationFormState createState() =>
      _ScheduleNotificationFormState();
}

class _ScheduleNotificationFormState extends State<CustomizedNotification> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isDaily = false;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          selectedDate = date;
          selectedTime = time;
        });
      }
    }
  }

  void _schedule() {
    final title = _titleController.text;
    final body = _bodyController.text;
    final time = selectedTime;
    final date = selectedDate;

    if (title.isEmpty || body.isEmpty || time == null || (!isDaily && date == null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fill all fields')));
      return;
    }

    if (isDaily) {
      PushNotifications.showDailyNotification(
        title: title,
        body: body,
        payload: 'Daily Payload',
        time: time!,
      );
    } else {
      final scheduledDateTime = DateTime(
        date!.year,
        date.month,
        date.day,
        time!.hour,
        time.minute,
      );
      PushNotifications.showScheduledNotification(
        title: title,
        body: body,
        payload: 'One-time Payload',
        dateTime: scheduledDateTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
          TextField(controller: _bodyController, decoration: InputDecoration(labelText: 'Body')),
          Row(
            children: [
              Text("Repeat daily?"),
              Switch(
                value: isDaily,
                onChanged: (val) {
                  setState(() {
                    isDaily = val;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _pickDateTime,
            child: Text("Select Date & Time"),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.notifications),
            onPressed: _schedule,
            label: Text("Set Notification"),
          ),
        ],
      ),
    );
  }
}
