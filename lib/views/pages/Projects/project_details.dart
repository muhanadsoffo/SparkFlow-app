import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spark_flow/views/widgets/project_widgets/add_task_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/bottom_card_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/todo_list_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/upper_card_widget.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: Color(0xFF4EA8DE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
