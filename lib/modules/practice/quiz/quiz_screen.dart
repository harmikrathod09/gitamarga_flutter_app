import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quiz_controller.dart';
import '../../../data/models/quiz_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return _DifficultySelector(controller: controller, isDark: isDark);
          }
          if (controller.quizComplete.value) {
            return _QuizResult(controller: controller, isDark: isDark);
          }
          return _QuizQuestion(controller: controller, isDark: isDark);
        }),
      ),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  final QuizController controller;
  final bool isDark;

  const _DifficultySelector({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final difficulties = [
      (QuizDifficulty.beginner, 'beginner'.tr, '🌱', 'Basic concepts & characters'),
      (QuizDifficulty.intermediate, 'intermediate'.tr, '🌿', 'Teachings & chapters'),
      (QuizDifficulty.advanced, 'advanced'.tr, '🌳', 'Shlokas & deep concepts'),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: Get.back,
                icon: Icon(Icons.arrow_back_rounded,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'quiz'.tr,
            style: AppTextStyles.displayMedium(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            'Select your level to begin',
            style: AppTextStyles.bodyMedium(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 32),
          ...difficulties.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GestureDetector(
                  onTap: () => controller.startQuiz(d.$1),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(d.$3, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.$2,
                                style: AppTextStyles.headlineMedium(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                d.$4,
                                style: AppTextStyles.bodySmall(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _QuizQuestion extends StatelessWidget {
  final QuizController controller;
  final bool isDark;

  const _QuizQuestion({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        final q = controller.questions[controller.currentIndex.value];
        final answered = controller.answered.value;
        final selected = controller.selectedAnswer.value;
        final progress = (controller.currentIndex.value + 1) / controller.total;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: Icon(Icons.close_rounded,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${'question'.tr} ${controller.currentIndex.value + 1} / ${controller.total}',
                        style: AppTextStyles.labelMedium(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Question
            Text(
              q.question,
              style: AppTextStyles.headlineLarge(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 28),

            // Options
            ...List.generate(q.options.length, (i) {
              Color? optionColor;
              if (answered) {
                if (i == q.correctIndex) optionColor = AppColors.success;
                else if (i == selected) optionColor = AppColors.error;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: answered ? null : () => controller.selectAnswer(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: optionColor?.withOpacity(0.1) ??
                          (isDark ? AppColors.cardDark : AppColors.cardLight),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: optionColor?.withOpacity(0.5) ??
                            (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                        width: optionColor != null ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: optionColor?.withOpacity(0.15) ?? AppColors.primary.withOpacity(0.08),
                            border: Border.all(
                              color: optionColor ?? AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: answered && (i == q.correctIndex || i == selected)
                                ? Icon(
                                    i == q.correctIndex
                                        ? Icons.check_rounded
                                        : Icons.close_rounded,
                                    size: 14,
                                    color: optionColor,
                                  )
                                : Text(
                                    String.fromCharCode(65 + i),
                                    style: AppTextStyles.labelSmall(
                                        color: optionColor ?? AppColors.primary),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: AppTextStyles.bodyMedium(
                              color: optionColor ??
                                  (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Explanation
            if (answered)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Text(
                  q.explanation,
                  style: AppTextStyles.bodySmall(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),

            const Spacer(),

            if (answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.nextQuestion,
                  child: Text(
                    controller.currentIndex.value < controller.total - 1
                        ? 'next_question'.tr
                        : 'finish_quiz'.tr,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _QuizResult extends StatelessWidget {
  final QuizController controller;
  final bool isDark;

  const _QuizResult({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 24),
          Text(
            'your_score'.tr,
            style: AppTextStyles.headlineLarge(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.score} / ${controller.total}',
            style: AppTextStyles.displayLarge(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.gradeLabel,
            style: AppTextStyles.headlineMedium(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => Icon(
              i < controller.stars ? Icons.star_rounded : Icons.star_outline_rounded,
              color: AppColors.gold,
              size: 32,
            )),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.startQuiz(controller.selectedDifficulty.value),
              child: Text('play_again'.tr),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: Get.back,
              child: const Text('Back to Practice'),
            ),
          ),
        ],
      ),
    );
  }
}
