import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/core/services/permission_service.dart';
import 'package:spark_flow/data/local/hive_config.dart';
import 'package:spark_flow/core/notifiers.dart';
import 'package:spark_flow/views/widgets/user_name_widget.dart';

String? startupError;

void main() async {
  runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    startupError = 'Flutter error: ${details.exceptionAsString()}';
    debugPrint(startupError);
  };


    try {
      await initHive();
      await PermissionServices.requestNotificationPermission();
      await NotificationService.init();
      await AndroidAlarmManager.initialize();
      await NotificationService.scheduleDailyStaticReminder();

      final prefs = await SharedPreferences.getInstance();
      isDarkModeNotifier.value = prefs.getBool(KConstants.themeModeKey) ?? false;
      isDailyQuoteEnabled.value = prefs.getBool(KConstants.quoteNotificationKey) ?? false;
    } catch (e, s) {
      startupError = 'Startup error: $e\n$s';
      debugPrint(startupError);
    }

    runApp(const MyApp());
  }, (error, stackTrace) {
    startupError = 'Uncaught zone error: $error\n$stackTrace';
    debugPrint(startupError);
    runApp(const MyApp()); // Still load the app to show the error
  });
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, darkMode, child) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff7400B8),
              brightness: darkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          debugShowCheckedModeBanner: false,

          home: startupError != null
              ? Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  startupError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          )
              : UserNameWidget(),
        );
      },
    );
  }

  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool(KConstants.themeModeKey);
    isDarkModeNotifier.value = repeat ?? false;
  }

  void initNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    isDailyQuoteEnabled.value =
        prefs.getBool(KConstants.quoteNotificationKey) ?? false;
  }
}
