import 'package:flutter/material.dart';
import 'package:spark_flow/core/services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png'),
          Center(child: Text("this is home")),
          FilledButton(
            onPressed: () {
              NotificationService.showInstantNotification(
                id: 1,
                title: "testing notification",
                body: "hey there this is the body",
              );
            },
            child: Text("show notification"),
          ),
        ],
      ),
    );
    ;
  }
}
