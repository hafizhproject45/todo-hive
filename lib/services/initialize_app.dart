import 'package:hive_flutter/hive_flutter.dart';

class InitializeApp {
  InitializeApp._();

  static Future<void> init() async {
    // Initializing hive
    await Hive.initFlutter();

    await Hive.openBox('TODO_BOX');
  }
}
