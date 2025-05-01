import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_flow/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, value, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white, // match your icon/text color
                ),
              ),
            ),
          ),
          child: NavigationBar(
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.textsms_rounded),
                label: "Quotes",
              ),
              NavigationDestination(
                icon: Icon(CupertinoIcons.home),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.code_outlined),
                label: "Projects",
              ),
            ],
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
            selectedIndex: value,
            backgroundColor: Color(0xFF037cb9),
          ),
        );
      },
    );
  }
}
