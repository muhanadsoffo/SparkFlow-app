import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/views/Widgets/appbar_widget.dart';
import 'package:spark_flow/views/Widgets/navbar_widget.dart';
import 'package:spark_flow/views/pages/home_page.dart';
import 'package:spark_flow/views/pages/Projects/projects_page.dart';
import 'package:spark_flow/views/pages/Quotes/quotes_page.dart';
import 'package:spark_flow/core/notifiers.dart';

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
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidget(),
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
