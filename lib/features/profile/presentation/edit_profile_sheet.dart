import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../profile_state.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final TextEditingController _controller;
  IconData _selectedAvatar = Icons.person;

  static const List<IconData> _avatars = <IconData>[
    Icons.person,
    Icons.psychology_alt_outlined,
    Icons.shield_moon_outlined,
    Icons.verified_user_outlined,
    Icons.security_outlined,
    Icons.ads_click_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(profileNameProvider));
    _selectedAvatar = ref.read(profileAvatarProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String t(String ru, String kk, String en) {
      switch (Localizations.localeOf(context).languageCode) {
        case 'kk':
          return kk;
        case 'en':
          return en;
        default:
          return ru;
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(t('Редактировать профиль', 'Профильді өңдеу', 'Edit Profile'), style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: t('Имя пользователя', 'Пайдаланушы аты', 'Username')),
          ),
          const SizedBox(height: 12),
          Text(t('Аватар', 'Аватар', 'Avatar'), style: AppTextStyles.secondary),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _avatars
                .map((IconData icon) => GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = icon),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _selectedAvatar == icon
                              ? AppColors.primaryButton
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: AppColors.text),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final String nextName = _controller.text.trim().isEmpty
                    ? deriveNameFromEmail(FirebaseAuth.instance.currentUser?.email)
                    : _controller.text.trim();
                ref.read(profileNameProvider.notifier).state = nextName;
                ref.read(profileAvatarProvider.notifier).state = _selectedAvatar;

                final User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set(<String, dynamic>{'displayName': nextName}, SetOptions(merge: true));
                }

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: Text(t('Сохранить', 'Сақтау', 'Save')),
            ),
          ),
        ],
      ),
    );
  }
}
