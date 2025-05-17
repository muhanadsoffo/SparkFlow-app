import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/views/widgets/pie_chart_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("hi there"),

              PieChartWidget(),
            ],
          ),
        ),
      ),
    );

  }
}
