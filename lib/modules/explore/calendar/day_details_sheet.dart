import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../utils/choghadiya_calculator.dart';
import '../../../utils/panchang_translator.dart';

class DayDetailsSheet extends StatelessWidget {
  final DateTime date;
  final String tithiName;
  final bool isDark;

  const DayDetailsSheet({
    super.key,
    required this.date,
    required this.tithiName,
    required this.isDark,
  });

  bool get _isFastingDay {
    final lower = tithiName.toLowerCase();
    return lower.contains('ekadashi') || lower.contains('purnima') || lower.contains('amavasya') ||
           lower.contains('એકાદશી') || lower.contains('પૂર્ણિમા') || lower.contains('અમાવસ્યા') ||
           lower.contains('एकादशी') || lower.contains('पूर्णिमा') || lower.contains('अमावस्या');
  }

  @override
  Widget build(BuildContext context) {
    // Default fixed Ujjain timings for demonstration
    final sunrise = DateTime(date.year, date.month, date.day, 6, 14);
    final sunset = DateTime(date.year, date.month, date.day, 18, 30);
    final nextSunrise = DateTime(date.year, date.month, date.day + 1, 6, 14);

    final dayPeriods = ChoghadiyaCalculator.getDayChoghadiya(sunrise, sunset);
    final nightPeriods = ChoghadiyaCalculator.getNightChoghadiya(sunset, nextSunrise);

    final locale = Get.locale?.languageCode ?? 'en';
    final translatedTithi = PanchangTranslator.translate(tithiName);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle for bottom sheet
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMMM yyyy', locale).format(date),
                        style: AppTextStyles.titleLarge(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (_isFastingDay)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.streakFire.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.streakFire.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.streakFire, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Fasting Day',
                                style: AppTextStyles.labelSmall(color: AppColors.streakFire),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    translatedTithi,
                    style: AppTextStyles.titleMedium(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sunrise & Sunset Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SunTimeWidget(icon: Icons.wb_sunny_rounded, label: 'Sunrise', time: '06:14 AM', isDark: isDark),
                        Container(width: 1, height: 30, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                        _SunTimeWidget(icon: Icons.nightlight_round, label: 'Sunset', time: '06:30 PM', isDark: isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Tabs
            TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
              tabs: const [
                Tab(text: 'Day Choghadiya'),
                Tab(text: 'Night Choghadiya'),
              ],
            ),
            
            // Tab Views
            SizedBox(
              height: 350,
              child: TabBarView(
                children: [
                  _ChoghadiyaList(periods: dayPeriods, isDark: isDark, locale: locale),
                  _ChoghadiyaList(periods: nightPeriods, isDark: isDark, locale: locale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunTimeWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final bool isDark;

  const _SunTimeWidget({required this.icon, required this.label, required this.time, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelSmall(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            Text(time, style: AppTextStyles.labelMedium(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          ],
        ),
      ],
    );
  }
}

class _ChoghadiyaList extends StatelessWidget {
  final List<ChoghadiyaPeriod> periods;
  final bool isDark;
  final String locale;

  const _ChoghadiyaList({required this.periods, required this.isDark, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: periods.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final period = periods[index];
        final isGood = period.name.displayMeaning == 'Good' || period.name.displayMeaning == 'Best';
        final isNeutral = period.name.displayMeaning == 'Neutral';
        final color = isGood ? AppColors.success : (isNeutral ? AppColors.primary : AppColors.error);
        
        String localizedName = period.name.english;
        if (locale == 'hi') localizedName = period.name.hindi;
        if (locale == 'gu') localizedName = period.name.gujarati;
        if (locale == 'sa') localizedName = period.name.sanskrit;

        final startTimeStr = DateFormat('hh:mm a').format(period.startTime);
        final endTimeStr = DateFormat('hh:mm a').format(period.endTime);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 30,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedName,
                      style: AppTextStyles.titleMedium(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      period.name.displayMeaning,
                      style: AppTextStyles.labelSmall(color: color),
                    ),
                  ],
                ),
              ),
              Text(
                '$startTimeStr - $endTimeStr',
                style: AppTextStyles.bodyMedium(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
