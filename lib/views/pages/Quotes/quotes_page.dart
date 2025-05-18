import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/views/Widgets/edit_item_widget.dart';
import 'package:spark_flow/views/pages/Quotes/add_quote_page.dart';
import 'package:spark_flow/views/widgets/notification_switch_widget.dart';

import '../../../data/local/boxes.dart';
import '../../Widgets/empty_page_widget.dart';

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
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Boxes.quotesBox.listenable(),
                builder: (context, Box<Quote> box, _) {
                  final quotes = box.values.toList();

                  if (quotes.isEmpty) {
                    return EmptyPageWidget(title: 'quotes');
                  }

                  return ListView.builder(
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      final quote = box.getAt(index);
                      if (quote == null) return SizedBox();

                      return Card(
                        color: Colors.white30,
                        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.format_quote, color: Color(0xFF7400B8), size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quote.quoteTitle,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => EditItemWidget(
                                                initialValue: quote.quoteTitle,
                                                title: "Edit Quote",
                                                onSave: (newValue) {
                                                  quote.quoteTitle = newValue;
                                                  quote.save();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.redAccent),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Delete Quote"),
                                                  content: Text(
                                                      "Are you sure you want to delete this quote?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context),
                                                      child: Text("Cancel"),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                        Colors.deepOrange,
                                                      ),
                                                      onPressed: () {
                                                        box.deleteAt(index);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Delete"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
                  return AddQuotePage();
                },
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF7400B8),
        ),
      ),
    );

  }
}
