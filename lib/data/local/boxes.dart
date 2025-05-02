import 'package:hive/hive.dart';
import 'package:spark_flow/data/models/quote.dart';

class Boxes{
  static Box<Quote> get quotesBox => Hive.box<Quote>('quotes');
}