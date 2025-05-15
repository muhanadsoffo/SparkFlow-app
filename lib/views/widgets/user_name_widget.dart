import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';

import '../widget_tree.dart';

class UserNameWidget extends StatefulWidget {
  const UserNameWidget({super.key});

  @override
  State<UserNameWidget> createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> {
  void initState() {
    // TODO: implement initState
    super.initState();
    checkName();
  }

  bool _checking = true;
  bool _hasName = false;

  void checkName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(KConstants.userNameKey);
    if (name == null || name.isEmpty) {
      Future.delayed(Duration.zero, () => askName());
      return;
    }
    {
      setState(() {
        _hasName = true;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _hasName
        ? WidgetTree()
        : SizedBox(); // this will only show WidgetTree if name was set
  }

  void askName() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Welcome! What is your name?"),
          actions: [
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter your name please"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty && name.length <= 15) {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString(KConstants.userNameKey, name);

                  Navigator.pop(context);
                  setState(() {
                    _hasName = true;
                    _checking = false;
                  });
                }else if (name.length > 15){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 5),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text("Name is too long"),
                      ),
                  );
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
