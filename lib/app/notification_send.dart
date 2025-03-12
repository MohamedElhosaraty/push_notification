
import 'package:flutter/material.dart';

import '../services/send_notification_services.dart';

class NotificationSender extends StatelessWidget {
  NotificationSender({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
      child: Center(
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                label: Text("title"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bodyController,
              decoration: const InputDecoration(
                label: Text("body"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (){
                sendNotification(
                  title: titleController.text,
                  body: bodyController.text,
                  data: {
                    'id': '01102507463',
                  },
                  image: 'https://plus.unsplash.com/premium_photo-1738854511313-799f13b4d3ff?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2fHx8ZW58MHx8fHx8',
                );
              },
              child: const Text("Send Notification 🚀"),
            ),
          ],
        ),
      ),
    );
  }
}
