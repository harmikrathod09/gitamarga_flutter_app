import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gita_controller.dart';
import '../../data/models/chapter_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../core/widgets/custom_error_widget.dart';
import '../../routes/app_routes.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GitaController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nav_gita'.tr,
                        style: AppTextStyles.displayMedium(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        '18 ${'all_chapters'.tr}  •  700 ${'verses'.tr}',
                        style: AppTextStyles.bodySmall(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.search),
                    icon: Icon(
                      Icons.search_rounded,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingChapters.value && controller.chapters.isEmpty) {
                  return ListView.builder(
                    itemCount: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LoadingShimmer(height: 130),
                    ),
                  );
                }
                if (controller.chapters.isEmpty) {
                  return CustomErrorWidget(
                    message: 'error_loading'.tr,
                    onRetry: controller.loadChapters,
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.loadChapters,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.chapters.length,
                    itemBuilder: (context, i) {
                      final chapter = controller.chapters[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ChapterCard(
                          chapter: chapter,
                          progress: controller.getChapterProgress(
                              chapter.chapterNumber, chapter.versesCount),
                          isDark: isDark,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final double progress;
  final bool isDark;

  const _ChapterCard({
    required this.chapter,
    required this.progress,
    required this.isDark,
  });

  Color get _accentColor {
    final colors = AppColors.chapterGradients;
    return colors[(chapter.chapterNumber - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Get.locale?.languageCode ?? 'en';
    String chapterName;
    switch (langCode) {
      case 'hi':
        chapterName = chapter.nameHindi;
        break;
      case 'gu':
        chapterName = chapter.nameGujarati;
        break;
      case 'sa':
        chapterName = chapter.nameSanskrit;
        break;
      default:
        chapterName = chapter.nameEnglish;
    }

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.chapter,
        arguments: {'chapter': chapter.chapterNumber, 'totalVerses': chapter.versesCount},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Chapter number sidebar
              Container(
                width: 56,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.12),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${chapter.chapterNumber}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _accentColor,
                      ),
                    ),
                    Text(
                      'Ch.',
                      style: AppTextStyles.labelSmall(color: _accentColor.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.nameSanskrit,
                        style: AppTextStyles.sanskritBody(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        chapterName,
                        style: AppTextStyles.titleMedium(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapter.summary.length > 80
                            ? '${chapter.summary.substring(0, 80)}...'
                            : chapter.summary,
                        style: AppTextStyles.bodySmall(
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 4,
                                backgroundColor: _accentColor.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation(_accentColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${chapter.versesCount} ${'verses'.tr}',
                            style: AppTextStyles.labelSmall(
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
