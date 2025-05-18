import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spark_flow/data/models/project.dart';
import 'package:spark_flow/data/models/task_status.dart';

import '../../../data/local/boxes.dart';
import '../../pages/Projects/add_project_page.dart';
import 'indicator.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    // trigger animation after build
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.projectBox.listenable(),
      builder: (context, Box<Project> box, child) {
        final projects = box.values.toList();
        if (projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pie_chart_outline_sharp,
                  size: 200,
                  color: Color(0xffd90429),
                ),
                SizedBox(height: 16),
                Text(
                  "No projects yet!\nLight that Spark inside you and let it Flow",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddProjectPage()),
                    );
                  },
                  child: Text("Add Project"),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(
                  color: Colors.green.shade600,
                  text: 'Finished',
                  isSquare: false,
                  size: touchedIndex == 0 ? 18 : 16,

                ),
                Indicator(
                  color: Colors.orange.shade600,
                  text: 'In Progress',
                  isSquare: false,
                  size: touchedIndex == 1 ? 18 : 16,

                ),
                Indicator(
                  color: Colors.grey,
                  text: 'Not Started',
                  isSquare: false,
                  size: touchedIndex == 2 ? 18 : 16,

                ),

              ],
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(milliseconds: 600),
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(milliseconds: 200),
                  child: PieChart(
                    swapAnimationDuration: Duration(milliseconds: 250),
                    // ✅ smooth animate
                    swapAnimationCurve: Curves.easeInOut,
                    PieChartData(
                      startDegreeOffset: 180,

                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                pieTouchResponse
                                    .touchedSection!
                                    .touchedSectionIndex;
                          });
                        },
                      ),

                      centerSpaceRadius: 0,
                      sectionsSpace: 2,
                      sections: showSections(projects),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> showSections(List<Project> projects) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 150.0 : 130.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
      final finished =
          projects.where((p) => p.status == TaskStatus.finished).length;
      final inProgress =
          projects.where((p) => p.status == TaskStatus.inProgress).length;
      final notStarted =
          projects.where((p) => p.status == TaskStatus.notStarted).length;
      final allProjects = projects.length;
      switch (i) {
        case 0:
          return PieChartSectionData(
            value: finished.toDouble(),
            radius: radius,
            color: Colors.green.shade600,
            title:
                isTouched
                    ? "${finished.toString()} project/s"
                    : "${((finished / allProjects) * 100).toStringAsFixed(0)}%",
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            value: inProgress.toDouble(),
            radius: radius,
            title:
                isTouched
                    ? "${inProgress.toString()} project/s"
                    : "${((inProgress / allProjects) * 100).toStringAsFixed(0)}%",
            color: Colors.orange.shade600,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );

        case 2:
          return PieChartSectionData(
            value: notStarted.toDouble(),
            radius: radius,
            title:
                isTouched
                    ? "${notStarted.toString()} project/s"
                    : "${((notStarted / allProjects) * 100).toStringAsFixed(0)}%",
            color: Colors.grey,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );

        default:
          throw Exception('oh no');
      }
    });
  }
}
