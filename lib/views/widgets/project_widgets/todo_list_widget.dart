import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/task_status.dart';
import 'package:spark_flow/views/Widgets/edit_item_widget.dart';

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
        return Colors.blueGrey;
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
        return Container(
          margin:  const EdgeInsets.symmetric(vertical: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Slidable(
              key: ValueKey(todo.text),
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                extentRatio: 0.4,
                children: [
                  SlidableAction(

                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EditItemWidget(
                            initialValue: todo.text,
                            onSave: (newValue) {
                              final trimmed = newValue.trim();
                              if (trimmed.isNotEmpty) {
                                todo.text = trimmed;
                                project.save();
                                onStatusChanged();
                              }
                            },
                          );
                        },
                      );
                    },
                    backgroundColor: Colors.blueAccent,
                    icon: Icons.edit,
                    
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      project.todos?.removeAt(index);
                      project.save();
                      onStatusChanged();
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                  ),
                ],
              ),
              child: Card(
                color: Colors.white70,
                margin: EdgeInsets.only( bottom: 2,left: 2,right: 2),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  leading: Icon(Icons.check_circle, color: statusColor),
                  title: Text(
                    todo.text,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
