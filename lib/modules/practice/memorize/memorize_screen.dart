import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'memorize_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/loading_shimmer.dart';

class MemorizeScreen extends StatelessWidget {
  const MemorizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemorizeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Load default verse on first open
    if (controller.slok.value == null && !controller.isLoading.value) {
      controller.loadVerse(2, 47);
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'memorization_mode'.tr,
                    style: AppTextStyles.headlineMedium(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Verse selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Obx(() => Row(
                    children: MemorizeController.memorizeVerses.map((v) {
                      final isSelected = controller.selectedChapter.value == v[0] &&
                          controller.selectedVerse.value == v[1];
                      return GestureDetector(
                        onTap: () => controller.loadVerse(v[0], v[1]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${v[0]}.${v[1]}',
                            style: AppTextStyles.labelMedium(
                              color: isSelected ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      LoadingShimmer(height: 150),
                      SizedBox(height: 12),
                      LoadingShimmer(height: 100),
                    ]),
                  );
                }

                final slok = controller.slok.value;
                if (slok == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verse display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(isDark ? 0.2 : 0.08),
                              AppColors.gold.withOpacity(isDark ? 0.12 : 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Obx(() => Text(
                              controller.maskedVerse,
                              style: AppTextStyles.sanskritBody(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                fontSize: 20,
                              ),
                            )),
                      ),
                      const SizedBox(height: 16),

                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ControlBtn(
                            icon: Icons.visibility_rounded,
                            label: 'Show More',
                            onTap: controller.revealMore,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          Obx(() => _ProgressBadge(
                                hidden: controller.hiddenWordCount.value,
                                total: controller.words.length,
                                isDark: isDark,
                              )),
                          const SizedBox(width: 12),
                          _ControlBtn(
                            icon: Icons.visibility_off_rounded,
                            label: 'Hide More',
                            onTap: controller.revealLess,
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Input
                      Obx(() {
                        if (controller.hiddenWordCount.value == 0) {
                          return Center(
                            child: Text(
                              'Tap "Hide More" to start memorizing!',
                              style: AppTextStyles.bodyMedium(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'your_answer'.tr,
                              style: AppTextStyles.labelMedium(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              maxLines: 4,
                              onChanged: (v) => controller.userInput.value = v,
                              decoration: InputDecoration(
                                hintText: 'Type the hidden words...',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(() {
                              if (controller.showResult.value) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: controller.isCorrect.value
                                            ? AppColors.success.withOpacity(0.1)
                                            : AppColors.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: controller.isCorrect.value
                                              ? AppColors.success.withOpacity(0.4)
                                              : AppColors.error.withOpacity(0.4),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.isCorrect.value
                                                ? '✅ ${'correct'.tr}'
                                                : '❌ ${'incorrect'.tr}',
                                            style: AppTextStyles.titleMedium(
                                              color: controller.isCorrect.value
                                                  ? AppColors.success
                                                  : AppColors.error,
                                            ),
                                          ),
                                          if (!controller.isCorrect.value) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              '${'correct_answer'.tr}: ${slok.slok}',
                                              style: AppTextStyles.bodySmall(
                                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: controller.tryAgain,
                                            child: Text('try_again'.tr),
                                          ),
                                        ),
                                        if (controller.isCorrect.value) ...[
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: controller.revealLess,
                                              child: const Text('Harder!'),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: controller.checkAnswer,
                                  child: Text('check_answer'.tr),
                                ),
                              );
                            }),
                          ],
                        );
                      }),

                      // Stats
                      const SizedBox(height: 20),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatBadge(
                                label: 'accuracy'.tr,
                                value: '${(controller.accuracy * 100).toInt()}%',
                                isDark: isDark,
                              ),
                              _StatBadge(
                                label: 'attempts'.tr,
                                value: '${controller.attempts.value}',
                                isDark: isDark,
                              ),
                              _StatBadge(
                                label: 'Correct',
                                value: '${controller.correctAttempts.value}',
                                isDark: isDark,
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _ControlBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.labelSmall(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  final int hidden;
  final int total;
  final bool isDark;

  const _ProgressBadge({required this.hidden, required this.total, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$hidden / $total',
        style: AppTextStyles.titleMedium(color: AppColors.primary),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatBadge({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
