import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'home_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: RefreshIndicator(
        onRefresh: controller.loadData,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // App Bar / Header
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.greeting,
                              style: AppTextStyles.headlineLarge(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'home_subtitle'.tr,
                              style: AppTextStyles.bodyMedium(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Om badge
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'ॐ',
                            style: AppTextStyles.omSymbol(
                              color: AppColors.gold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Daily Shloka Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  if (controller.isLoadingDaily.value) {
                    return const LoadingShimmer(height: 220);
                  }
                  final slok = controller.dailyShloka.value;
                  if (slok == null) {
                    return _buildDailyShlokaFallback(context, isDark);
                  }
                  return _DailyShlokaCard(
                    slok: slok,
                    isFavorite: controller.isDailyFavorite.value,
                    onFavorite: controller.toggleDailyFavorite,
                    isDark: isDark,
                  );
                }),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Continue Reading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  final progress = controller.progress.value;
                  return _ContinueReadingCard(
                    chapter: progress?.chapter ?? 1,
                    verse: progress?.verse ?? 1,
                    progressPercent: progress?.progressPercent ?? 0,
                    isDark: isDark,
                  );
                }),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Streak Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  final streak = controller.stats['currentStreak'] as int? ?? 0;
                  return _StreakBanner(streak: streak, isDark: isDark);
                }),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Today's Wisdom
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TodaysWisdomCard(
                  wisdom: controller.todayWisdom,
                  isDark: isDark,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyShlokaFallback(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.12),
            AppColors.gold.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Text(
        'error_loading'.tr,
        style: AppTextStyles.bodyMedium(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _DailyShlokaCard extends StatelessWidget {
  final dynamic slok;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final bool isDark;

  const _DailyShlokaCard({
    required this.slok,
    required this.isFavorite,
    required this.onFavorite,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(isDark ? 0.25 : 0.12),
            AppColors.gold.withOpacity(isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'daily_shloka'.tr,
                    style: AppTextStyles.labelSmall(color: AppColors.primary),
                  ),
                ),
                const Spacer(),
                Text(
                  'Chapter ${slok.chapter} • Verse ${slok.verse}',
                  style: AppTextStyles.labelSmall(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              slok.slok.split('\n').take(2).join('\n'),
              style: AppTextStyles.sanskritBody(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontSize: 18,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(
                      AppRoutes.verse,
                      arguments: {'chapter': slok.chapter, 'verse': slok.verse},
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: AppColors.primary.withOpacity(0.6)),
                    ),
                    child: Text('read_meaning'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.red : null,
                  onTap: onFavorite,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.share_rounded,
                  onTap: () {
                    Share.share(
                      '${slok.slok}\n\nChapter ${slok.chapter} • Verse ${slok.verse}\n\n— GitaMarga',
                    );
                  },
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.copy_rounded,
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text: '${slok.slok}\n\nChapter ${slok.chapter} • Verse ${slok.verse}',
                    ));
                    Get.snackbar('', 'copied'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16));
                  },
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final int chapter;
  final int verse;
  final double progressPercent;
  final bool isDark;

  const _ContinueReadingCard({
    required this.chapter,
    required this.verse,
    required this.progressPercent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final chapterNames = {
      1: 'Arjuna\'s Dilemma', 2: 'Sankhya Yoga', 3: 'Karma Yoga',
      4: 'Jnana Karma Yoga', 5: 'Karma Sannyasa', 6: 'Dhyana Yoga',
      7: 'Jnana Vijnana', 8: 'Aksara Brahma', 9: 'Raja Vidya',
      10: 'Vibhuti Yoga', 11: 'Vishwarupa', 12: 'Bhakti Yoga',
      13: 'Kshetra Yoga', 14: 'Gunatraya', 15: 'Purushottama',
      16: 'Daiva-Asura', 17: 'Shraddha', 18: 'Moksha Yoga',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'continue_reading'.tr,
            style: AppTextStyles.labelMedium(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${'chapter'.tr} $chapter',
            style: AppTextStyles.headlineMedium(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            chapterNames[chapter] ?? 'Sankhya Yoga',
            style: AppTextStyles.bodyMedium(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    minHeight: 6,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progressPercent * 100).toInt()}%',
                style: AppTextStyles.labelMedium(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(
                AppRoutes.chapter,
                arguments: {'chapter': chapter},
              ),
              child: Text('continue_btn'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  final int streak;
  final bool isDark;

  const _StreakBanner({required this.streak, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.streakFire.withOpacity(isDark ? 0.2 : 0.1),
            AppColors.streakGold.withOpacity(isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.streakFire.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak > 0
                      ? '$streak ${'days'.tr} ${'wisdom_streak'.tr}'
                      : 'wisdom_streak'.tr,
                  style: AppTextStyles.titleMedium(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                if (streak == 0)
                  Text(
                    'Start reading to build your streak!',
                    style: AppTextStyles.bodySmall(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaysWisdomCard extends StatelessWidget {
  final String wisdom;
  final bool isDark;

  const _TodaysWisdomCard({required this.wisdom, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'todays_wisdom'.tr,
                style: AppTextStyles.labelMedium(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$wisdom"',
            style: AppTextStyles.transliteration(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
