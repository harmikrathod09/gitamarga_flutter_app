class SlokModel {
  final int chapter;
  final int verse;
  final String slok; // Sanskrit
  final String transliteration;
  final String? anvaya; // word-by-word
  final SivanandaTranslation? sivananda;
  final PurohitTranslation? purohit;
  final HindiTranslation? chinmay;
  final HindiTranslation? ramsukhdas;
  final GujaratiTranslation? santvani;
  final String? dynamicTranslation;
  final String? dynamicCommentary;

  SlokModel({
    required this.chapter,
    required this.verse,
    required this.slok,
    required this.transliteration,
    this.anvaya,
    this.sivananda,
    this.purohit,
    this.chinmay,
    this.ramsukhdas,
    this.santvani,
    this.dynamicTranslation,
    this.dynamicCommentary,
  });

  factory SlokModel.fromJson(Map<String, dynamic> json) {
    return SlokModel(
      chapter: json['chapter'] as int? ?? 0,
      verse: json['verse'] as int? ?? 0,
      slok: json['slok'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      anvaya: json['anvaya'] as String?,
      sivananda: json['siva'] != null
          ? SivanandaTranslation.fromJson(json['siva'])
          : null,
      purohit: json['purohit'] != null
          ? PurohitTranslation.fromJson(json['purohit'])
          : null,
      chinmay: json['chinmay'] != null
          ? HindiTranslation.fromJson(json['chinmay'])
          : null,
      ramsukhdas: json['rams'] != null
          ? HindiTranslation.fromJson(json['rams'])
          : (json['tej'] != null ? HindiTranslation.fromJson(json['tej']) : null),
      santvani: json['santvani'] != null
          ? GujaratiTranslation.fromJson(json['santvani'])
          : null,
    );
  }

  /// Get English translation
  String get englishTranslation =>
      sivananda?.et ?? purohit?.et ?? 'Translation not available.';

  /// Get Hindi translation
  String get hindiTranslation =>
      ramsukhdas?.ht ?? chinmay?.ht ?? 'अनुवाद उपलब्ध नहीं।';

  /// Get Gujarati translation
  String get gujaratiTranslation =>
      santvani?.gt ?? 'ગુજરાતી અનુવાદ ઉપલબ્ધ નથી.';

  /// Get English commentary/explanation
  String get englishCommentary =>
      sivananda?.ec ?? 'No commentary available.';

  SlokModel copyWith({
    GujaratiTranslation? santvani,
    String? dynamicTranslation,
    String? dynamicCommentary,
  }) {
    return SlokModel(
      chapter: chapter,
      verse: verse,
      slok: slok,
      transliteration: transliteration,
      anvaya: anvaya,
      sivananda: sivananda,
      purohit: purohit,
      chinmay: chinmay,
      ramsukhdas: ramsukhdas,
      santvani: santvani ?? this.santvani,
      dynamicTranslation: dynamicTranslation ?? this.dynamicTranslation,
      dynamicCommentary: dynamicCommentary ?? this.dynamicCommentary,
    );
  }

  Map<String, dynamic> toJson() => {
        'chapter': chapter,
        'verse': verse,
        'slok': slok,
        'transliteration': transliteration,
        'anvaya': anvaya,
        'sivananda': sivananda?.toJson(),
        'ramsukhdas': ramsukhdas?.toJson(),
        'santvani': santvani?.toJson(),
      };
}

class SivanandaTranslation {
  final String? name;
  final String? et; // English translation
  final String? ec; // English commentary

  SivanandaTranslation({this.name, this.et, this.ec});

  factory SivanandaTranslation.fromJson(Map<String, dynamic> json) =>
      SivanandaTranslation(
        name: json['name'] as String?,
        et: json['et'] as String?,
        ec: json['ec'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, 'et': et, 'ec': ec};
}

class PurohitTranslation {
  final String? name;
  final String? et;

  PurohitTranslation({this.name, this.et});

  factory PurohitTranslation.fromJson(Map<String, dynamic> json) =>
      PurohitTranslation(
        name: json['name'] as String?,
        et: json['et'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, 'et': et};
}

class HindiTranslation {
  final String? name;
  final String? ht; // Hindi translation

  HindiTranslation({this.name, this.ht});

  factory HindiTranslation.fromJson(Map<String, dynamic> json) =>
      HindiTranslation(
        name: json['name'] as String?,
        ht: json['ht'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, 'ht': ht};
}

class GujaratiTranslation {
  final String? name;
  final String? gt; // Gujarati translation

  GujaratiTranslation({this.name, this.gt});

  factory GujaratiTranslation.fromJson(Map<String, dynamic> json) =>
      GujaratiTranslation(
        name: json['name'] as String?,
        gt: json['gt'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, 'gt': gt};
}
