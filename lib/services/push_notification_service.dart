import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/main.dart';
import 'package:push_notifications/services/local_notifications_service.dart';
import 'package:push_notifications/services/send_notification_services.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // لتخزين بيانات الإشعار مؤقتًا إذا كان التطبيق مغلق
  static Map<String, dynamic>? pendingNotification;

  static Future<void> init() async {
    // طلب الإذن من المستخدم
    await messaging.requestPermission();

    // الحصول على التوكن
    await messaging.getToken().then((value) {
      if (value != null) {
        sendTokenToServer(value);
      }
    });

    // تحديث التوكن
    messaging.onTokenRefresh.listen((value) {
      sendTokenToServer(value);
    });

    // التعامل مع الإشعار أثناء الخلفية
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);

    // التعامل مع الإشعار في الـ foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      log("Message received in foreground");
      LocalNotificationService.showBasicNotification(event);
    });

    // التعامل مع الإشعار أثناء فتح التطبيق من الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(message.data);
    });

    // التعامل مع الإشعار إذا كان التطبيق مغلق بالكامل
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        pendingNotification = message.data; // تخزين البيانات مؤقتًا
      }
    });

    messaging.subscribeToTopic("all");
  }

  // التعامل مع الإشعارات في الخلفية
  static Future<void> handlerBackgroundMessage(RemoteMessage message) async {
    log("Background Notification: ${message.data}");
  }

  static void sendTokenToServer(String token) async {
    log("Firebase Token: $token");
  }
}
