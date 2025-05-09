import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/data/models/todo.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // ************* QUOTES *****************
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Quote>('quotes');

  // **************** Projects *****************
  Hive.registerAdapter(ProjectAdapter());
  await Hive.openBox<Project>('projects');

  // ****************** Todos ******************
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
}
