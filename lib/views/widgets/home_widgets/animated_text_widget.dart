import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';

class AnimatedTextWidget extends StatefulWidget {
  const AnimatedTextWidget({super.key});

  @override
  State<AnimatedTextWidget> createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> {
  String name = '';
  bool _nameReady = false;

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_nameReady) {
      return SizedBox();
    }
    return Column(
      children: [
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Welcome back, $name',
              textStyle: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif', // optional for elegant feel
              ),
              colors: [Colors.purple, Colors.indigo, Colors.blue, Colors.teal],
            ),
            TypewriterAnimatedText(
              'Keep your Spark alive and Flowing...',
              textStyle: const TextStyle(
                fontSize: 19,
                fontStyle: FontStyle.italic,
                color: Colors.lightBlue,
              ),
              speed: Duration(milliseconds: 80),
            ),
          ],
          repeatForever: true,
          pause: Duration(milliseconds: 1000),
        ),
        const SizedBox(height: 16),
        Text(
          '✨ Let\'s bring your ideas to life today ✨',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString(KConstants.userNameKey) ?? '';
    setState(() {
      name = userName;
      _nameReady = true;
    });
  }
}
