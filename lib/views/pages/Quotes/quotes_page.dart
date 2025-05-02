import 'package:flutter/material.dart';
import 'package:spark_flow/views/pages/Quotes/add_quote_page.dart';

import '../../../data/local/boxes.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final quote= Boxes.quotesBox;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(children: [Center(child: Text("${quote.values.first.quoteTitle}, ${quote.values.first.status}"))]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddQuotePage();
              },
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xfffc8300),
      ),
    );
  }
}
