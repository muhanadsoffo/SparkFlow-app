import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/views/pages/settings_page.dart';

import '../../core/constants.dart';
import '../../core/notifiers.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // fallback
          ),
          children: const [
            TextSpan(
              text: "Spark",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30, // orange
              ),
            ),
            TextSpan(
              text: "Flow",
              style: TextStyle(
                color: Color(0xff7904a2),
                fontSize: 30, // deep blue
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            isDarkModeNotifier.value = !isDarkModeNotifier.value;
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool(
              KConstants.themeModeKey,
              isDarkModeNotifier.value,
            );
          },

          icon: ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context, value, child) {
              return Icon(value ? Icons.light_mode_rounded : Icons.dark_mode_rounded);
            },
          ),
        ),
        IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SettingsPage();
          },));
        }, icon: Icon(Icons.settings)),
      ],
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF48BFE3),
              Color(0xFF7400B8),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
