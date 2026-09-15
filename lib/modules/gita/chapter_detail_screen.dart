import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gita_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import '../../routes/app_routes.dart';

class ChapterDetailScreen extends StatefulWidget {
  const ChapterDetailScreen({super.key});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final RxString _searchQuery = ''.obs;

  late final int chapterNumber;
  late final int totalVerses;
  String chapterName = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    chapterNumber = args?['chapter'] as int? ?? 1;
    totalVerses = args?['totalVerses'] as int? ?? 47;

    // Get chapter name from controller's chapters list
    final ctrl = Get.find<GitaController>();
    final chapter = ctrl.chapters.firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
    chapterName = chapter?.nameEnglish ?? 'Chapter $chapterNumber';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<int> get filteredVerses {
    if (_searchQuery.value.isEmpty) return List.generate(totalVerses, (i) => i + 1);
    final q = int.tryParse(_searchQuery.value);
    if (q != null && q >= 1 && q <= totalVerses) return [q];
    return List.generate(totalVerses, (i) => i + 1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'chapter'.tr} $chapterNumber',
                          style: AppTextStyles.headlineMedium(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          '$chapterName  •  $totalVerses ${'verses'.tr}',
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
            const SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => _searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: 'Search verse number...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: Obx(() => _searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            _searchQuery.value = '';
                          },
                        )
                      : const SizedBox.shrink()),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 12),

            // Verse list
            Expanded(
              child: Obx(() {
                final verses = filteredVerses;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: verses.length,
                  itemBuilder: (ctx, i) {
                    final verseNum = verses[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _VerseListTile(
                        chapter: chapterNumber,
                        verse: verseNum,
                        isDark: isDark,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerseListTile extends StatelessWidget {
  final int chapter;
  final int verse;
  final bool isDark;

  const _VerseListTile({
    required this.chapter,
    required this.verse,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.verse,
        arguments: {'chapter': chapter, 'verse': verse},
      ),
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$verse',
                  style: AppTextStyles.titleMedium(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'verse'.tr} $verse',
                    style: AppTextStyles.titleMedium(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '${'chapter'.tr} $chapter • ${'verse'.tr} $verse',
                    style: AppTextStyles.bodySmall(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
