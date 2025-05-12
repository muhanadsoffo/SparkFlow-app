import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/services/daily_quote_service.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/data/models/quote.dart';

import '../../../data/local/boxes.dart';
import '../../Widgets/appbar_widget.dart';

class AddQuotePage extends StatefulWidget {
  const AddQuotePage({super.key});

  @override
  State<AddQuotePage> createState() => _AddQuotePageState();
}

class _AddQuotePageState extends State<AddQuotePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Add a Quote"),
        backgroundColor: Color(0xFFff8000),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(alignment: Alignment.topCenter),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Add a Quote, talk to yourself !",
              style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a Quote',
            ),
          ),
          SizedBox(height: 15),
          FilledButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                setState(() async{
                  Boxes.quotesBox.put('key_$title', Quote(title, true));
                  final prefs = await SharedPreferences.getInstance();
                  final isEnabled = prefs.getBool(KConstants.quoteNotificationKey) ?? false;
                  if(isEnabled){
                    await NotificationService.cancelNotification(3);
                    await DailyQuoteService.scheduleDailyQuoteNotification();
                  }
                  controller.clear();
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      content: Text("Quote added successfully!"),
                    ),
                  );
                });
              } else if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 5),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text("Text should not be empty"),
                  ),
                );
              }
            },
            child: Text("Add a Quote"),
          ),
        ],
      ),
    );
  }
}
