import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';
import '../../../data/models/task_status.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;
  const ProjectDetails({super.key,required this.project });

  @override
  Widget build(BuildContext context) {
    final done = project.todos?.where((t) => t.status == TaskStatus.finished).length ?? 0;
    final total = project.todos?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(project.imagePath!)),
              ),
            SizedBox(height: 12),
            Text("Created at: ${DateFormat('MMM dd, yyyy').format(project.createdAt)}"),
            SizedBox(height: 12),
            Text("Tasks: $done / $total"),
            SizedBox(height: 12),
            // Add task list or other info here
          ],
        ),
      ),
    );
  }
}
