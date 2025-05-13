import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';
import '../../../data/models/task_status.dart';
import '../edit_item_widget.dart';

class BottomCardWidget extends StatelessWidget {
  final Project project;
  final bool editable;
  final Function() onChange;

  const BottomCardWidget({
    super.key,
    required this.project,
    this.editable = false,
    required this.onChange,
  });

  TaskStatus nextStatus(TaskStatus current) {
    final index = TaskStatus.values.indexOf(current);
    return TaskStatus.values[(index + 1) % TaskStatus.values.length];
  }

  @override
  Widget build(BuildContext context) {
    final todos = project.todos ?? [];
    final done = todos.where((t) => t.status == TaskStatus.finished).length;
    final total = todos.length;
    return Container(
      height: editable ? 240 : null,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF74C0FC), // softer light blue
            Color(0xFF4EA8DE).withOpacity(0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          InkWell(
            onTap:
                editable
                    ? () {
                      project.status = nextStatus(project.status);
                      project.save();
                      onChange();
                    }
                    : null,
            child: Text(
              project.status.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: editable ? 20 : 16,
              ),
            ),
          ),
          if (editable)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: editable ? 18 : 13,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditItemWidget(
                              initialValue: project.description,
                              onSave: (newValue) {
                                project.description = newValue;
                                project.save();
                                onChange();
                              },
                              title: "Edit Title",
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),

                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$done /$total Tasks",
                style: TextStyle(
                  fontSize: editable ? 20 : 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9a031e),
                ),
              ),
              Text(
                total > 0
                    ? "${((done / total) * 100).toStringAsFixed(0)}% Done"
                    : "0% Done",
                style: TextStyle(
                  fontSize: editable ? 20 : 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4f772d),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Created at: ${DateFormat('MMM dd, yyyy').format(project.createdAt)}",
              style: TextStyle(
                fontSize: editable ? 13 : 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
