import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_flow/core/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, value, child) {
        return ConvexAppBar(
          style: TabStyle.reactCircle,
          gradient: LinearGradient(
            colors:
            [Color(0xFF48BFE3),
              Color(0xFF7400B8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          activeColor: Colors.white,
          color: Colors.white70,
          elevation: 8,

          initialActiveIndex: value,
          height: 65,

          items: [
            TabItem(icon: Icons.textsms_rounded, title: 'Quotes'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.code_rounded, title: 'Projects'),
          ],
          onTap: (index) {
            selectedPageNotifier.value = index;
          },
        );
      },
    );
  }
}
