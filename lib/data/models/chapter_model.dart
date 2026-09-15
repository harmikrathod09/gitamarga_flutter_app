class ChapterModel {
  final int chapterNumber;
  final String name;
  final String translation;
  final String meaning;
  final String summary;
  final int versesCount;

  // Multilingual names
  final String nameHindi;
  final String nameGujarati;
  final String nameSanskrit;
  final String nameEnglish;

  ChapterModel({
    required this.chapterNumber,
    required this.name,
    required this.translation,
    required this.meaning,
    required this.summary,
    required this.versesCount,
    required this.nameHindi,
    required this.nameGujarati,
    required this.nameSanskrit,
    required this.nameEnglish,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final meaning = json['meaning'] as Map<String, dynamic>? ?? {};
    return ChapterModel(
      chapterNumber: json['chapter_number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      meaning: meaning['en'] as String? ?? json['translation'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      versesCount: json['verses_count'] as int? ?? 0,
      nameSanskrit: json['name'] as String? ?? '',
      nameHindi: _hindiChapterNames[json['chapter_number'] as int? ?? 0] ?? json['translation'] as String? ?? '',
      nameGujarati: _gujaratiChapterNames[json['chapter_number'] as int? ?? 0] ?? json['translation'] as String? ?? '',
      nameEnglish: json['translation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'chapter_number': chapterNumber,
        'name': name,
        'translation': translation,
        'meaning': meaning,
        'summary': summary,
        'verses_count': versesCount,
      };

  // Static Hindi chapter names
  static const Map<int, String> _hindiChapterNames = {
    1: 'अर्जुन विषाद योग',
    2: 'सांख्य योग',
    3: 'कर्म योग',
    4: 'ज्ञान कर्म संन्यास योग',
    5: 'कर्म संन्यास योग',
    6: 'आत्म संयम योग',
    7: 'ज्ञान विज्ञान योग',
    8: 'अक्षर ब्रह्म योग',
    9: 'राज विद्या राज गुह्य योग',
    10: 'विभूति योग',
    11: 'विश्वरूप दर्शन योग',
    12: 'भक्ति योग',
    13: 'क्षेत्र क्षेत्रज्ञ विभाग योग',
    14: 'गुणत्रय विभाग योग',
    15: 'पुरुषोत्तम योग',
    16: 'दैवासुर संपद विभाग योग',
    17: 'श्रद्धात्रय विभाग योग',
    18: 'मोक्ष संन्यास योग',
  };

  // Static Gujarati chapter names
  static const Map<int, String> _gujaratiChapterNames = {
    1: 'અર્જુન વિષાદ યોગ',
    2: 'સાંખ્ય યોગ',
    3: 'કર્મ યોગ',
    4: 'જ્ઞાન કર્મ સંન્યાસ યોગ',
    5: 'કર્મ સંન્યાસ યોગ',
    6: 'આત્મ સંયમ યોગ',
    7: 'જ્ઞાન વિજ્ઞાન યોગ',
    8: 'અક્ષર બ્રહ્મ યોગ',
    9: 'રાજ વિદ્યા રાજ ગુહ્ય યોગ',
    10: 'વિભૂતિ યોગ',
    11: 'વિશ્વરૂપ દર્શન યોગ',
    12: 'ભક્તિ યોગ',
    13: 'ક્ષેત્ર ક્ષેત્રજ્ઞ વિભાગ યોગ',
    14: 'ગુણત્રય વિભાગ યોગ',
    15: 'પુરુષોત્તમ યોગ',
    16: 'દૈવાસુર સંપદ વિભાગ યોગ',
    17: 'શ્રદ્ધાત્રય વિભાગ યોગ',
    18: 'મોક્ષ સંન્યાસ યોગ',
  };
}
