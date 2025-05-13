import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spark_flow/views/Widgets/edit_item_widget.dart';

import '../../../data/models/project.dart';

class UpperCardWidget extends StatelessWidget {
  final Project project;
  final bool editable;
  final Function() onChange;

  const UpperCardWidget({
    super.key,
    required this.project,
    this.editable = false,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            height: editable ? 250 : 130,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    project.imagePath != null
                        ? FileImage(File(project.imagePath!))
                        : AssetImage('assets/images/l.png'),
                fit: BoxFit.cover,
              ),
              color: project.imagePath == null ? Colors.grey[300] : null,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              if (editable)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditItemWidget(
                          initialValue: project.title,
                          onSave: (newValue) {
                            project.title = newValue;
                            project.save();
                            onChange();
                          },
                          title: "Edit Title",
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit_outlined,color: Colors.white,),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
