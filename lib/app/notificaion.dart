import 'package:flutter/material.dart';

class Notification1 extends StatelessWidget {
  const Notification1({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(id),
      ),
    );
  }
}
