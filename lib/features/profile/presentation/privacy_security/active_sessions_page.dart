import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ActiveSessionsPage extends StatelessWidget {
  const ActiveSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Sessions')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const _SessionTile(
            device: 'Current device',
            details: 'This session is active now.',
            current: true,
          ),
          const SizedBox(height: 10),
          const _SessionTile(
            device: 'Recent session',
            details: 'Last seen recently',
            current: false,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Action will be wired to backend next iteration.')),
              );
            },
            child: const Text('Sign out all other sessions'),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.device,
    required this.details,
    required this.current,
  });

  final String device;
  final String details;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Icon(current ? Icons.phone_android : Icons.devices,
              color: AppColors.text),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(device, style: AppTextStyles.body),
                const SizedBox(height: 2),
                Text(details, style: AppTextStyles.secondary),
              ],
            ),
          ),
          if (current) Text('Current', style: AppTextStyles.chip),
        ],
      ),
    );
  }
}
