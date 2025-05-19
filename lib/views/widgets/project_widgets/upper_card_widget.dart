import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                        : AssetImage('assets/images/flog.png'),
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
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    project.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
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
                          title: "Edit Title",
                          onSave: (newValue) {
                            if (newValue.length <= 20) {
                              project.title = newValue;
                              project.save();
                              onChange();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Title can't be longer than 20 characters."),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5)],
                  ),
                ),

            ],
          ),
        ),
        if (editable)
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) project.imagePath = picked.path;
                    project.save();
                    onChange();
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5)],
                  ),
                ),
                if (project.imagePath != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_sharp,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 5)],
                    ),
                    onPressed: () {
                      project.imagePath = null;
                      project.save();
                      onChange();
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
