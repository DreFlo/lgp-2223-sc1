import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:src/notifications/local_notifications_service.dart';

class MockLocalNotificationsService extends LocalNotificationService {
  @override
  Future<void> display(String title, String message) async {
    return Future.value();
  }

  @override
  Future<void> initialize() async {
    return Future.value();
  }

  @override
  Future<void> scheduleNotification(
      int id, String title, DateTime dateTime, String body,
      {NotificationDetails? details}) async {
    return Future.value();
  }

  @override
  Future<void> cancelAll() async => Future.value();

  @override
  Future<void> cancel(int id) async => Future.value();
}
