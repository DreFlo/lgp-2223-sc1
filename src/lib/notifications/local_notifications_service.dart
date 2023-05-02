import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:src/themes/colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocalNotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
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

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static tz.TZDateTime _convertTime(DateTime dateTime) {
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
      // TODO: Maybe better exception
      throw Exception("Invalid Date Time");
    }
    return scheduleDate;
  }

  static Future<void> display(String message) async {
    // To display the notification in device
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "Channel Id",
          "Main Channel",
          groupKey: "gfg",
          category: AndroidNotificationCategory.service,
          color: primaryColor,
          ledColor: primaryColor,
          ledOnMs: 1000,
          ledOffMs: 500,
          colorized: true,
          importance: Importance.max,
          playSound: true,
          priority: Priority.max,
          timeoutAfter: 30000,
          //autoCancel: false,
          //ongoing: true
        ),
        //to make it persistent you need autoCancel: false and ongoing: true
      );
      await _notificationsPlugin.show(id, message, message, notificationDetails,
          payload: message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> scheduleNotification(
      int id, String title, DateTime dateTime, String body,
      {NotificationDetails? details}) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertTime(dateTime),
      details ?? const NotificationDetails(
        android: AndroidNotificationDetails(
          "Channel Id",
          "Main Channel",
          groupKey: "gfg",
          category: AndroidNotificationCategory.service,
          color: primaryColor,
          ledColor: primaryColor,
          ledOnMs: 1000,
          ledOffMs: 500,
          colorized: true,
          importance: Importance.max,
          playSound: true,
          priority: Priority.max,
          timeoutAfter: 30000,
          //autoCancel: false,
          //ongoing: true
        ),
        //to make it persistent you need autoCancel: false and ongoing: true
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
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
