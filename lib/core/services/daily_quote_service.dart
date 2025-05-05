import 'dart:math';

import 'package:hive/hive.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'notification_service.dart';

class DailyQuoteService {
  static Future<void> scheduleDailyQuoteNotification({
    required int hour,
    required int minute,
  }) async {
    final Box<Quote> box = Hive.box<Quote>('quotes');

    if (box.isEmpty) return;
    // getting all quotes with true status
    final activeQuotes = box.values.where((q) => q.status==true).toList();
    // if nothing left then reset all status
    if(activeQuotes.isEmpty){
      for(int i=0; i<box.length; i++){
        final quote =box.getAt(i);
        if(quote != null){
          quote.status= true;
          quote.save();
        }

      }
      activeQuotes.addAll(box.values.where((q) => q.status== true));
    }
    //now choosing a random quote from the database
    final random= Random();
    final selectedQuote = activeQuotes[random.nextInt(activeQuotes.length)];
    selectedQuote.status= false;
    await selectedQuote.save();

    await NotificationService.scheduleDailyNotification(
      id: 3,
      title: "Your daily Quote",
      body: selectedQuote.quoteTitle,
      hour: hour,
      minute: minute,
    );
  }
}
