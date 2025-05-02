import 'package:hive/hive.dart';

part 'quote.g.dart';


@HiveType(typeId: 0)

class Quote extends HiveObject{
  @HiveField(0)
  String quoteTitle;

  @HiveField(1)
  bool status;

  Quote(this.quoteTitle,this.status);
}