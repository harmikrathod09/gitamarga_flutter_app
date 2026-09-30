class AppConstants {
  AppConstants._();

  static const String appName = 'GitaMarga';
  static const String appTagline = 'The Path of the Gita';
  static const String appSubtitle = 'Read. Understand.';

  static const int totalChapters = 18;
  static const int totalVerses = 700;

  // Storage keys
  static const String keyLanguage = 'selected_language';
  static const String keyTheme = 'selected_theme';
  static const String keyFavorites = 'favorites';
  static const String keyReadingProgress = 'reading_progress';
  static const String keyStreak = 'streak_data';
  static const String keyLastOpened = 'last_opened';
  static const String keyReadingPlan = 'reading_plan';
  static const String keyDailyShlokaDate = 'daily_shloka_date';
  static const String keyDailyShlokaChapter = 'daily_shloka_chapter';
  static const String keyDailyShlokaVerse = 'daily_shloka_verse';
  static const String keyCachedChapters = 'cached_chapters';
  static const String keyCachedVerse = 'cached_verse_';
  static const String keyOnboardingDone = 'onboarding_done';

  // Languages
  static const String langEnglish = 'en';
  static const String langHindi = 'hi';
  static const String langGujarati = 'gu';
  static const String langSanskrit = 'sa';

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી'},
    {'code': 'sa', 'name': 'Sanskrit', 'nativeName': 'संस्कृतम्'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
  ];

  // Themes
  static const String themeLight = 'light';
  static const String themeDark = 'dark';
  static const String themeSystem = 'system';
  
  // Reading plans
  static const Map<String, int> readingPlans = {
    '5 min/day': 5,
    '10 min/day': 10,
    '15 min/day': 15,
    '30 min/day': 30,
  };

  // Verses per reading plan (approx)
  static const Map<int, int> versesPerSession = {
    5: 2,
    10: 5,
    15: 8,
    30: 15,
  };
}
