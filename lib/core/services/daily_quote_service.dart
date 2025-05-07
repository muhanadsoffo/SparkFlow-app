import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';



class DailyQuoteService {
  static Future<void> scheduleDailyQuoteNotification({
    required int hour,
    required int minute,
  }) async {
    final Box<Quote> box = Hive.box<Quote>('quotes');
    final quotes = box.values.toList();
    if (quotes.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    int currentIndex= prefs.getInt(KConstants.quoteIndexKEy)?? 0;


    // if nothing left then reset all status
    if(currentIndex>=quotes.length){
      currentIndex=0;

      }
      final selectedQuote= quotes[currentIndex];
    await prefs.setInt(KConstants.quoteIndexKEy, currentIndex+1);

    await NotificationService.scheduleDailyNotification(
      id: 3,
      title: "Your daily Quote",
      body: selectedQuote.quoteTitle,
      hour: hour,
      minute: minute,
    );
  }
}
