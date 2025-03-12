import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  static onTapNotification(NotificationResponse notificationResponse) async {
    streamController.add(notificationResponse);
  }

  //  initialize
  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // عند الضغط على الاشعار يتم استخدام هذا الكود والتطبيق شغال
      onDidReceiveNotificationResponse: onTapNotification,
      // عند الضغط على الاشعار يتم استخدام هذا الكود والتطبيق مغلق
      onDidReceiveBackgroundNotificationResponse: onTapNotification,
    );
  }

  // basic Notification
  static Future<void> showBasicNotification(
    RemoteMessage message,
  ) async {
    final Dio dio = Dio();

    final Response image = await dio.get(
      message.notification?.android?.imageUrl.toString() ?? "",
      options: Options(responseType: ResponseType.bytes),
    );
    Uint8List imageBytes =
        Uint8List.fromList(image.data); // تحويل البيانات إلى Uint8List
    String base64Image = base64Encode(imageBytes); // تحويلها إلى Base64
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(base64Image),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Image),
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: const RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}
