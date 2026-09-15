import 'package:get/get.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/shell/shell_screen.dart';
import '../modules/home/home_controller.dart';
import '../modules/gita/gita_controller.dart';
import '../modules/gita/chapter_detail_screen.dart';
import '../modules/gita/verse_detail_screen.dart';
import '../modules/practice/quiz/quiz_controller.dart';
import '../modules/practice/quiz/quiz_screen.dart';
import '../modules/practice/memorize/memorize_controller.dart';
import '../modules/practice/memorize/memorize_screen.dart';
import '../modules/practice/apply_gita/apply_gita_screen.dart';
import '../modules/explore/search/search_screen.dart';
import '../modules/explore/favorites/favorites_screen.dart';
import '../modules/profile/settings/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
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
      name: AppRoutes.quiz,
      page: () => const QuizScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => QuizController());
      }),
    ),
    GetPage(
      name: AppRoutes.memorize,
      page: () => const MemorizeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MemorizeController());
      }),
    ),
    GetPage(
      name: AppRoutes.applyGita,
      page: () => const ApplyGitaScreen(),
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
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
  ];
}
