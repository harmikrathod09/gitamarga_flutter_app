import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'gita_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../core/widgets/custom_error_widget.dart';

class VerseDetailScreen extends StatefulWidget {
  const VerseDetailScreen({super.key});

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  late int _chapter;
  late int _verse;
  bool _focusMode = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _chapter = args['chapter'] as int? ?? 2;
    _verse = args['verse'] as int? ?? 47;
    Get.find<GitaController>().loadSlok(_chapter, _verse);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GitaController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Obx(() {
        if (controller.isLoadingSlok.value) {
          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, controller, isDark),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    LoadingShimmer(height: 120),
                    SizedBox(height: 12),
                    LoadingShimmer(height: 80),
                    SizedBox(height: 12),
                    LoadingShimmer(height: 150),
                  ]),
                ),
              ],
            ),
          );
        }

        final slok = controller.currentSlok.value;
        if (slok == null) {
          return CustomErrorWidget(
            message: 'error_loading'.tr,
            onRetry: () => controller.loadSlok(_chapter, _verse),
          );
        }

        if (_focusMode) {
          return _FocusModeView(
            slok: slok,
            isDark: isDark,
            onExit: () => setState(() => _focusMode = false),
          );
        }

        final langCode = Get.locale?.languageCode ?? 'en';
        final translation = controller.getTranslation(slok, langCode);
        final commentary = controller.getCommentary(slok, langCode);

        return SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, controller, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verse header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${'chapter'.tr} $_chapter  •  ${'verse'.tr} $_verse',
                          style: AppTextStyles.labelMedium(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sanskrit
                      _SectionCard(
                        title: 'sanskrit'.tr,
                        isDark: isDark,
                        child: Text(
                          slok.slok,
                          style: AppTextStyles.sanskritDisplay(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Translation with language switcher
                      _TranslationCard(
                        translation: translation,
                        isDark: isDark,
                        selectedLang: langCode,
                        onLangChange: (lang) {
                          controller.changeLanguage(lang);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Explanation / Commentary
                      if (commentary.isNotEmpty && commentary != 'No commentary available.')
                        _SectionCard(
                          title: 'explanation'.tr,
                          isDark: isDark,
                          child: Text(
                            commentary,
                            style: AppTextStyles.bodyMedium(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      if (commentary.isNotEmpty && commentary != 'No commentary available.')
                        const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _ActionChip(
                              icon: controller.isSpeaking.value
                                  ? Icons.stop_circle_rounded
                                  : Icons.volume_up_rounded,
                              label: controller.isSpeaking.value
                                  ? 'Stop' // Ideally 'stop'.tr but hardcoded to avoid missing translation
                                  : 'listen'.tr,
                              onTap: controller.speakVerse,
                              color: controller.isSpeaking.value ? AppColors.primary : null,
                              isDark: isDark,
                            )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => _ActionChip(
                                  icon: controller.isFavorite.value
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  label: 'favorite'.tr,
                                  onTap: controller.toggleFavorite,
                                  color: controller.isFavorite.value ? Colors.red : null,
                                  isDark: isDark,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionChip(
                              icon: Icons.share_rounded,
                              label: 'share'.tr,
                              onTap: () {
                                Share.share(
                                  '${slok.slok}\n\n$translation\n\n— Chapter $_chapter, Verse $_verse\n\nGitaMarga — The Path of the Gita',
                                );
                              },
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ActionChip(
                              icon: Icons.copy_rounded,
                              label: 'copy'.tr,
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text:
                                      '${slok.slok}\n\n$translation\n\n${'chapter'.tr} $_chapter, ${'verse'.tr} $_verse',
                                ));
                                Get.snackbar('', 'copied'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                    margin: const EdgeInsets.all(16));
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),

                      // Source attribution
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          '${'source'.tr}: Swami Sivananda, Swami Ramsukhdas',
                          style: AppTextStyles.bodySmall(
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context, GitaController ctrl, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Expanded(
            child: Text(
              'Verse $_chapter.$_verse',
              style: AppTextStyles.headlineMedium(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _focusMode = true),
            icon: Icon(
              Icons.center_focus_strong_rounded,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            tooltip: 'focus_mode'.tr,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: AppTextStyles.labelMedium(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _TranslationCard extends StatelessWidget {
  final String translation;
  final bool isDark;
  final String selectedLang;
  final Function(String) onLangChange;

  const _TranslationCard({
    required this.translation,
    required this.isDark,
    required this.selectedLang,
    required this.onLangChange,
  });

  String _getLanguageName(String code) {
    final lang = AppConstants.supportedLanguages.firstWhere(
      (l) => l['code'] == code,
      orElse: () => AppConstants.supportedLanguages.first,
    );
    return '${lang['nativeName']}';
  }

  void _showLanguageSelector(BuildContext context) {
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
                  final isSelected = lang['code'] == selectedLang;
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
                      onLangChange(lang['code']!);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              Text(
                'translation'.tr,
                style: AppTextStyles.labelMedium(
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showLanguageSelector(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getLanguageName(selectedLang),
                        style: AppTextStyles.labelSmall(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            translation,
            style: AppTextStyles.bodyLarge(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}


class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Color? color;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18,
                color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelMedium(
                color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusModeView extends StatelessWidget {
  final dynamic slok;
  final bool isDark;
  final VoidCallback onExit;

  const _FocusModeView({
    required this.slok,
    required this.isDark,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: GestureDetector(
        onTap: onExit,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ॐ',
                  style: AppTextStyles.omSymbol(
                    color: AppColors.gold.withOpacity(0.5),
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  slok.slok,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sanskritDisplay(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 60,
                  height: 1,
                  color: AppColors.dividerLight,
                ),
                const SizedBox(height: 24),
                Text(
                  'Focus on the teaching.',
                  style: AppTextStyles.transliteration(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to exit',
                  style: AppTextStyles.bodySmall(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
