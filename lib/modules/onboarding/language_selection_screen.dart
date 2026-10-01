import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final StorageService _storage = Get.find<StorageService>();
  String _selectedLanguageCode = AppConstants.langSanskrit;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = _storage.getLanguage();
  }

  void _onLanguageSelected(String code) {
    setState(() {
      _selectedLanguageCode = code;
    });
  }

  void _onContinue() async {
    // Save selection
    await _storage.setLanguage(_selectedLanguageCode);
    await _storage.setOnboardingDone();

    // Update locale immediately
    Get.updateLocale(Locale(_selectedLanguageCode));

    // Navigate to home
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Header
              Text(
                'Choose Language',
                style: AppTextStyles.displayMedium(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ).copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Select your preferred language for reading the Bhagavad Gita.',
                style: AppTextStyles.bodyMedium(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Language List
              Expanded(
                child: ListView.separated(
                  itemCount: AppConstants.supportedLanguages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final lang = AppConstants.supportedLanguages[index];
                    final isSelected = lang['code'] == _selectedLanguageCode;

                    return GestureDetector(
                      onTap: () => _onLanguageSelected(lang['code']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.primary.withOpacity(0.1) 
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? AppColors.primary 
                                : (isDark ? Colors.white12 : Colors.black12),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['nativeName']!,
                                  style: AppTextStyles.titleMedium(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang['name']!,
                                  style: AppTextStyles.bodySmall(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.primary, size: 28),
                            if (!isSelected)
                              Icon(Icons.circle_outlined, color: isDark ? Colors.white24 : Colors.black26, size: 28),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue Button
              ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: AppTextStyles.titleMedium(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
