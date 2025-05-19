import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/notifiers.dart';
import 'package:spark_flow/core/services/daily_quote_service.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/services/alarm_manger_service.dart' as AlarmMangerService;

class NotificationSwitchWidget extends StatefulWidget {
  const NotificationSwitchWidget({super.key});

  @override
  State<NotificationSwitchWidget> createState() =>
      _NotificationSwitchWidgetState();
}

class _NotificationSwitchWidgetState extends State<NotificationSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDailyQuoteEnabled,
      builder: (context, value, child) {
        return SwitchListTile(

          title: const Text("Daily notification"),
          subtitle: Text(value ? "Enabled" : "Disabled"),
          value: value,


          onChanged: (value) async {
            isDailyQuoteEnabled.value = value;
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool(
              KConstants.quoteNotificationKey,
              isDailyQuoteEnabled.value,
            );

            if (isDailyQuoteEnabled.value == true) {
              await DailyQuoteService.scheduleDailyQuoteNotification();
              AlarmMangerService.scheduleAlarmManagerQuote();
            } else {
              await NotificationService.cancelNotification(3);
              final box = Hive.box<Quote>('quotes');
              for (final quote in box.values) {
                quote.status = true;
                await quote.save();
              }
            }
          },
        );
      },
    );
  }
}
