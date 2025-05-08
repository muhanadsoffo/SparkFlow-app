import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_flow/core/constants.dart';
import 'package:spark_flow/core/services/notification_service.dart';
import 'package:spark_flow/core/services/permission_service.dart';
import 'package:spark_flow/data/local/hive_config.dart';
import 'package:spark_flow/core/notifiers.dart';
import 'package:spark_flow/views/widget_tree.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await PermissionServices.requestNotificationPermission();
  await initHive();

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initThemeMode();
    initNotifications();
    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: isDarkModeNotifier, builder: (context, darkMode, child) {
      return MaterialApp(
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfffb8301),brightness:darkMode ? Brightness.dark : Brightness.light),),
          debugShowCheckedModeBanner: false,
          home: WidgetTree()
      );
    },);


  }

  void initThemeMode() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool(KConstants.themeModeKey);
    isDarkModeNotifier.value = repeat ?? false;
  }
  void initNotifications() async{
    final prefs = await SharedPreferences.getInstance();
    isDailyQuoteEnabled.value= prefs.getBool(KConstants.quoteNotificationKey) ?? false;
  }
}
