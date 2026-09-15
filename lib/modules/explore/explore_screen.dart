import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../data/services/storage_service.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storage = Get.find<StorageService>();
    final streak = storage.getStreak();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'nav_explore'.tr,
                style: AppTextStyles.displayMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover, search, and track your journey',
                style: AppTextStyles.bodyMedium(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 20),

              // Search bar (tappable, not functional here — navigates to search screen)
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.search),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                      const SizedBox(width: 10),
                      Text(
                        'search_hint'.tr,
                        style: AppTextStyles.bodyMedium(
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Streak card
              _StreakCard(streak: streak, isDark: isDark),
              const SizedBox(height: 14),

              // Navigation tiles
              _ExploreTile(
                icon: Icons.favorite_rounded,
                color: Colors.red,
                title: 'favorites'.tr,
                subtitle: 'Shlokas you\'ve saved',
                onTap: () => Get.toNamed(AppRoutes.favorites),
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _ExploreTile(
                icon: Icons.calendar_month_rounded,
                color: AppColors.primary,
                title: 'calendar'.tr,
                subtitle: 'Daily shloka history',
                onTap: () {
                  Get.snackbar('', 'Calendar coming soon!',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16));
                },
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _ExploreTile(
                icon: Icons.local_fire_department_rounded,
                color: AppColors.streakFire,
                title: 'wisdom_streak'.tr,
                subtitle: 'Your daily practice record',
                onTap: () {
                  Get.snackbar('', 'Streak history coming soon!',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16));
                },
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final dynamic streak;
  final bool isDark;

  const _StreakCard({required this.streak, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final activeDates = (streak.activeDates as List<DateTime>)
        .map((d) => '${d.year}-${d.month}-${d.day}')
        .toSet();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.streakFire.withOpacity(isDark ? 0.2 : 0.1),
            AppColors.streakGold.withOpacity(isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.streakFire.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                '${streak.currentStreak} ${'days'.tr} — ${'wisdom_streak'.tr}',
                style: AppTextStyles.titleMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Last 7 days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final day = now.subtract(Duration(days: 6 - i));
              final key = '${day.year}-${day.month}-${day.day}';
              final active = activeDates.contains(key);
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? AppColors.streakFire
                          : AppColors.streakFire.withOpacity(0.1),
                    ),
                    child: Center(
                      child: active
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weekDays[day.weekday - 1].substring(0, 1),
                    style: AppTextStyles.labelSmall(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StreakStat(
                label: 'current_streak'.tr,
                value: '${streak.currentStreak}',
                isDark: isDark,
              ),
              _StreakStat(
                label: 'longest_streak'.tr,
                value: '${streak.longestStreak}',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _StreakStat({required this.label, required this.value, required this.isDark});

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

class _ExploreTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;

  const _ExploreTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.titleMedium(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      )),
                  Text(subtitle,
                      style: AppTextStyles.bodySmall(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      )),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 12,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
          ],
        ),
      ),
    );
  }
}
