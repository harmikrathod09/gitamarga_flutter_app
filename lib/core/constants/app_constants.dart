class AppConstants {
  AppConstants._();

  static const String appName = 'GitaMarga';
  static const String appTagline = 'The Path of the Gita';
  static const String appSubtitle = 'Read. Understand. Practice.';

  static const int totalChapters = 18;
  static const int totalVerses = 700;

  // Storage keys
  static const String keyLanguage = 'selected_language';
  static const String keyTheme = 'selected_theme';
  static const String keyFavorites = 'favorites';
  static const String keyReadingProgress = 'reading_progress';
  static const String keyStreak = 'streak_data';
  static const String keyLastOpened = 'last_opened';
  static const String keyQuizHistory = 'quiz_history';
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
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી'},
    {'code': 'sa', 'name': 'Sanskrit', 'nativeName': 'संस्कृतम्'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
    {'code': 'ur', 'name': 'Urdu', 'nativeName': 'اردو'},
    {'code': 'kn', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ'},
    {'code': 'ml', 'name': 'Malayalam', 'nativeName': 'മലയാളം'},
    {'code': 'pa', 'name': 'Punjabi', 'nativeName': 'ਪੰਜਾਬੀ'},
    {'code': 'or', 'name': 'Odia', 'nativeName': 'ଓଡ଼ିଆ'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano'},
    {'code': 'pt', 'name': 'Portuguese', 'nativeName': 'Português'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский'},
    {'code': 'zh-cn', 'name': 'Chinese (Simplified)', 'nativeName': '中文'},
    {'code': 'ja', 'name': 'Japanese', 'nativeName': '日本語'},
    {'code': 'ko', 'name': 'Korean', 'nativeName': '한국어'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
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
