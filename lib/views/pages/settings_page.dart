import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';

import '../../core/services/daily_quote_service.dart';
import '../../core/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    loadSavedTime();
    super.initState();
  }

  void loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    int hour = prefs.getInt(KConstants.notificationHoursKey) ?? 10;
    int minute = prefs.getInt(KConstants.notificationMinsKey) ?? 0;
    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListTile(
        leading: Icon(Icons.access_time),
        title: Text("Daily Quote Notification Time"),
        subtitle: Text(
          _selectedTime != null
              ? "Time: ${_selectedTime!.format(context)}"
              : "tap to choose time",
        ),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();

          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: _selectedTime ?? TimeOfDay(hour: 10, minute: 0),
          );
          if (picked != null) {
            setState(() {
              _selectedTime = picked;
            });
            await prefs.setInt(KConstants.notificationHoursKey, picked.hour);
            await prefs.setInt(KConstants.notificationMinsKey, picked.minute);
            await NotificationService.cancelNotification(3);

            // Schedule again with new time
            await DailyQuoteService.scheduleDailyQuoteNotification();
          }
        },
      ),
    );
  }
}
