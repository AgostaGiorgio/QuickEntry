import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_entry/models/category.dart';
import 'package:quick_entry/models/default_data.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(CategoryAdapter());

    // Open boxes
    await Hive.openBox('settings');
    await Hive.openBox<int>('saved_sms_ids');
    Box lastDateBox = await Hive.openBox<int>('last_date');
    Box categoriesBox = await Hive.openBox<Category>('categories');
    Box cardsBox = await Hive.openBox<String>('cards');

    if (categoriesBox.isEmpty) {
      await categoriesBox.addAll(DEFAULT_CATEGORIES);
    }

    if (cardsBox.isEmpty) {
      await cardsBox.addAll(DEFAULT_CARD_ACCOUNTS);
    }

    if (lastDateBox.isEmpty) {
      DateTime now = DateTime(
        DateTime.now().year, 
        DateTime.now().month, 
        DateTime.now().day);
      await lastDateBox.put("last_date", now.millisecondsSinceEpoch);
    }
  }

  static Box get settingsBox => Hive.box('settings');
  static Box<Category> get categoriesBox => Hive.box<Category>('categories');
  static Box<String> get cardsBox => Hive.box<String>('cards');
  static Box<int> get lastDateBox => Hive.box<int>('last_date');
  static Box<int> get savedSmsIdsBox => Hive.box<int>('saved_sms_ids');
}
