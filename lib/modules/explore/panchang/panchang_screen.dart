import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/all.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../utils/panchang_translator.dart';

class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  final panchang = Panchang([registerAllCities]);
  final ScrollController _scrollController = ScrollController();
  
  late final List<DateTime> dates;
  late final int todayIndex;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // 30 days before and 30 days after
    dates = List.generate(61, (index) => now.subtract(Duration(days: 30 - index)));
    todayIndex = 30;
    
    // Jump to today after first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final offset = (todayIndex * 90.0) - (MediaQuery.of(context).size.height / 3);
        _scrollController.jumpTo(offset > 0 ? offset : 0);
      }
    });
  }

  IconData _getMoonIcon(String tithiName) {
    final lower = tithiName.toLowerCase();
    if (lower.contains('purnima')) return Icons.brightness_7_rounded; // Full moon
    if (lower.contains('amavasya')) return Icons.brightness_1_rounded; // New moon
    if (lower.contains('krishna')) return Icons.brightness_3_rounded; // Waning
    if (lower.contains('shukla')) return Icons.brightness_2_rounded; // Waxing
    return Icons.brightness_4_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'calendar'.tr,
          style: AppTextStyles.titleLarge(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Elegant Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      Colors.deepPurple.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'PANCHANG TIMELINE',
                          style: AppTextStyles.labelMedium(color: Colors.white70).copyWith(letterSpacing: 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Track the phases of the moon and Vedic Tithis for past, present, and future.',
                      style: AppTextStyles.bodyMedium(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Timeline List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final date = dates[index];
                  final isToday = index == todayIndex;
                  final isFuture = index > todayIndex;
                  
                  String tithiName = 'Calculation Error';
                  String monthName = '';
                  try {
                    final info = panchang.tithiOnDate(DateTime.utc(date.year, date.month, date.day), City.ujjain);
                    tithiName = info.displayName;
                    final parts = info.displayName.split(' ');
                    monthName = parts.isNotEmpty ? parts.first : '';
                  } catch (_) {}

                  final moonIcon = _getMoonIcon(tithiName);
                  final translatedTithi = PanchangTranslator.translate(tithiName);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Date Component
                        SizedBox(
                          width: 65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('EEE', Get.locale?.languageCode).format(date).toUpperCase(),
                                style: AppTextStyles.labelSmall(
                                  color: isToday 
                                      ? AppColors.primary 
                                      : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                ),
                              ),
                              Text(
                                '${date.day}',
                                style: AppTextStyles.displayMedium(
                                  color: isToday 
                                      ? AppColors.primary 
                                      : (isFuture 
                                          ? (isDark ? Colors.white30 : Colors.black38)
                                          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Vertical Timeline Divider
                        Container(
                          width: 2,
                          height: 70,
                          decoration: BoxDecoration(
                            color: isToday 
                                ? AppColors.primary 
                                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Right Content Card
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isToday 
                                  ? AppColors.primary.withOpacity(isDark ? 0.15 : 0.08)
                                  : (isDark ? AppColors.cardDark : AppColors.cardLight),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isToday 
                                    ? AppColors.primary.withOpacity(0.5) 
                                    : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (isToday)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 6),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            PanchangTranslator.translate('TODAY').toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      Text(
                                        translatedTithi,
                                        style: AppTextStyles.titleMedium(
                                          color: isToday 
                                              ? AppColors.primary 
                                              : (isFuture 
                                                  ? (isDark ? Colors.white54 : Colors.black54)
                                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                                        ).copyWith(fontWeight: isToday ? FontWeight.w700 : FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('MMMM yyyy', Get.locale?.languageCode).format(date),
                                        style: AppTextStyles.bodySmall(
                                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.wb_sunny_rounded, size: 12, color: AppColors.gold),
                                          const SizedBox(width: 4),
                                          Text('06:14 AM', style: AppTextStyles.labelSmall(color: isDark ? Colors.white54 : Colors.black54)),
                                          const SizedBox(width: 12),
                                          Icon(Icons.wb_twilight_rounded, size: 12, color: Colors.deepOrange),
                                          const SizedBox(width: 4),
                                          Text('06:30 PM', style: AppTextStyles.labelSmall(color: isDark ? Colors.white54 : Colors.black54)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isToday 
                                        ? AppColors.primary.withOpacity(0.1) 
                                        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    moonIcon,
                                    color: isToday 
                                        ? AppColors.primary 
                                        : (isDark ? Colors.white30 : Colors.black38),
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: dates.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
