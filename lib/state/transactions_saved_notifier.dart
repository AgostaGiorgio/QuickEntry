import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_entry/services/hive_service.dart';

final transactionSavedProvider = StateNotifierProvider<TransactionsSavedNotifier, List<int>>((ref) {
  return TransactionsSavedNotifier();
});

class TransactionsSavedNotifier extends StateNotifier<List<int>> {
  final Box _lastTransactionIdsBox = HiveService.savedSmsIdsBox;

  TransactionsSavedNotifier() : super([]) {
    _loadIds();
  }

  void _loadIds() {
    List<int> lastIds = _lastTransactionIdsBox.values.toList().cast();
    state = lastIds;
  }

  void addIds(int id) {
    List<int> currentIds = List.from(state);
    currentIds.add(id);

    _lastTransactionIdsBox.add(id);
    state = currentIds;
  }
}
