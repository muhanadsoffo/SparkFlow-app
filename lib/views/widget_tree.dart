import 'package:flutter/material.dart';
import 'package:spark_flow/views/Widgets/navbar_widget.dart';
import 'package:spark_flow/views/pages/home_page.dart';
import 'package:spark_flow/views/pages/projects_page.dart';
import 'package:spark_flow/views/pages/quotes_page.dart';
import 'package:spark_flow/data/notifiers.dart';


List<Widget> pages= [QuotesPage(),HomePage(),ProjectsPage()];

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, value, child) {
       return pages.elementAt(value);
      },
        ),
        bottomNavigationBar: NavbarWidget()
    );
  }
}
