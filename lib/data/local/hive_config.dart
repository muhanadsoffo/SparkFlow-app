import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark_flow/data/models/quote.dart';


Future<void> initHive() async{

  await Hive.initFlutter();

// ************* QUOTES *****************
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Quote>('quotes');

}