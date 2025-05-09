import 'package:hive/hive.dart';
import 'todo.dart';

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

  @HiveField(4)
  List<Todo>? todos;

  Project({
    required this.title,
    required this.description,
    this.imagePath,
    required this.createdAt,
    this.todos,
});
}