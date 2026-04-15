import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ManageEmailPage extends StatefulWidget {
  const ManageEmailPage({super.key});

  @override
  State<ManageEmailPage> createState() => _ManageEmailPageState();
}

class _ManageEmailPageState extends State<ManageEmailPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  bool _loading = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _sendVerification() async {
    final User? user = _user;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      await user.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent.')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${e.code}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _changeEmail() async {
    final User? user = _user;
    final String newEmail = _emailCtrl.text.trim();
    if (user == null || newEmail.isEmpty) return;

    setState(() => _loading = true);
    try {
      await user.verifyBeforeUpdateEmail(newEmail);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check new email to confirm change.')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Could not change email'),
          content: Text('Code: ${e.code}\nRe-authentication may be required.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _user;
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Email')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text('Current email: ${user?.email ?? "-"}',
              style: AppTextStyles.body),
          const SizedBox(height: 6),
          Text('Verified: ${user?.emailVerified ?? false}',
              style: AppTextStyles.secondary),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('ps.email.sendVerification'),
            onPressed: _loading ? null : _sendVerification,
            child: const Text('Send verification email'),
          ),
          const SizedBox(height: 20),
          TextField(
            key: const Key('ps.email.newEmailField'),
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'New email'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            key: const Key('ps.email.changeEmail'),
            onPressed: _loading ? null : _changeEmail,
            child: const Text('Change email'),
          ),
        ],
      ),
    );
  }
}
