import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _omController;
  late AnimationController _titleController;
  late AnimationController _taglineController;

  late Animation<double> _omFade;
  late Animation<double> _omScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    _omController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _omFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _omController, curve: Curves.easeIn),
    );
    _omScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _omController, curve: Curves.elasticOut),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // Sequence the animations
    _omController.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      _titleController.forward().then((_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        _taglineController.forward();
      });
    });
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        final storage = Get.find<StorageService>();
        if (storage.isOnboardingDone()) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(AppRoutes.languageSelection);
        }
      }
    });
  }

  @override
  void dispose() {
    _omController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Subtle background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _SplashBackgroundPainter(isDark: isDark),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ॐ Symbol
                ScaleTransition(
                  scale: _omScale,
                  child: FadeTransition(
                    opacity: _omFade,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.15),
                            AppColors.gold.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'ॐ',
                          style: AppTextStyles.omSymbol(
                            color: AppColors.gold,
                            fontSize: 52,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // App Name
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleFade,
                    child: Text(
                      'GitaMarga',
                      style: AppTextStyles.displayLarge(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    'The Path of the Gita',
                    style: AppTextStyles.titleMedium(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    'Read. Understand.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom loader
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _taglineFade,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBackgroundPainter extends CustomPainter {
  final bool isDark;
  _SplashBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(isDark ? 0.03 : 0.04)
      ..style = PaintingStyle.fill;

    // Subtle concentric arcs for spiritual feel
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        i * (size.width / 5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
