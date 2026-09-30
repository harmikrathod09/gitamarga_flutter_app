import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chapter_model.dart';
import '../models/slok_model.dart';
import '../models/favorite_model.dart';
import '../models/reading_progress_model.dart';
import '../../core/constants/app_constants.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ─── Language & Theme ────────────────────────────────────────────────────────

  String getLanguage() => _prefs.getString(AppConstants.keyLanguage) ?? AppConstants.langSanskrit;
  Future<void> setLanguage(String lang) => _prefs.setString(AppConstants.keyLanguage, lang);

  String getTheme() => _prefs.getString(AppConstants.keyTheme) ?? AppConstants.themeSystem;
  Future<void> setTheme(String theme) => _prefs.setString(AppConstants.keyTheme, theme);

  // ─── Favorites ───────────────────────────────────────────────────────────────

  List<FavoriteModel> getFavorites() {
    final raw = _prefs.getStringList(AppConstants.keyFavorites) ?? [];
    return raw.map((s) => FavoriteModel.fromJson(jsonDecode(s))).toList();
  }

  Future<void> saveFavorites(List<FavoriteModel> favorites) async {
    final raw = favorites.map((f) => jsonEncode(f.toJson())).toList();
    await _prefs.setStringList(AppConstants.keyFavorites, raw);
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    final favorites = getFavorites();
    favorites.removeWhere((f) => f.id == favorite.id);
    favorites.insert(0, favorite);
    await saveFavorites(favorites);
  }

  Future<void> removeFavorite(String id) async {
    final favorites = getFavorites()..removeWhere((f) => f.id == id);
    await saveFavorites(favorites);
  }

  bool isFavorite(int chapter, int verse) {
    final id = FavoriteModel.buildId(chapter, verse);
    return getFavorites().any((f) => f.id == id);
  }

  // ─── Reading Progress ────────────────────────────────────────────────────────

  ReadingProgressModel getReadingProgress() {
    final raw = _prefs.getString(AppConstants.keyReadingProgress);
    if (raw == null) {
      return ReadingProgressModel(
        chapter: 1,
        verse: 1,
        totalVerses: AppConstants.totalVerses,
        lastReadAt: DateTime.now(),
        readVerseIds: {},
      );
    }
    return ReadingProgressModel.fromJson(jsonDecode(raw));
  }

  Future<void> saveReadingProgress(ReadingProgressModel progress) async {
    await _prefs.setString(AppConstants.keyReadingProgress, jsonEncode(progress.toJson()));
  }

  Future<void> markVerseRead(int chapter, int verse) async {
    final progress = getReadingProgress();
    final id = '$chapter:$verse';
    final newIds = {...progress.readVerseIds, id};
    await saveReadingProgress(progress.copyWith(
      chapter: chapter,
      verse: verse,
      lastReadAt: DateTime.now(),
      readVerseIds: newIds,
    ));
  }

  // ─── Streak ──────────────────────────────────────────────────────────────────

  StreakModel getStreak() {
    final raw = _prefs.getString(AppConstants.keyStreak);
    if (raw == null) return StreakModel.initial();
    return StreakModel.fromJson(jsonDecode(raw));
  }

  Future<void> updateStreak() async {
    final streak = getStreak();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      streak.lastActiveDate.year,
      streak.lastActiveDate.month,
      streak.lastActiveDate.day,
    );

    if (today == lastActive) return; // Already active today

    int newCurrent = streak.currentStreak;
    final yesterday = today.subtract(const Duration(days: 1));

    if (lastActive == yesterday) {
      newCurrent += 1; // Consecutive day
    } else {
      newCurrent = 1; // Streak broken
    }

    final newLongest = newCurrent > streak.longestStreak ? newCurrent : streak.longestStreak;
    final newDates = [...streak.activeDates, today];

    final newStreak = streak.copyWith(
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastActiveDate: now,
      activeDates: newDates,
    );
    await _prefs.setString(AppConstants.keyStreak, jsonEncode(newStreak.toJson()));
  }


  // ─── Chapter-level Progress ───────────────────────────────────────────────────

  double getChapterProgress(int chapter, int totalVerses) {
    final progress = getReadingProgress();
    if (totalVerses == 0) return 0;
    int count = 0;
    for (int v = 1; v <= totalVerses; v++) {
      if (progress.readVerseIds.contains('$chapter:$v')) count++;
    }
    return count / totalVerses;
  }

  // ─── Verse Cache ──────────────────────────────────────────────────────────────

  List<ChapterModel>? getCachedChapters() {
    final raw = _prefs.getString(AppConstants.keyCachedChapters);
    if (raw == null) return null;
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => ChapterModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> cacheChapters(List<ChapterModel> chapters) async {
    final raw = jsonEncode(chapters.map((c) => c.toJson()).toList());
    await _prefs.setString(AppConstants.keyCachedChapters, raw);
  }

  SlokModel? getCachedSlok(int chapter, int verse) {
    final raw = _prefs.getString('${AppConstants.keyCachedVerse}${chapter}_$verse');
    if (raw == null) return null;
    final Map<String, dynamic> data = jsonDecode(raw);
    data['chapter'] = chapter;
    data['verse'] = verse;
    return SlokModel.fromJson(data);
  }

  Future<void> cacheSlok(int chapter, int verse, SlokModel slok) async {
    await _prefs.setString(
      '${AppConstants.keyCachedVerse}${chapter}_$verse',
      jsonEncode(slok.toJson()),
    );
  }

  // ─── Daily Shloka ────────────────────────────────────────────────────────────

  Map<String, int>? getDailyShlokaForToday() {
    final storedDate = _prefs.getString(AppConstants.keyDailyShlokaDate);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (storedDate != today) return null;

    final chapter = _prefs.getInt(AppConstants.keyDailyShlokaChapter);
    final verse = _prefs.getInt(AppConstants.keyDailyShlokaVerse);
    if (chapter == null || verse == null) return null;
    return {'chapter': chapter, 'verse': verse};
  }

  Future<void> setDailyShloka(int chapter, int verse) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await _prefs.setString(AppConstants.keyDailyShlokaDate, today);
    await _prefs.setInt(AppConstants.keyDailyShlokaChapter, chapter);
    await _prefs.setInt(AppConstants.keyDailyShlokaVerse, verse);
  }

  // ─── Reading Plan ─────────────────────────────────────────────────────────────

  int getReadingPlanMinutes() => _prefs.getInt(AppConstants.keyReadingPlan) ?? 10;
  Future<void> setReadingPlanMinutes(int minutes) =>
      _prefs.setInt(AppConstants.keyReadingPlan, minutes);

  // ─── Reset ────────────────────────────────────────────────────────────────────

  Future<void> resetProgress() async {
    await _prefs.remove(AppConstants.keyReadingProgress);
    await _prefs.remove(AppConstants.keyStreak);
    await _prefs.remove(AppConstants.keyFavorites);
  }

  // ─── Onboarding ───────────────────────────────────────────────────────────────

  bool isOnboardingDone() => _prefs.getBool(AppConstants.keyOnboardingDone) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(AppConstants.keyOnboardingDone, true);
}
