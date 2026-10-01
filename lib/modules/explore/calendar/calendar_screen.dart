import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:tithi_engine/tithi_engine.dart';
import 'day_details_sheet.dart';
import 'package:tithi_engine/data/all.dart';
import '../../../utils/panchang_translator.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storage = Get.find<StorageService>();
    final streak = storage.getStreak();
    
    final activeDates = (streak.activeDates as List<DateTime>)
        .map((d) => '${d.year}-${d.month}-${d.day}')
        .toSet();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday
    
    // Get localized short weekdays, starting from Monday
    final List<String> weekDays = [];
    final locale = Get.locale?.languageCode ?? 'en';
    for (int i = 1; i <= 7; i++) {
      // 2024-01-01 was a Monday
      weekDays.add(DateFormat('EEE', locale).format(DateTime(2024, 1, i)).toUpperCase());
    }

    final panchang = Panchang([registerAllCities]);
    
    String hinduMonth = '';
    String hinduDateDisplay = 'Loading Hindu Calendar...';
    try {
      final info = panchang.tithiOnDate(DateTime.utc(now.year, now.month, now.day), City.ujjain);
      hinduDateDisplay = PanchangTranslator.translate(info.displayName);
      hinduMonth = PanchangTranslator.translate(info.displayName.split(' ').first);
    } catch (e) {
      hinduDateDisplay = 'Hindu Calendar not available';
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('calendar'.tr),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hinduMonth.isNotEmpty 
                  ? '$hinduMonth (${DateFormat('MMMM yyyy', Get.locale?.languageCode).format(now)})' 
                  : DateFormat('MMMM yyyy', Get.locale?.languageCode).format(now),
              style: AppTextStyles.displayMedium(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.brightness_3_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    hinduDateDisplay,
                    style: AppTextStyles.labelLarge(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your daily reading progress this month.',
              style: AppTextStyles.bodyMedium(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 32),
            
            // Weekday Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((day) => SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    day,
                    style: AppTextStyles.labelSmall(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            
            // Calendar Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.75, // Make cells taller to fit Tithi text
              ),
              itemCount: daysInMonth + firstWeekday - 1,
              itemBuilder: (context, index) {
                if (index < firstWeekday - 1) {
                  return const SizedBox.shrink(); // Empty slot
                }
                
                final dayNum = index - (firstWeekday - 1) + 1;
                final date = DateTime(now.year, now.month, dayNum);
                final key = '${date.year}-${date.month}-${date.day}';
                final isActive = activeDates.contains(key);
                final isToday = dayNum == now.day;
                final isFuture = date.isAfter(now);

                String dayTithi = '';
                String fullTithiName = '';
                try {
                  final info = panchang.tithiOnDate(DateTime.utc(date.year, date.month, date.day), City.ujjain);
                  fullTithiName = info.displayName;
                  final parts = info.displayName.split(' ');
                  dayTithi = parts.isNotEmpty ? PanchangTranslator.translate(parts.last) : '';
                } catch (_) {}

                return GestureDetector(
                  onTap: () {
                    final tName = dayTithi.isNotEmpty ? fullTithiName : 'Unknown Tithi';
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => DayDetailsSheet(
                        date: date,
                        tithiName: tName,
                        isDark: isDark,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? AppColors.primary 
                          : (isDark ? AppColors.cardDark : AppColors.cardLight),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isToday 
                            ? AppColors.gold 
                            : (isActive 
                                ? AppColors.primary 
                                : (isDark ? AppColors.dividerDark : AppColors.dividerLight)),
                        width: isToday ? 2 : 1,
                      ),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ] : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNum',
                          style: AppTextStyles.bodyMedium(
                            color: isActive 
                                ? Colors.white 
                                : (isFuture 
                                    ? (isDark ? Colors.white24 : Colors.black26)
                                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                          ).copyWith(
                            fontWeight: isActive || isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (dayTithi.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              dayTithi,
                              style: AppTextStyles.labelSmall(
                                color: isActive 
                                    ? Colors.white 
                                    : (isDark ? AppColors.primary.withOpacity(0.9) : AppColors.primary),
                              ).copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 48),
            
            // Summary Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep it up!',
                          style: AppTextStyles.titleMedium(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Read at least one shloka daily to fill your calendar.',
                          style: AppTextStyles.bodySmall(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
