import 'dart:math';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

void quoteNotificationTaskDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if(task=="dailyQuoteTask"){
      await Hive.initFlutter();
      Hive.registerAdapter(QuoteAdapter());
      await Hive.openBox<Quote>('quotes');
      await NotificationService.init();

      // 🧠 Use your existing logic
      await DailyQuoteService.scheduleDailyQuoteNotification(
        hour: 14,   // <- you can make this dynamic later
        minute: 42,
      );

      return Future.value(true);
    }
    return Future.value(false);
  });
}

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
