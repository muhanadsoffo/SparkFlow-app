import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'notification_service.dart';

class DailyQuoteService {
  static Future<void> scheduleDailyQuoteNotification() async {
    final Box<Quote> box = Hive.box<Quote>('quotes');
    final quotes = box.values.toList();
    final metaBox = Hive.box('quote_meta');
    if (quotes.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
   // int currentIndex = prefs.getInt(KConstants.quoteIndexKey) ?? 0;
   // final hour = prefs.getInt(KConstants.notificationHoursKey) ?? 10;
    //final minute = prefs.getInt(KConstants.notificationMinsKey) ?? 0;
    final hour = metaBox.get('hour', defaultValue: 10);
    final minute = metaBox.get('minute', defaultValue: 0);
    int currentIndex = metaBox.get('quoteIndexKey', defaultValue: 0);
    // if nothing left then reset all status
    if (currentIndex >= quotes.length) {
      currentIndex = 0;
    }
    final selectedQuote = quotes[currentIndex];



    await NotificationService.scheduleDailyNotification(
      id: 3,
      title: "Your daily Quote",
      body: selectedQuote.quoteTitle,
      hour: hour,
      minute: minute,
    );
    int nextIndex = currentIndex + 1;
    if (nextIndex >= quotes.length) {
      nextIndex = 0;
    }
    await metaBox.put('quoteIndexKey', nextIndex);
   // await prefs.setInt(KConstants.quoteIndexKey, nextIndex);
    debugPrint("🔔 Scheduling quote notification...");
    debugPrint("Index: $currentIndex — Quote: ${selectedQuote.quoteTitle}");
  }
}
