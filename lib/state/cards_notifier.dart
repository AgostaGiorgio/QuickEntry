import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_entry/services/hive_service.dart';

final cardsProvider = StateNotifierProvider<CardsNotifier, List<String>>((ref) {
  return CardsNotifier();
});

class CardsNotifier extends StateNotifier<List<String>> {
  final Box _cardsBox = HiveService.cardsBox;

  CardsNotifier() : super([]){
    _loadCards();
  }

  void _loadCards() {
    List<String> cards = _cardsBox.values.toList().cast();
    state = cards;
  }
}
