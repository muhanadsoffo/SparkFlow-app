import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/views/Widgets/edit_item_widget.dart';
import 'package:spark_flow/views/pages/Quotes/add_quote_page.dart';

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
        child: ValueListenableBuilder(
          valueListenable: Boxes.quotesBox.listenable(),
          builder: (context, Box<Quote> box, _) {
            final quotes = box.values.toList();

            if (quotes.isEmpty) {
              return EmptyPageWidget(title: 'quotes');
            }

            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final quote = box.getAt(index);
                if (quote == null) return SizedBox();

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.lightBlue,
                  surfaceTintColor: Colors.cyan,
                  margin: EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      quote.quoteTitle,
                      // make sure it's `title` not `quoteTitle`
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => EditItemWidget(
                                    initialValue: quote.quoteTitle,
                                    title: "Edit Quote",
                                    onSave: (newValue) {
                                      quote.quoteTitle = newValue;
                                      quote.save();
                                    },
                                  ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Deleting"),
                                  content: Text(
                                    "You are about to delete this quote!",
                                  ),
                                  actions: [
                                    FilledButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Close"),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        box.deleteAt(
                                          index,
                                        ); // ✅ delete from `box`
                                        Navigator.pop(context);
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.deepOrange,
                                      ),
                                      child: Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
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
