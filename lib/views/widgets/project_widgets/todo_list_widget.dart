import 'package:flutter/material.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/task_status.dart';

class TodoListWidget extends StatelessWidget {
  final Project project;
  final Function() onStatusChanged;

  const TodoListWidget({
    super.key,
    required this.project,
    required this.onStatusChanged,
  });

  TaskStatus nextStatus(TaskStatus current) {
    final index = TaskStatus.values.indexOf(current);
    return TaskStatus.values[(index + 1) % TaskStatus.values.length];
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.finished:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = project.todos ?? [];
    return ListView.builder(
      itemCount: todos.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final todo = todos[index];
        final statusColor = _getStatusColor(todo.status);
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            leading: Icon(Icons.check_circle, color: statusColor),
            title: Text(
              todo.text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: InkWell(
              onTap: () {
                todo.status = nextStatus(todo.status);
                project.save();
                onStatusChanged();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: statusColor.withOpacity(0.2),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  todo.status.label,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
