import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/module_models.dart';

class ModuleRepository {
  Future<List<Module>> loadModules() async {
    final String raw = await rootBundle.loadString('assets/data/modules.json');
    final dynamic decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) {
      return <Module>[];
    }

    final List<dynamic> modules = (decoded['modules'] as List<dynamic>?) ?? <dynamic>[];

    return modules
        .whereType<Map<String, dynamic>>()
        .map(Module.fromJson)
        .where((Module m) => m.id.isNotEmpty)
        .toList();
  }
}
