import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations s = AppLocalizations.of(context)!;

    return SiruLayout(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 84),
          Text(
            s.verifyMailTitle,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Text(s.sentCode),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLength: 4,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black, fontSize: 22),
            decoration: InputDecoration(
              counterText: '',
              hintText: '8221',
              hintStyle: const TextStyle(color: Color(0x80000000)),
              filled: true,
              fillColor: const Color(0xFFD9D9D9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_controller.text.trim().length < 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.wrongCode)),
                  );
                  return;
                }
                context.go('/auth/reset');
              },
              child: Text(s.verify),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.codeSent)),
              );
            },
            child: Text(s.resendCode),
          ),
        ],
      ),
    );
  }
}
