class ReadingProgressModel {
  final int chapter;
  final int verse;
  final int totalVerses;
  final DateTime lastReadAt;
  final Set<String> readVerseIds; // "chapter:verse"

  ReadingProgressModel({
    required this.chapter,
    required this.verse,
    required this.totalVerses,
    required this.lastReadAt,
    required this.readVerseIds,
  });

  double get progressPercent =>
      totalVerses > 0 ? readVerseIds.length / totalVerses : 0.0;

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) =>
      ReadingProgressModel(
        chapter: json['chapter'] as int? ?? 1,
        verse: json['verse'] as int? ?? 1,
        totalVerses: json['totalVerses'] as int? ?? 700,
        lastReadAt: DateTime.parse(json['lastReadAt'] as String? ?? DateTime.now().toIso8601String()),
        readVerseIds: Set<String>.from(json['readVerseIds'] as List? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'chapter': chapter,
        'verse': verse,
        'totalVerses': totalVerses,
        'lastReadAt': lastReadAt.toIso8601String(),
        'readVerseIds': readVerseIds.toList(),
      };

  ReadingProgressModel copyWith({
    int? chapter,
    int? verse,
    int? totalVerses,
    DateTime? lastReadAt,
    Set<String>? readVerseIds,
  }) =>
      ReadingProgressModel(
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        totalVerses: totalVerses ?? this.totalVerses,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        readVerseIds: readVerseIds ?? this.readVerseIds,
      );
}

class StreakModel {
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActiveDate;
  final List<DateTime> activeDates;

  StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActiveDate,
    required this.activeDates,
  });

  factory StreakModel.initial() => StreakModel(
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
        activeDates: [],
      );

  factory StreakModel.fromJson(Map<String, dynamic> json) => StreakModel(
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
        lastActiveDate: DateTime.parse(
            json['lastActiveDate'] as String? ?? DateTime.now().toIso8601String()),
        activeDates: (json['activeDates'] as List? ?? [])
            .map((e) => DateTime.parse(e as String))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastActiveDate': lastActiveDate.toIso8601String(),
        'activeDates': activeDates.map((e) => e.toIso8601String()).toList(),
      };

  StreakModel copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    List<DateTime>? activeDates,
  }) =>
      StreakModel(
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastActiveDate: lastActiveDate ?? this.lastActiveDate,
        activeDates: activeDates ?? this.activeDates,
      );
}
