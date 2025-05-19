import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/services/daily_quote_service.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/data/models/quote.dart';

import '../../../core/services/alarm_manger_service.dart' as AlarmMangerService;
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
      appBar: AppBar(
        title: Text("Add a Quote"),
        backgroundColor: Color(0xFF7400B8),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              "🧠 Add a Quote to Inspire Yourself",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,

              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Input box
            TextField(
              controller: controller,
              maxLines: 4,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Write your motivational quote here...",
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Add Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final title = controller.text.trim();
                  if (title.isNotEmpty) {
                    Boxes.quotesBox.put('key_$title', Quote(title, true));

                    final prefs = await SharedPreferences.getInstance();
                    final isEnabled = prefs.getBool(KConstants.quoteNotificationKey) ?? false;

                    if (isEnabled) {
                      await NotificationService.cancelNotification(3);
                      await DailyQuoteService.scheduleDailyQuoteNotification();
                      AlarmMangerService.scheduleAlarmManagerQuote();
                    }

                    controller.clear();
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 4),
                        backgroundColor: Colors.green,
                        content: Text("✅ Quote added successfully!"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 4),
                        backgroundColor: Colors.redAccent,
                        content: Text("⚠️ Please enter a quote before saving."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.add_comment_rounded,color: Colors.white,),
                label: Text("Add Quote",style: TextStyle(color: Colors.white),),
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF7400B8),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
