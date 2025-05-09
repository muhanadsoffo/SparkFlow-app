import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 2)

class Todo extends HiveObject{

  @HiveField(0)
  String text;

  @HiveField(1)
  bool status;

  Todo(
   this.text,
    this.status
);
}