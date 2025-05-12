import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';
import '../../../data/models/task_status.dart';
import '../../../data/models/todos.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key, required this.project});

  final Project project;

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  void initState() {
    super.initState();
    project = widget.project;
  }

  late Project project;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final done =
        widget.project.todos
            ?.where((t) => t.status == TaskStatus.finished)
            .length ??
        0;
    final total = widget.project.todos?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: Color(0xFFff8000),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.project.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(widget.project.imagePath!)),
                ),
              SizedBox(height: 12),
              Text(
                "Created at: ${DateFormat('MMM dd, yyyy').format(widget.project.createdAt)}",
              ),
              SizedBox(height: 12),
              Text("Tasks: $done / $total"),
              SizedBox(height: 12),
              ListTile(
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
                                  setState(() {
                                    project.todos ??= [];
                                    project.todos!.add(newTodo);
                                    project.save();
                                  });
                                  controller.clear();
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
              ),

              // Add task list or other info here

                 ListView.builder(
                  itemCount: project.todos?.length ?? 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final todo = project.todos![index];
                    return ListTile(
                      title: Text(todo.text),
                      trailing: InkWell(
                        onTap: () {
                          TaskStatus nextStatus(TaskStatus current) {
                            final index = TaskStatus.values.indexOf(current);
                            return TaskStatus.values[(index + 1) %
                                TaskStatus.values.length];
                          }

                          setState(() {
                            todo.status = nextStatus(todo.status);
                            project.save();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            todo.status.label,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },

              ),
            ],
          ),
        ),
      ),
    );
  }
}
