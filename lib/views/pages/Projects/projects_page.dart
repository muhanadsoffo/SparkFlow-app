import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/task_status.dart';
import 'package:spark_flow/views/Widgets/empty_page_widget.dart';
import 'package:spark_flow/views/pages/Projects/project_details.dart';
import 'package:spark_flow/views/widgets/project_widgets/bottom_card_widget.dart';
import 'package:spark_flow/views/widgets/project_widgets/upper_card_widget.dart';
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
                            UpperCardWidget(
                              project: project,
                              onChange: () {
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: BottomCardWidget(
                                project: project,
                                onChange: () {
                                  setState(() {});
                                },
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
          backgroundColor: Color(0xFF4EA8DE),
        ),
      ),
    );
  }
}
