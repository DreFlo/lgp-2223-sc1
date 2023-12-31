import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:src/themes/colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _configureLocalTimeZone();
    // Initialization  setting for android
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    await _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  tz.TZDateTime _convertTime(DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    if (scheduleDate.isBefore(now)) {
      throw Exception("Invalid Date Time");
    }
    return scheduleDate;
  }

  Future<void> display(String title, String message) async {
    // To display the notification in device
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "Sound Please",
          "Main Channel",
          groupKey: "gfg",
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
          category: AndroidNotificationCategory.alarm,
          color: primaryColor,
          ledColor: primaryColor,
          ledOnMs: 1000,
          ledOffMs: 500,
          colorized: true,
          importance: Importance.max,
          priority: Priority.max,
          timeoutAfter: 30000,
          autoCancel: false,
          enableVibration: true,
          //ongoing: true
        ),
        //to make it persistent you need autoCancel: false and ongoing: true
      );
      await _notificationsPlugin.show(id, title, message, notificationDetails,
          payload: message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> scheduleNotification(
      int id, String title, DateTime dateTime, String body,
      {NotificationDetails? details}) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertTime(dateTime),
      details ??
          const NotificationDetails(
            android: AndroidNotificationDetails(
                "Scheduled Notification", "Main Channel",
                groupKey: "gfg",
                sound: RawResourceAndroidNotificationSound('notification'),
                category: AndroidNotificationCategory.alarm,
                color: primaryColor,
                ledColor: primaryColor,
                ledOnMs: 1000,
                ledOffMs: 500,
                colorized: true,
                importance: Importance.max,
                playSound: true,
                priority: Priority.max,
                timeoutAfter: 30000,
                enableVibration: true
                //autoCancel: false,
                //ongoing: true
                ),
          ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAll() async => await _notificationsPlugin.cancelAll();
  Future<void> cancel(int id) async => await _notificationsPlugin.cancel(id);
}

class DynamicDialog extends StatefulWidget {
  final String title;
  final String body;

  const DynamicDialog({super.key, required this.title, required this.body});

  @override
  DynamicDialogState createState() => DynamicDialogState();
}

class DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    // You can change the UI as per
    // your requirement or choice
    return AlertDialog(
      title: Text(widget.title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      actions: <Widget>[
        OutlinedButton.icon(
            label: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close))
      ],
      content: Text(widget.body),
    );
  }
}
