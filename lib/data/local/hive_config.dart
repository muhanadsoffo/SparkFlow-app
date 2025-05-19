import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/data/models/todos.dart';

import '../models/task_status.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // *************** Regıstering Adapters *********************
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(QuoteAdapter());
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(TodosAdapter());

  // ************* Opening Boxes *****************
  await Hive.openBox<Quote>('quotes');
  await Hive.openBox<Project>('projects');
  await Hive.openBox<Todos>('todos');
  await Hive.openBox('quote_meta');
}
