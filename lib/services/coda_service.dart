import 'dart:convert';

import 'package:http/http.dart';
import 'package:quick_entry/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:quick_entry/services/default_values.dart';

class CodaService {

  static Future<Response> saveTransaction(Transaction transaction) async {
    return await http.post(
        Uri.parse(CODA_API),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $CODA_API_KEY',
        },
        body: jsonEncode(transaction.toJson()),
      );
  }

}