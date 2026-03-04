import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/module_models.dart';
import 'module_repository.dart';

final moduleRepositoryProvider = Provider<ModuleRepository>((Ref ref) {
  return ModuleRepository();
});

final modulesProvider = FutureProvider<List<Module>>((Ref ref) async {
  final ModuleRepository repo = ref.read(moduleRepositoryProvider);
  return repo.loadModules();
});
