import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/gita_repository.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = Get.find<GitaRepository>();
    final stats = repo.getStats();
    final progress = (stats['overallProgress'] as double? ?? 0);
    final versesRead = stats['versesRead'] as int? ?? 0;
    final chapters = stats['chaptersCompleted'] as int? ?? 0;
    final streak = stats['currentStreak'] as int? ?? 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'nav_profile'.tr,
                style: AppTextStyles.displayMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 20),

              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      '🙏',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'welcome'.tr,
                      style: AppTextStyles.headlineMedium(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Overall progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reading Progress',
                              style: AppTextStyles.labelMedium(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: AppTextStyles.labelMedium(color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats grid
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                children: [
                  _StatCard(
                    label: 'verses_read_total'.tr,
                    value: '$versesRead',
                    icon: '📖',
                    isDark: isDark,
                  ),
                  _StatCard(
                    label: 'chapters_done'.tr,
                    value: '$chapters',
                    icon: '📚',
                    isDark: isDark,
                  ),
                  _StatCard(
                    label: 'current_streak'.tr,
                    value: '$streak ${'days'.tr}',
                    icon: '🔥',
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Settings
              Text(
                'settings'.tr,
                style: AppTextStyles.headlineMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.settings_rounded,
                title: 'settings'.tr,
                subtitle: 'Language, Theme, Notifications',
                onTap: () => Get.toNamed(AppRoutes.settings),
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'about'.tr,
                subtitle: 'GitaMarga v1.0.0 — The Path of the Gita',
                onTap: () => Get.toNamed(AppRoutes.about),
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _SettingsTile(
                icon: Icons.refresh_rounded,
                title: 'reset_progress'.tr,
                subtitle: 'Clear all your data',
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('reset_progress'.tr),
                      content: Text('reset_confirm'.tr),
                      actions: [
                        TextButton(
                          onPressed: Get.back,
                          child: Text('cancel'.tr),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Get.find<StorageService>().resetProgress();
                            Get.back();
                            Get.snackbar('', 'Progress reset successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16));
                          },
                          child: Text('confirm'.tr,
                              style: const TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                isDark: isDark,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.headlineMedium(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: AppTextStyles.bodySmall(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDestructive
                ? AppColors.error.withOpacity(0.2)
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.titleMedium(
                        color: isDestructive
                            ? AppColors.error
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
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
