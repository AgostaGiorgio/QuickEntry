import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_entry/models/category.dart';
import 'package:quick_entry/services/hive_service.dart';

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier();
});

class CategoriesNotifier extends StateNotifier<List<Category>> {
  final Box _categoriesBox = HiveService.categoriesBox;

  CategoriesNotifier() : super([]){
    _loadCategories();
  }

  void _loadCategories() {
    List<Category> categories = _categoriesBox.values.toList().cast();
    state = categories;
  }
}
