import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spark_flow/data/models/quote.dart';
import 'package:spark_flow/views/pages/Quotes/add_quote_page.dart';

import '../../../data/local/boxes.dart';

class QuoteOfTheDay extends StatefulWidget {
  const QuoteOfTheDay({super.key});

  @override
  State<QuoteOfTheDay> createState() => _QuoteOfTheDayState();
}

class _QuoteOfTheDayState extends State<QuoteOfTheDay> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.quotesBox.listenable(),
      builder: (context, Box<Quote> quotes, child) {
        if (quotes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_comment_rounded,
                  size: 100,
                  color: Color(0xffd90429),
                  shadows: [Shadow(blurRadius: 3)],
                ),
                SizedBox(height: 16),
                Text(
                  "No Quotes yet!\nLight that Spark inside you and let it Flow",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddQuotePage()),
                    );
                  },
                  child: Text("Add Quote"),
                ),
              ],
            ),
          );
        }
        final quoteList = quotes.values.toList();
        final randomIndex = Random().nextInt(quoteList.length);
        final randomQuote = quoteList[randomIndex];
        return Container(

          width: double.infinity,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white60,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '"${randomQuote.quoteTitle}"',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
