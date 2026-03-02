import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

final profileNameProvider = StateProvider<String>((Ref ref) => 'Bushiridzo');
final profileAvatarProvider = StateProvider<IconData>((Ref ref) => Icons.person);

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
          Text('Edit Profile', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Username'),
          ),
          const SizedBox(height: 12),
          Text('Avatar', style: AppTextStyles.secondary),
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
              onPressed: () {
                ref.read(profileNameProvider.notifier).state =
                    _controller.text.trim().isEmpty ? 'Bushiridzo' : _controller.text.trim();
                ref.read(profileAvatarProvider.notifier).state = _selectedAvatar;
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

