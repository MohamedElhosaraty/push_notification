import 'package:flutter/material.dart';
import 'package:push_notifications/app/push_notifications.dart';
import 'package:push_notifications/services/local_notifications_service.dart';
import 'package:push_notifications/services/push_notification_service.dart';
import 'package:push_notifications/services/send_notification_services.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // ✅ التحقق من الإشعار بعد بناء الـ Widget Tree
    if (PushNotificationsService.pendingNotificationData != null) {
      Future.delayed(Duration.zero, () {
        handleNotification(navigatorKey.currentContext!,
            PushNotificationsService.pendingNotificationData!);
        PushNotificationsService.pendingNotificationData =
            null; // تصفير البيانات
      });
    }
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PushNotifications(),
    );
  }
}
