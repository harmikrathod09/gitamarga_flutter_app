import 'package:get/get.dart';
import '../models/chapter_model.dart';
import '../models/slok_model.dart';
import '../models/favorite_model.dart';
import '../models/reading_progress_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class GitaRepository extends GetxService {
  final ApiService _api = Get.find<ApiService>();
  final StorageService _storage = Get.find<StorageService>();

  // ─── Chapters ────────────────────────────────────────────────────────────────

  Future<List<ChapterModel>> getChapters() => _api.getChapters();

  Future<ChapterModel?> getChapter(int n) => _api.getChapter(n);

  // ─── Verses ──────────────────────────────────────────────────────────────────

  Future<SlokModel?> getSlok(int chapter, int verse) => _api.getSlok(chapter, verse);

  Future<SlokModel?> getDailyShloka() async {
    // Check if we already have today's shloka
    final stored = _storage.getDailyShlokaForToday();
    if (stored != null) {
      return getSlok(stored['chapter']!, stored['verse']!);
    }
    // Generate a deterministic daily shloka based on day of year
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    // Famous shlokas pool
    final famousVerses = [
      [2, 47], [2, 48], [2, 19], [2, 20], [3, 27], [4, 7], [4, 8],
      [6, 5], [6, 6], [9, 22], [10, 10], [12, 13], [12, 14], [18, 66],
      [2, 14], [3, 21], [4, 38], [5, 10], [6, 34], [7, 8], [8, 7],
    ];
    final idx = dayOfYear % famousVerses.length;
    final chap = famousVerses[idx][0];
    final ver = famousVerses[idx][1];
    await _storage.setDailyShloka(chap, ver);
    return getSlok(chap, ver);
  }

  // ─── Search ───────────────────────────────────────────────────────────────────

  Future<List<SlokModel>> searchVerses(String query) async {
    if (query.trim().isEmpty) return [];
    final chapters = await getChapters();
    final results = <SlokModel>[];
    final lowerQuery = query.toLowerCase();

    // Search through known cached verses
    for (final chapter in chapters) {
      for (int v = 1; v <= chapter.versesCount; v++) {
        final cached = _storage.getCachedSlok(chapter.chapterNumber, v);
        if (cached != null) {
          final matches = cached.slok.contains(query) ||
              cached.transliteration.toLowerCase().contains(lowerQuery) ||
              (cached.englishTranslation.toLowerCase().contains(lowerQuery)) ||
              (cached.hindiTranslation.contains(query));
          if (matches) results.add(cached);
        }
      }
    }
    return results;
  }

  // ─── Favorites ───────────────────────────────────────────────────────────────

  List<FavoriteModel> getFavorites() => _storage.getFavorites();

  bool isFavorite(int chapter, int verse) => _storage.isFavorite(chapter, verse);

  Future<void> toggleFavorite(SlokModel slok) async {
    final id = FavoriteModel.buildId(slok.chapter, slok.verse);
    if (_storage.isFavorite(slok.chapter, slok.verse)) {
      await _storage.removeFavorite(id);
    } else {
      await _storage.addFavorite(FavoriteModel(
        id: id,
        chapter: slok.chapter,
        verse: slok.verse,
        slok: slok.slok,
        translation: slok.englishTranslation,
        savedAt: DateTime.now(),
      ));
    }
  }

  // ─── Progress ─────────────────────────────────────────────────────────────────

  ReadingProgressModel getReadingProgress() => _storage.getReadingProgress();

  Future<void> markVerseRead(int chapter, int verse) async {
    await _storage.markVerseRead(chapter, verse);
    await _storage.updateStreak();
  }

  StreakModel getStreak() => _storage.getStreak();

  double getChapterProgress(int chapter, int totalVerses) =>
      _storage.getChapterProgress(chapter, totalVerses);

  // ─── Stats ────────────────────────────────────────────────────────────────────

  Map<String, dynamic> getStats() {
    final progress = _storage.getReadingProgress();
    final streak = _storage.getStreak();

    return {
      'versesRead': progress.readVerseIds.length,
      'currentStreak': streak.currentStreak,
      'longestStreak': streak.longestStreak,
      'chaptersCompleted': _countCompletedChapters(),
      'overallProgress': progress.progressPercent,
    };
  }

  int _countCompletedChapters() {
    final cached = _storage.getCachedChapters();
    if (cached == null) return 0;
    return cached.where((c) => _storage.getChapterProgress(c.chapterNumber, c.versesCount) >= 1.0).length;
  }
}
