import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        context.go('/language');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SiruLayout(
      child: Center(
        child: Text(
          'SIRU',
          style: TextStyle(fontSize: 64, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
