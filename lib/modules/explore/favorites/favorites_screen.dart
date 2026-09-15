import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/gita_repository.dart';
import '../../../data/models/favorite_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<FavoriteModel> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = Get.find<GitaRepository>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
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
                    'favorites'.tr,
                    style: AppTextStyles.headlineLarge(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('❤️', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'no_favorites'.tr,
                            style: AppTextStyles.headlineMedium(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'add_favorites'.tr,
                            style: AppTextStyles.bodyMedium(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _favorites.length,
                      itemBuilder: (ctx, i) {
                        final fav = _favorites[i];
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.verse,
                            arguments: {'chapter': fav.chapter, 'verse': fav.verse},
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${'chapter'.tr} ${fav.chapter} • ${'verse'.tr} ${fav.verse}',
                                        style: AppTextStyles.labelSmall(color: AppColors.primary),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.favorite_rounded, color: Colors.red, size: 18),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  fav.slok.split('\n').first,
                                  style: AppTextStyles.sanskritBody(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  fav.translation,
                                  style: AppTextStyles.bodySmall(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
