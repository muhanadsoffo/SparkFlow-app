import 'package:flutter/material.dart';
import 'package:spark_flow/views/widgets/project_widgets/add_task_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/bottom_card_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/todo_list_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/upper_card_widget.dart';
import '../../../data/models/project.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("You are about to delete this Project!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await project.delete();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
        backgroundColor: Color(0xFF4EA8DE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpperCardWidget(
                project: project,
                editable: true,
                onChange: () {
                  setState(() {});
                },
              ),
              BottomCardWidget(
                project: project,
                editable: true,
                onChange: () {
                  setState(() {});
                },
              ),
              AddTaskWidget(
                project: project,
                onChanged: () {
                  setState(() {});
                },
              ),
              // Add task list or other info here
              TodoListWidget(
                project: project,
                onStatusChanged: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
