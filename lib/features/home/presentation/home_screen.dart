import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/fact_service.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/fact_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> factAsync = ref.watch(factOfTheDayProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hello, Bushiridzo', style: AppTextStyles.screenTitle),
                    const SizedBox(height: 4),
                    Text('Stay sharp today.', style: AppTextStyles.secondary),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          factAsync.when(
            data: (String fact) => FactCard(
              title: 'Interesting fact of the day',
              text: fact,
            ),
            loading: () => const _LoadingCard(),
            error: (_, __) => const FactCard(
              title: 'Interesting fact of the day',
              text: 'Cybersecurity starts with habits: update apps, use MFA, and verify links before opening.',
            ),
          ),
          const SizedBox(height: 16),
          ContinueLearningCard(
            courseTitle: 'Social Engineering and Human Factor',
            subtitle: 'Module 2 • Lesson 3',
            progress: 0.42,
            onResume: () {},
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

