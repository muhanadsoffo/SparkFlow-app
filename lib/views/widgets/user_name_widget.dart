import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';

class UserNameWidget extends StatefulWidget {
  const UserNameWidget({super.key});

  @override
  State<UserNameWidget> createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkName();
  }
  void checkName() async{

    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(KConstants.userNameKey);
    if(name== null || name.isEmpty){
      Future.delayed(Duration.zero,() => askName(),);
    }
  }
  Widget build(BuildContext context) {
    return SizedBox();
  }

  void askName()  {
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
            ElevatedButton(onPressed: () async{
              final name = controller.text.trim();
              if(name.isNotEmpty){
                final prefs = await SharedPreferences.getInstance();
                prefs.setString(KConstants.userNameKey, name);
              }

              Navigator.pop(context);

            }, child: Text("Save"))
          ],
        );
      },
    );
  }
}
