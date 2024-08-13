import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_hive/presentation/pages/home/main_homepage.dart';

import 'core/utils/colors.dart';
import 'services/initialize_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force orientation portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await InitializeApp.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.accent,
          primary: AppColor.accent,
          brightness: Brightness.light,
        ),
      ),
      home: const HomePage(),
    );
  }
}
