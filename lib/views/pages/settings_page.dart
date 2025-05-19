import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/views/Widgets/edit_item_widget.dart';
import 'package:spark_flow/views/widgets/notification_switch_widget.dart';

import '../../core/services/alarm_manger_service.dart' as AlarmMangerService;
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
    super.initState();
    loadSavedTime();
    loadUserName();
  }

  void loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(KConstants.userNameKey) ?? " ";
    setState(() {
      _name = name;
    });
  }

  void loadSavedTime() async {
    final metaBox = Hive.box('quote_meta');
    final hour = metaBox.get('hour', defaultValue: 10);
    final minute = metaBox.get('minute', defaultValue: 0);
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
          Divider(color: Color(0xff7400B8), height: 4, thickness: 4),
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
                      if(newValue.isNotEmpty && newValue.length <=15 ){
                        prefs.setString(KConstants.userNameKey, newValue);
                        setState(() {});
                      }else if (newValue.length > 15){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 5),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            content: Text("Name is too long, should be 15 letters or less"),
                          ),
                        );
                      }

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
                final metaBox = Hive.box('quote_meta');
                await metaBox.put('hour', picked.hour);
                await metaBox.put('minute', picked.minute);
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
                AlarmMangerService.scheduleAlarmManagerQuote();
              }
            },
          ),
          Divider(color: Color(0xff7400B8), height: 1, thickness: 1),
        ],
      ),
    );
  }
}
