import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileNameProvider = StateProvider<String>((Ref ref) => '');
final profileAvatarProvider = StateProvider<IconData>((Ref ref) => Icons.person);

final effectiveProfileNameProvider = Provider<String>((Ref ref) {
  final String name = ref.watch(profileNameProvider).trim();
  if (name.isNotEmpty) return name;
  return deriveNameFromEmail(FirebaseAuth.instance.currentUser?.email);
});

final profileBootstrapProvider = FutureProvider<void>((Ref ref) async {
  final String current = ref.read(profileNameProvider).trim();
  if (current.isNotEmpty) return;

  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ref.read(profileNameProvider.notifier).state = 'User';
    return;
  }

  final String emailBasedName = deriveNameFromEmail(user.email);
  String resolvedName = emailBasedName;

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final snap = await docRef.get();
  if (snap.exists) {
    final data = snap.data();
    final String? fromDb = (data?['displayName'] as String?)?.trim();
    if (fromDb != null && fromDb.isNotEmpty) {
      resolvedName = fromDb;
    } else {
      await docRef.set(<String, dynamic>{'displayName': emailBasedName}, SetOptions(merge: true));
    }
  } else {
    await docRef.set(<String, dynamic>{
      'uid': user.uid,
      'email': user.email,
      'displayName': emailBasedName,
      'provider': user.providerData.isNotEmpty ? user.providerData.first.providerId : 'password',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  ref.read(profileNameProvider.notifier).state = resolvedName;
});

String deriveNameFromEmail(String? email) {
  final String localPart = (email ?? '').split('@').first.trim();
  if (localPart.isEmpty) return 'User';
  return '${localPart[0].toUpperCase()}${localPart.substring(1)}';
}

