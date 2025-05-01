import 'package:flutter/material.dart';
import 'package:spark_flow/views/pages/Quotes/add_quote_page.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(children: [Center(child: Text("this is quotes"))]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddQuotePage();
          },));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xfffc8300),
      ),
    );
  }
}
