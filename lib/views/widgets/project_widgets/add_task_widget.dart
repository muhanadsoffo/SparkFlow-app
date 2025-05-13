import 'package:flutter/material.dart';
import 'package:spark_flow/data/models/project.dart';

import '../../../data/models/task_status.dart';
import '../../../data/models/todos.dart';

class AddTaskWidget extends StatelessWidget {
  final Project project;
  final Function() onChanged;
  const AddTaskWidget({super.key, required this.project, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return ListTile(
      title: Text(
        "Todo List :",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("New Task"),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: "Task Text"),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        final newTodo = Todos(
                          text: controller.text,
                          status: TaskStatus.notStarted,
                        );

                          project.todos ??= [];
                          project.todos!.add(newTodo);
                          project.save();
                        controller.clear();
                        onChanged();
                        Navigator.pop(context);
                      } else if (controller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 5),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            content: Text("Text should not be empty"),
                          ),
                        );
                      }
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}
