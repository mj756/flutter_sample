import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sample/Utils/Utility.dart';

import 'api_controller.dart';
import 'extra_functionality/event_bus.dart';

class PushNotificationController {
  static const String notificationChannel = "high_importance_channel";
  static final flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
  static bool isInitialized = false;

  static Future<void> initialize() async {
    if (!isInitialized) {
      {
        await flutterNotificationPlugin.initialize(const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            // android: AndroidInitializationSettings('@drawable/ic_launcher'),
            iOS: DarwinInitializationSettings(
                requestSoundPermission: true,
                requestBadgePermission: true,
                requestAlertPermission: true,
                onDidReceiveLocalNotification: onDidReceiveLocalNotification)));
        isInitialized = true;
      }
    }
  }

  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<void> messageReceived(RemoteMessage message) async {
    await initialize();
    eventBus.fire(ChatMessageEvent(message));
    showLocalNotification(message);
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    await initialize();
    eventBus.fire(ChatMessageEvent(message));
    showLocalNotification(message);
  }

  static Future<void> onMessageReceive(RemoteMessage message) async {
    await initialize();
    eventBus.fire(ChatMessageEvent(message));
    showLocalNotification(message);
  }

  static Future<void> onMessageClick(RemoteMessage message) async {}
  static Future<void> getInitialMessage(RemoteMessage message) async {
    await initialize();
    try {
      showLocalNotification(message);
    } catch (e) {}
  }

  static void showLocalNotification(RemoteMessage message,
      {String? title = ''}) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    late final String imageUrl;
    Map<String, dynamic> jsonData = Map<String, dynamic>.from(
        json.decode(message.data['notificationPayload']));
    if (message.data['notificationType'] == Utility.messageTypeText) {
      imageUrl = jsonData['ImageUrl'];
    }
    /*  final String largeIconPath = await ApiController.downloadAndSaveFile(
        imageUrl, 'largeIcon');*/
    final String bigPicturePath =
        await ApiController.downloadAndSaveFile(imageUrl, 'bigPicture');
    /*   final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        htmlFormatContentTitle: false,
        htmlFormatSummaryText: false);*/

    NotificationDetails notificationDetail = NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannel,
          "demo channel name",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          largeIcon: FilePathAndroidBitmap(bigPicturePath),
          // colorized: true
          // styleInformation: bigPictureStyleInformation
        ),
        iOS: const DarwinNotificationDetails());
    if (message.data['notificationType'] == Utility.messageTypeText) {
      await flutterNotificationPlugin.show(
        id,
        jsonData['SenderName'],
        jsonData['Message'],
        notificationDetail,
      );
    }
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    await selectNotification(payload);
  }

  static Future<void> selectNotification(String? payload) async {
    //implement code when click on notification
  }
  static void onMessageOpenedApp(RemoteMessage message) {
    try {} catch (e) {}
  }
}
