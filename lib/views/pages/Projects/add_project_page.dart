import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark_flow/core/services/permission_service.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/task_status.dart';

import '../../../data/local/boxes.dart';
import '../../Widgets/appbar_widget.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppbarWidget(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Text(
                  "Add a Project!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Card(
                  color: Colors.white60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              image:
                              _selectedImage != null
                                  ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              color:
                              _selectedImage == null ? Colors.grey : null,
                            ),
                            child:
                            _selectedImage == null
                                ? Center(
                              child: IconButton(
                                onPressed: () async {

                                  final picked = await ImagePicker()
                                      .pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedImage = File(
                                        picked.path,
                                      );
                                    });
                                  }
                                },
                                icon: Icon(Icons.add_a_photo, size: 32),
                              ),
                            )
                                : null,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: TextFormField(
                                controller: titleController,
                                maxLength: 20,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Project Title",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        // this creates a fake black outline
                                        blurRadius: 10,
                                        color: Colors.black,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          if (_selectedImage != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(Icons.delete_sharp, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(

                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF74C0FC), // softer light blue
                              Color(0xFF4EA8DE).withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: descriptionController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: "Project Description",
                                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                FilledButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Add Project"),
                  style: FilledButton.styleFrom(
                    minimumSize: Size(250, 50),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    backgroundColor: Color(0xFF4EA8DE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();
                    if (title.isNotEmpty && description.isNotEmpty) {
                      Boxes.projectBox.put(
                        'key_$title',
                        Project(
                          title: title,
                          description: description,
                          imagePath: _selectedImage?.path,
                          createdAt: DateTime.now(),
                          status: TaskStatus.notStarted
                        ),
                      );
                      titleController.clear();
                      descriptionController.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _selectedImage = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                          content: Text("Project added successfully!"),
                        ),
                      );
                    } else if (title.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                          content: Text("Please fill all the info"),
                        ),
                      );
                    }
                  },

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
