import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_ctrl.text.trim().toUpperCase() != 'DELETE') return;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Request accepted'),
        content: const Text(
          'Account deletion flow will be connected in iteration 2 with re-auth and backend checks.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'This action is irreversible. Enter DELETE to continue.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('ps.delete.confirmField'),
            controller: _ctrl,
            decoration: const InputDecoration(labelText: 'Type DELETE'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            key: const Key('ps.delete.submit'),
            onPressed: _submit,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
