import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_entry/models/transaction.dart';
import 'package:quick_entry/services/hive_service.dart';
import 'package:quick_entry/state/transactions_saved_notifier.dart';

final lastDateSavedProvider = StateNotifierProvider<LastDateSavedNotifier, int>((ref) {
  TransactionsSavedNotifier transactionsSavedNotifier = ref.watch(transactionSavedProvider.notifier);
  return LastDateSavedNotifier(transactionsSavedNotifier);
});

class LastDateSavedNotifier extends StateNotifier<int> {
  final Box _lastDateBox = HiveService.lastDateBox;

  final TransactionsSavedNotifier _transactionsSavedNotifier;

  LastDateSavedNotifier(this._transactionsSavedNotifier) : super(0) {
    _loadDate();
  }

  void _loadDate() async {
    int lastDate = _lastDateBox.get("last_date",
        defaultValue: DateTime.now().millisecondsSinceEpoch) as int;
    state = lastDate;
  }

  void updateLastDate(Transaction transaction) {
    _lastDateBox.put("last_date", transaction.timestamp);
    state = transaction.timestamp;

    _transactionsSavedNotifier.addIds(transaction.id);
  }
}
