import 'package:get/get.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/onboarding/language_selection_screen.dart';
import '../modules/shell/shell_screen.dart';
import '../modules/home/home_controller.dart';
import '../modules/gita/gita_controller.dart';
import '../modules/gita/chapter_detail_screen.dart';
import '../modules/gita/verse_detail_screen.dart';

import '../modules/explore/search/search_screen.dart';
import '../modules/explore/favorites/favorites_screen.dart';
import '../modules/explore/calendar/calendar_screen.dart';
import '../modules/explore/streak/streak_screen.dart';
import '../modules/explore/panchang/panchang_screen.dart';
import '../modules/profile/settings/settings_screen.dart';
import '../modules/profile/about/about_screen.dart';
import '../modules/profile/about/developer_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.languageSelection,
      page: () => const LanguageSelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const ShellScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => GitaController());
      }),
    ),
    GetPage(
      name: AppRoutes.chapter,
      page: () => const ChapterDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GitaController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.verse,
      page: () => const VerseDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GitaController(), fenix: true);
      }),
    ),

    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
    ),
    GetPage(
      name: AppRoutes.calendar,
      page: () => const CalendarScreen(),
    ),
    GetPage(
      name: AppRoutes.streak,
      page: () => const StreakScreen(),
    ),
    GetPage(
      name: AppRoutes.panchang,
      page: () => const PanchangScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutScreen(),
    ),
    GetPage(
      name: AppRoutes.developer,
      page: () => const DeveloperScreen(),
    ),
  ];
}
