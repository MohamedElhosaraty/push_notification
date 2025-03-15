import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/main.dart';
import 'package:push_notifications/services/local_notifications_service.dart';
import 'package:push_notifications/services/send_notification_services.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Map<String, dynamic>? pendingNotificationData;

  static Future init() async {

    // طلب إذن الإشعارات
    await messaging.requestPermission();

    // الحصول على التوكن
    await messaging.getToken().then((value){
      sendTokenToServer(value!);
    });

    // تحديث التوكن في حالة تغييره
    messaging.onTokenRefresh.listen((value){
      sendTokenToServer(value);
    });
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);

    // استقبال الإشعار إذا التطبيق في الخلفية
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      log("message received");
      try {

        handleNotification(navigatorKey.currentContext!, event.data);
      } catch (err) {
        log(err.toString());
      }
    });

    // استقبال الإشعار في حالة التطبيق مغلق بالكامل
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        pendingNotificationData = message.data; // تخزين البيانات مؤقتًا
        handleNotification(navigatorKey.currentContext!, message.data);
      }
    });

    // استقبال الإشعار إذا تم الضغط على الإشعار والتطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(navigatorKey.currentContext!, message.data);
    });

    // foreground
    handlerForegroundMessage();

    messaging.subscribeToTopic("all");


  }

  // foreground
  static void handlerForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        //show local notification
        LocalNotificationService.showBasicNotification(
          message,
        );
      },
    );

  }
  // background notification
  static Future<void> handlerBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? '');
  }

  static void sendTokenToServer(String token) async {}
}
