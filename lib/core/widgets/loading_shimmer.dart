import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const LoadingShimmer({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.cardDark : const Color(0xFFE8D9C0),
      highlightColor: isDark ? AppColors.surfaceDark : const Color(0xFFF5ECD8),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ChapterCardShimmer extends StatelessWidget {
  const ChapterCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingShimmer(height: 120),
          const SizedBox(height: 8),
          const LoadingShimmer(height: 16, width: 180),
          const SizedBox(height: 4),
          const LoadingShimmer(height: 12, width: 120),
        ],
      ),
    );
  }
}

class VerseCardShimmer extends StatelessWidget {
  const VerseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingShimmer(height: 80),
          const SizedBox(height: 6),
          const LoadingShimmer(height: 14, width: 220),
          const SizedBox(height: 4),
          const LoadingShimmer(height: 12, width: 160),
        ],
      ),
    );
  }
}
