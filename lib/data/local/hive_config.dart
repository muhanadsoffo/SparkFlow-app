import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/data/models/todos.dart';

import '../models/task_status.dart';


Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskStatusAdapter());
  // ************* QUOTES *****************
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Quote>('quotes');

  // **************** Projects *****************
  Hive.registerAdapter(ProjectAdapter());
  await Hive.openBox<Project>('projects');

  // ****************** Todos ******************
  Hive.registerAdapter(TodosAdapter());
  await Hive.openBox<Todos>('todos');

 // ******************* TaskStatus Enum ***************

}
