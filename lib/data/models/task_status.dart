import 'package:hive/hive.dart';

part 'task_status.g.dart';

@HiveType(typeId :4)

enum TaskStatus{

  @HiveField(0)
  notStarted ,

  @HiveField(1)
  inProgress ,

  @HiveField(2)
  finished ,

}