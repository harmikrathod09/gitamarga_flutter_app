import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class _Situation {
  final String emoji;
  final String key;
  final Color color;
  final int chapter;
  final int verse;
  final String teaching;
  final List<String> actions;

  const _Situation({
    required this.emoji,
    required this.key,
    required this.color,
    required this.chapter,
    required this.verse,
    required this.teaching,
    required this.actions,
  });
}

final _situations = [
  _Situation(
    emoji: '😰',
    key: 'stress',
    color: AppColors.situationStress,
    chapter: 2,
    verse: 47,
    teaching: 'You have control only over your actions, not the results. When stressed about outcomes, return to the present action with full sincerity.',
    actions: [
      'Write down what you can actually control right now.',
      'Take one meaningful, focused action today.',
      'Release attachment to how things will turn out.',
    ],
  ),
  _Situation(
    emoji: '😔',
    key: 'sadness',
    color: AppColors.situationSadness,
    chapter: 2,
    verse: 19,
    teaching: 'The soul is eternal and cannot be destroyed. What you experience is temporary. True sadness comes from over-identification with the impermanent.',
    actions: [
      'Remind yourself: this too shall pass.',
      'Serve someone else today — it shifts perspective.',
      'Meditate for 10 minutes on the eternal nature of your being.',
    ],
  ),
  _Situation(
    emoji: '🤔',
    key: 'confusion',
    color: AppColors.situationFocus,
    chapter: 3,
    verse: 27,
    teaching: 'Confusion arises when we forget our nature and our duty. Return to your Svadharma — your authentic role — and clarity will follow.',
    actions: [
      'List your core values and which action aligns with them.',
      'Ask: "What is my duty in this situation?"',
      'Let go of attachment to all outcomes and choose with integrity.',
    ],
  ),
  _Situation(
    emoji: '🔥',
    key: 'anger',
    color: AppColors.situationAnger,
    chapter: 2,
    verse: 63,
    teaching: 'Anger begins with desire. From anger comes delusion, from delusion comes loss of wisdom. Practice pause — between stimulus and response lies your freedom.',
    actions: [
      'Before responding, take 10 deep breaths.',
      'Ask: "Is my reaction proportionate to the situation?"',
      'Channel the energy of anger into purposeful action instead.',
    ],
  ),
  _Situation(
    emoji: '🎯',
    key: 'focus',
    color: AppColors.situationFocus,
    chapter: 6,
    verse: 5,
    teaching: 'The mind can be both your greatest ally and your worst enemy. Discipline the restless mind through practice and detachment.',
    actions: [
      'Set one clear intention for today — and protect it.',
      'Eliminate one distraction from your environment.',
      'Practice 5 minutes of breath awareness to train attention.',
    ],
  ),
  _Situation(
    emoji: '💼',
    key: 'work',
    color: AppColors.situationWork,
    chapter: 3,
    verse: 9,
    teaching: 'Work done as a sacrifice — without attachment to credit or reward — becomes a spiritual act. Your work is your offering to the world.',
    actions: [
      'Complete your most important task first, without distraction.',
      'Do your work as an offering, not as a transaction.',
      'Celebrate effort, not just achievement.',
    ],
  ),
  _Situation(
    emoji: '❤️',
    key: 'relationships',
    color: AppColors.situationAnger,
    chapter: 12,
    verse: 13,
    teaching: 'True love is free of envy, possessiveness, and ego. The highest relationship is one where you see the divine in the other person.',
    actions: [
      'Practice one act of genuine kindness today without expectation.',
      'Listen to someone fully — without planning your response.',
      'Forgive one small grievance you\'ve been holding.',
    ],
  ),
  _Situation(
    emoji: '🧘',
    key: 'peace',
    color: AppColors.situationPeace,
    chapter: 6,
    verse: 15,
    teaching: 'Peace comes not from external circumstances but from a mind disciplined through practice. The steadfast yogi finds peace in stillness.',
    actions: [
      'Sit in silence for 10 minutes with no agenda.',
      'Reduce one source of unnecessary mental noise today.',
      'Practice gratitude for three specific things right now.',
    ],
  ),
  _Situation(
    emoji: '💪',
    key: 'courage',
    color: AppColors.situationCourage,
    chapter: 2,
    verse: 3,
    teaching: 'Yield not to unmanliness, O Arjuna! It does not become you. Shake off your faint-heartedness and arise! Your strength comes from knowledge, not from circumstance.',
    actions: [
      'Do the one thing you\'ve been avoiding — start with 2 minutes.',
      'Remember a time you overcame difficulty. You did it before.',
      'Act from your values, not from your fears.',
    ],
  ),
];

class ApplyGitaScreen extends StatefulWidget {
  const ApplyGitaScreen({super.key});

  @override
  State<ApplyGitaScreen> createState() => _ApplyGitaScreenState();
}

class _ApplyGitaScreenState extends State<ApplyGitaScreen> {
  _Situation? _selected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: _selected == null
            ? _SituationSelector(
                isDark: isDark,
                onSelect: (s) => setState(() => _selected = s),
              )
            : _WisdomView(
                situation: _selected!,
                isDark: isDark,
                onBack: () => setState(() => _selected = null),
              ),
      ),
    );
  }
}

class _SituationSelector extends StatelessWidget {
  final bool isDark;
  final Function(_Situation) onSelect;

  const _SituationSelector({required this.isDark, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: Get.back,
                icon: Icon(Icons.arrow_back_rounded,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
              Text(
                'apply_gita'.tr,
                style: AppTextStyles.headlineLarge(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'how_are_you'.tr,
            style: AppTextStyles.displayMedium(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'select_situation'.tr,
            style: AppTextStyles.bodyMedium(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: _situations.length,
            itemBuilder: (ctx, i) {
              final s = _situations[i];
              return GestureDetector(
                onTap: () => onSelect(s),
                child: Container(
                  decoration: BoxDecoration(
                    color: s.color.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: s.color.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s.emoji, style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 6),
                      Text(
                        s.key.tr,
                        style: AppTextStyles.labelMedium(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WisdomView extends StatelessWidget {
  final _Situation situation;
  final bool isDark;
  final VoidCallback onBack;

  const _WisdomView({
    required this.situation,
    required this.isDark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back_rounded,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
              Text(
                'your_situation'.tr,
                style: AppTextStyles.headlineMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Situation banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: situation.color.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: situation.color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Text(situation.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(
                  '"I\'m feeling ${situation.key.tr.toLowerCase()}."',
                  style: AppTextStyles.titleLarge(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Gita wisdom
          Text(
            'gita_wisdom'.tr,
            style: AppTextStyles.labelMedium(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Get.toNamed(
              AppRoutes.verse,
              arguments: {'chapter': situation.chapter, 'verse': situation.verse},
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(isDark ? 0.2 : 0.08),
                    AppColors.gold.withOpacity(isDark ? 0.12 : 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'chapter'.tr} ${situation.chapter} • ${'verse'.tr} ${situation.verse}',
                    style: AppTextStyles.labelMedium(color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '→ Tap to read this verse',
                    style: AppTextStyles.bodySmall(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Teaching
          Text(
            'krishna_teaches'.tr,
            style: AppTextStyles.labelMedium(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            child: Text(
              situation.teaching,
              style: AppTextStyles.bodyLarge(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Try this
          Text(
            'try_this'.tr,
            style: AppTextStyles.labelMedium(color: AppColors.gold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: situation.actions
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '→  ',
                              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                a,
                                style: AppTextStyles.bodyMedium(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: Text(
              'disclaimer'.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall(
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
