class FavoriteModel {
  final String id;
  final int chapter;
  final int verse;
  final String slok;
  final String translation;
  final DateTime savedAt;

  FavoriteModel({
    required this.id,
    required this.chapter,
    required this.verse,
    required this.slok,
    required this.translation,
    required this.savedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        id: json['id'] as String,
        chapter: json['chapter'] as int,
        verse: json['verse'] as int,
        slok: json['slok'] as String? ?? '',
        translation: json['translation'] as String? ?? '',
        savedAt: DateTime.parse(json['savedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapter': chapter,
        'verse': verse,
        'slok': slok,
        'translation': translation,
        'savedAt': savedAt.toIso8601String(),
      };

  static String buildId(int chapter, int verse) => '$chapter:$verse';
}
