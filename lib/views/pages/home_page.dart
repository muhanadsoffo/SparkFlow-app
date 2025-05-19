import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/views/widgets/home_widgets/animated_text_widget.dart';
import 'package:spark_flow/views/widgets/home_widgets/pie_chart_widget.dart';
import 'package:spark_flow/views/widgets/home_widgets/quote_of_the_day.dart';

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
              AnimatedTextWidget(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.bar_chart,color: Colors.yellowAccent,shadows: [Shadow(blurRadius: 6)],size: 30,),
                  Text(
                    " Projects Chart:",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20,),


              PieChartWidget(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded,color: Colors.yellowAccent,shadows: [Shadow(blurRadius: 6)],size: 30,),
                  Text(
                    " Quote Section:",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                ],
              ),
              QuoteOfTheDay(),
            ],
          ),
        ),
      ),
    );
  }


}
