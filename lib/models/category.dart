import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> subcategories;

  @HiveField(3)
  bool isPrimary;

  Category({
    required this.id,
    required this.name,
    this.subcategories = const [],
    this.isPrimary = false,
  });
}
