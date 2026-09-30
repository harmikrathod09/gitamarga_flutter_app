import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/services/storage_service.dart';
import '../../gita/gita_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = Get.find<StorageService>();
  late String _selectedLang;
  late String _selectedTheme;
  late int _selectedPlan;

  @override
  void initState() {
    super.initState();
    _selectedLang = _storage.getLanguage();
    _selectedTheme = _storage.getTheme();
    _selectedPlan = _storage.getReadingPlanMinutes();
  }

  void _setLanguage(String lang) async {
    setState(() => _selectedLang = lang);
    await _storage.setLanguage(lang);
    
    // Also notify GitaController if it's active so it can fetch dynamic translations
    if (Get.isRegistered<GitaController>()) {
      Get.find<GitaController>().changeLanguage(lang);
    } else {
      Get.updateLocale(Locale(lang));
    }
  }

  String _getLanguageName(String code) {
    final lang = AppConstants.supportedLanguages.firstWhere(
      (l) => l['code'] == code,
      orElse: () => AppConstants.supportedLanguages.first,
    );
    return '${lang['nativeName']} (${lang['name']})';
  }

  void _showLanguageSelector(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'select_language'.tr,
                style: AppTextStyles.titleLarge(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: AppConstants.supportedLanguages.length,
                itemBuilder: (context, index) {
                  final lang = AppConstants.supportedLanguages[index];
                  final isSelected = lang['code'] == _selectedLang;
                  return ListTile(
                    title: Text(
                      '${lang['nativeName']} (${lang['name']})',
                      style: AppTextStyles.bodyMedium(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : null,
                    onTap: () {
                      _setLanguage(lang['code']!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTheme(String theme) async {
    setState(() => _selectedTheme = theme);
    await _storage.setTheme(theme);
    switch (theme) {
      case AppConstants.themeLight:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppConstants.themeDark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
    }
  }

  void _setPlan(int minutes) async {
    setState(() => _selectedPlan = minutes);
    await _storage.setReadingPlanMinutes(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                      'settings'.tr,
                      style: AppTextStyles.headlineLarge(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Language
              _SettingsSection(
                title: 'language'.tr,
                icon: Icons.language_rounded,
                isDark: isDark,
                child: GestureDetector(
                  onTap: () => _showLanguageSelector(context, isDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getLanguageName(_selectedLang),
                          style: AppTextStyles.bodyMedium(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Theme
              _SettingsSection(
                title: 'theme'.tr,
                icon: Icons.palette_rounded,
                isDark: isDark,
                child: Row(
                  children: [
                    _ThemeChip(
                      label: 'theme_light'.tr,
                      value: AppConstants.themeLight,
                      icon: Icons.light_mode_rounded,
                      selected: _selectedTheme,
                      onTap: _setTheme,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _ThemeChip(
                      label: 'theme_dark'.tr,
                      value: AppConstants.themeDark,
                      icon: Icons.dark_mode_rounded,
                      selected: _selectedTheme,
                      onTap: _setTheme,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _ThemeChip(
                      label: 'theme_system'.tr,
                      value: AppConstants.themeSystem,
                      icon: Icons.settings_suggest_rounded,
                      selected: _selectedTheme,
                      onTap: _setTheme,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Reading plan
              _SettingsSection(
                title: 'reading_plan'.tr,
                icon: Icons.timer_rounded,
                isDark: isDark,
                child: Column(
                  children: [5, 10, 15, 30].map((min) {
                    final isSelected = _selectedPlan == min;
                    return GestureDetector(
                      onTap: () => _setPlan(min),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.5)
                                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$min min/day',
                              style: AppTextStyles.bodyMedium(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'GitaMarga v1.0.0  •  Read. Understand.',
                  style: AppTextStyles.bodySmall(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool isDark;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.titleMedium(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final String code;
  final String selected;
  final Function(String) onTap;
  final bool isDark;

  const _LangOption({
    required this.label,
    required this.code,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == code;
    return GestureDetector(
      onTap: () => onTap(code),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String selected;
  final Function(String) onTap;
  final bool isDark;

  const _ThemeChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall(
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
