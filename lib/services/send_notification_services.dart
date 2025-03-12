import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:push_notifications/app/notificaion.dart';

Future<String> getAccessToken() async {
  // add key json file path
  final jsonString = await rootBundle.loadString(
    'assets/push_notifications_key.json',
  );

  final accountCredentials =
  auth.ServiceAccountCredentials.fromJson(jsonString);

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  return client.credentials.accessToken.data;
}

Future<void> sendNotification(
    {
      required String title,
      required String body,
      required String image,
      required Map<String, String> data
    }) async {
  final String accessToken = await getAccessToken();
  const String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/push-notifications-439cf/messages:send';
  final dio = Dio();

  final response = await dio.post(
    fcmUrl,
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ),
    data: jsonEncode({
      'message': {
        'topic': "all",
        'notification': {
          'title': title,
          'body': body,
          'image':image,
        },
        'data': data, // Add custom data here


        'android': {
          'notification': {
            "sound": "notification",
            'click_action': 'FLUTTER_NOTIFICATION_CLICK', // ضروري لتفعيل الاستجابة عند النقر
            'channel_id': 'channel_id'
          },
        },
        // مش ضرورى
        'apns': {
          'payload': {
            'aps': {"sound": "notification.wav", 'content-available': 1},
          },
        },
      },
    }),
  );

  if (response.statusCode == 200) {
    log('Notification sent successfully');
  } else {
    log('Failed to send notification: ${response.data}');
  }
}

void handleNotification(BuildContext context, Map<String, dynamic> data) {
  String id = data['id'];

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Notification1(id : id)),
    );

    log("success");

}

