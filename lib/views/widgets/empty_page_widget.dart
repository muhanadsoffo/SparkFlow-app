import 'package:flutter/material.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({super.key, required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/flog.png'),
            ),
            SizedBox(height: 20),
            Text(
              "No $title yet.\nStart by adding something that inspires you!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18,),
            ),
          ],
        ),
      ),
    );
  }
}
