import 'package:hive/hive.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/data/models/todos.dart';

class Boxes{
  static Box<Quote> get quotesBox => Hive.box<Quote>('quotes');
  static Box<Project> get projectBox => Hive.box<Project>('projects');
  static Box<Todos> get todosBox => Hive.box<Todos>('todos');
}