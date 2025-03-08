import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/services/local_notifications_service.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value){
      sendTokenToServer(value!);
    });
    messaging.onTokenRefresh.listen((value){
      sendTokenToServer(value);
    });
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
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
  static Future<void> handlerBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? '');
  }

  static void sendTokenToServer(String token) async {}
}
