import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/views/Widgets/edit_item_widget.dart';
import 'package:spark_flow/views/widgets/notification_switch_widget.dart';

import '../../core/services/daily_quote_service.dart';
import '../../core/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay? _selectedTime;
  String _name = '';

  @override
  void initState() {
    loadSavedTime();
    loadUserName();
    super.initState();
  }

  void loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(KConstants.userNameKey) ?? " ";
    setState(() {
      _name = name;
    });
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
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Your name: $_name"),
            onTap: ()  {

              showDialog(
                context: context,
                builder: (context) {
                  return EditItemWidget(
                    title: "Edit your name!",
                    initialValue: _name,
                    onSave: (newValue) async{
                      final prefs = await SharedPreferences.getInstance();
                      _name = newValue;
                      prefs.setString(KConstants.userNameKey, newValue);
                      setState(() {});
                    },
                  );
                },
              );
            },
          ),
          Divider(color: Color(0xff7400B8), height: 1, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 17),
              Icon(Icons.notifications),

              Expanded(child: NotificationSwitchWidget()),
            ],
          ),

          Divider(color: Color(0xff7400B8), height: 1, thickness: 1),
          ListTile(
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
                await prefs.setInt(
                  KConstants.notificationHoursKey,
                  picked.hour,
                );
                await prefs.setInt(
                  KConstants.notificationMinsKey,
                  picked.minute,
                );
                await NotificationService.cancelNotification(3);

                // Schedule again with new time
                await DailyQuoteService.scheduleDailyQuoteNotification();
              }
            },
          ),
          Divider(color: Color(0xff7400B8), height: 1, thickness: 1),
        ],
      ),
    );
  }
}
