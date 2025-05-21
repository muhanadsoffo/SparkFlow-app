import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../../data/local/hive_config.dart';
import '../../data/models/quote.dart';
import 'daily_quote_service.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> dailyQuoteAlarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();
  await NotificationService.init();
  debugPrint("🚨 Alarm callback triggered!");

  await DailyQuoteService.scheduleDailyQuoteNotification();
  await NotificationService.scheduleDailyStaticReminder();
}

void scheduleAlarmManagerQuote() async {
  final metaBox = Hive.box('quote_meta');
  final hour = metaBox.get('hour', defaultValue: 10);
  final minute = metaBox.get('minute', defaultValue: 0);

  final now = DateTime.now();

  final notificationTime = DateTime(now.year, now.month, now.day, hour, minute);
  final alarmStartTime = notificationTime.add(const Duration(minutes: 1));

  final startAt = alarmStartTime.isBefore(now)
      ? alarmStartTime.add(const Duration(days: 1)) // if time passed, start tomorrow
      : alarmStartTime;

  await AndroidAlarmManager.cancel(0); // just in case

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    0, // Unique ID for this alarm
    dailyQuoteAlarmCallback,
    startAt: startAt,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}
