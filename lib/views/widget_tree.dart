import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/data/constants.dart';
import 'package:spark_flow/views/Widgets/navbar_widget.dart';
import 'package:spark_flow/views/pages/home_page.dart';
import 'package:spark_flow/views/pages/Projects/projects_page.dart';
import 'package:spark_flow/views/pages/Quotes/quotes_page.dart';
import 'package:spark_flow/data/notifiers.dart';

List<Widget> pages = [QuotesPage(), HomePage(), ProjectsPage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SparkFlow"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              isDarkModeNotifier.value  = !isDarkModeNotifier.value;
              final SharedPreferences prefs=await SharedPreferences.getInstance();
              await prefs.setBool(KConstants.themeModeKey, isDarkModeNotifier.value);
            },

            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, value, child) {
                return Icon(value ? Icons.light_mode_rounded : Icons.dark_mode);
              },
            ),
          ),
        ],
        backgroundColor: Color(0xFF037cb9),
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, value, child) {
          return pages.elementAt(value);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
