import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'core/constants/app_constants.dart';
import 'data/services/storage_service.dart';
import 'data/services/api_service.dart';
import 'data/repositories/gita_repository.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // System UI
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Initialize services
  final storage = await Get.putAsync(() => StorageService().init());
  Get.put(ApiService());
  Get.put(GitaRepository());

  // Read persisted preferences
  final savedLang = storage.getLanguage();
  final savedTheme = storage.getTheme();

  ThemeMode themeMode;
  switch (savedTheme) {
    case AppConstants.themeLight:
      themeMode = ThemeMode.light;
      break;
    case AppConstants.themeDark:
      themeMode = ThemeMode.dark;
      break;
    default:
      themeMode = ThemeMode.system;
  }

  // Mark today as active
  await storage.updateStreak();

  runApp(GitaMargaApp(
    initialLang: savedLang,
    themeMode: themeMode,
  ));
}

class GitaMargaApp extends StatelessWidget {
  final String initialLang;
  final ThemeMode themeMode;

  const GitaMargaApp({
    super.key,
    required this.initialLang,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GitaMarga',
      debugShowCheckedModeBanner: false,

      // Themes
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Localization
      translations: AppTranslations(),
      locale: Locale(initialLang),
      fallbackLocale: const Locale('en'),

      // Routing
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      // Default transition
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
