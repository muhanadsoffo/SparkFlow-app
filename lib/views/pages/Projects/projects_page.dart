import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/task_status.dart';
import 'package:spark_flow/views/Widgets/empty_page_widget.dart';
import 'package:spark_flow/views/pages/Projects/project_details.dart';
import '../../../data/local/boxes.dart';
import 'add_project_page.dart';
import 'package:date_format/date_format.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: ValueListenableBuilder(
          valueListenable: Boxes.projectBox.listenable(),
          builder: (context, Box<Project> box, child) {
            final projects = box.values.toList();
            if (projects.isEmpty) {
              return EmptyPageWidget(title: 'projects');
            }
            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 0.70,
              mainAxisSpacing: 5,
              children:
                  projects.map((project) {
                    final todos = project.todos ?? [];
                    final done =
                        todos
                            .where((t) => t.status == TaskStatus.finished)
                            .length;
                    final total = todos.length;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProjectDetails(project: project);
                            },
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            project.imagePath != null
                                                ? FileImage(
                                                  File(project.imagePath!),
                                                )
                                                : AssetImage(
                                                  'assets/images/l.png',
                                                ),
                                        fit: BoxFit.cover,
                                      ),
                                      color:
                                          project.imagePath == null
                                              ? Colors.grey[300]
                                              : null,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Text(
                                    project.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFff8000).withOpacity(0.90),
                                      Color(0xFFffe300).withOpacity(0.90),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      project.status.label,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$done /$total Tasks",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF004F8D),
                                          ),
                                        ),
                                        Text(
                                          total > 0
                                              ? "${((done / total) * 100).toStringAsFixed(0)}% Done"
                                              : "0% Done",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF004F8D),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "Created at: ${DateFormat('MMM dd, yyyy').format(project.createdAt)}",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddProjectPage();
                },
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xfffc8300),
        ),
      ),
    );
  }
}
