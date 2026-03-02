import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final factOfTheDayProvider = FutureProvider<String>((Ref ref) async {
  final FactService service = FactService();
  return service.getFactOfTheDay();
});

class FactService {
  Future<String> getFactOfTheDay() async {
    final String raw = await rootBundle.loadString('assets/data/facts.json');
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    if (decoded.isEmpty) return 'No facts available.';

    final DateTime now = DateTime.now();
    final int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final int index = dayOfYear % decoded.length;

    return decoded[index].toString();
  }
}

