import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/notifiers.dart';
import 'package:spark_flow/core/services/daily_quote_service.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:workmanager/workmanager.dart';

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

            if (value == true) {
              await Workmanager().registerPeriodicTask(
                "daily_quote_task_id",
                "dailyQuoteTask",
                frequency: const Duration(hours: 24),
                constraints: Constraints(
                  networkType: NetworkType.not_required,
                ),
              );
            } else {
              await Workmanager().cancelByUniqueName("daily_quote_task_id");
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
