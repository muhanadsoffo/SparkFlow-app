import 'package:hive/hive.dart';
import 'package:spark_flow/data/models/task_status.dart';

part 'todos.g.dart';

@HiveType(typeId : 6)
class Todos extends HiveObject{

  @HiveField(0)
  String text;

  @HiveField(1)
  TaskStatus status;

  Todos({required this.text, required this.status});

}