import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:src/themes/colors.dart';

class LocalNotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization  setting for android
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }
  

  static Future<void> display(String message) async {
    // To display the notification in device
    try {
      print(message);
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            message ?? "Channel Id", message ?? "Main Channel",
            groupKey: "gfg",
            category: AndroidNotificationCategory.service,
            color: modalBackground,
            ledColor: primaryColor,
            ledOnMs: 1000,
            ledOffMs: 500,
            colorized: true,
            importance: Importance.max,
            playSound: false,
            priority: Priority.max,
            styleInformation: const DefaultStyleInformation(true, true),
            //autoCancel: false,
            fullScreenIntent: true,
            ongoing: true),
        //to make it persistent you need autoCancel: false and ongoing: true
      );
      await _notificationsPlugin.show(id, message, message, notificationDetails,
          payload: message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
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
