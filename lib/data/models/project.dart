import 'package:hive/hive.dart';
import 'package:spark_flow/data/models/task_status.dart';
import 'todos.dart';

part 'project.g.dart';

@HiveType(typeId: 3)

class Project extends HiveObject{

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String ? imagePath;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(5)
  TaskStatus status;

  @HiveField(6)
  List<Todos>? todos;
  Project({
    required this.title,
    required this.description,
    this.imagePath,
    required this.createdAt,
    this.todos,
    required this.status,
});
}