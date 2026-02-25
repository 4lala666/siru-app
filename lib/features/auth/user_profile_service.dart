import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileServiceProvider = Provider<UserProfileService>(
  (Ref ref) => UserProfileService(),
);

class UserProfileService {
  Future<void> ensureUserDoc(Object user, {String? localeCode}) async {}

  Future<void> updateLocale(String uid, String localeCode) async {}
}
