import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/services/storage_service.dart';
import 'package:intl/intl.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storage = Get.find<StorageService>();
    final streak = storage.getStreak();
    
    final activeDates = (streak.activeDates as List<DateTime>)
        .map((d) => '${d.year}-${d.month}-${d.day}')
        .toSet();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('wisdom_streak'.tr),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.streakFire.withOpacity(isDark ? 0.3 : 0.2),
                      AppColors.streakGold.withOpacity(isDark ? 0.2 : 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.streakFire.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    Text(
                      '${streak.currentStreak}',
                      style: AppTextStyles.displayLarge(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ).copyWith(fontSize: 64, height: 1),
                    ),
                    Text(
                      'Days Streak',
                      style: AppTextStyles.titleMedium(
                        color: AppColors.streakFire,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Longest Streak',
                      '${streak.longestStreak}',
                      Icons.emoji_events_rounded,
                      AppColors.gold,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Days',
                      '${streak.activeDates.length}',
                      Icons.calendar_month_rounded,
                      AppColors.primary,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // 30 Days History Activity Grid
              Text(
                'Recent Activity (30 Days)',
                style: AppTextStyles.titleLarge(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                  ),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(30, (index) {
                    final day = DateTime.now().subtract(Duration(days: 29 - index));
                    final key = '${day.year}-${day.month}-${day.day}';
                    final isActive = activeDates.contains(key);
                    
                    return Tooltip(
                      message: DateFormat('MMM d, y').format(day),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isActive 
                              ? AppColors.streakFire 
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isActive 
                                ? AppColors.streakFire 
                                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                          ),
                          boxShadow: isActive ? [
                            BoxShadow(
                              color: AppColors.streakFire.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: AppTextStyles.labelSmall(
                              color: isActive 
                                  ? Colors.white 
                                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDark) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.headlineMedium(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
