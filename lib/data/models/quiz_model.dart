class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final QuizDifficulty difficulty;
  final QuizCategory category;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
    required this.category,
  });
}

enum QuizDifficulty { beginner, intermediate, advanced }

enum QuizCategory { chapters, characters, shlokas, teachings, concepts }

class QuizResult {
  final int score;
  final int total;
  final DateTime completedAt;
  final QuizDifficulty difficulty;

  QuizResult({
    required this.score,
    required this.total,
    required this.completedAt,
    required this.difficulty,
  });

  double get percentage => score / total;

  String get grade {
    if (percentage >= 0.9) return 'Excellent';
    if (percentage >= 0.7) return 'Good';
    if (percentage >= 0.5) return 'Fair';
    return 'Keep Learning';
  }

  int get stars {
    if (percentage >= 0.9) return 5;
    if (percentage >= 0.75) return 4;
    if (percentage >= 0.6) return 3;
    if (percentage >= 0.4) return 2;
    return 1;
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        score: json['score'] as int,
        total: json['total'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
        difficulty: QuizDifficulty.values[json['difficulty'] as int? ?? 0],
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'total': total,
        'completedAt': completedAt.toIso8601String(),
        'difficulty': difficulty.index,
      };
}

/// Static question bank for the Gita Quiz
class QuizBank {
  static const List<QuizQuestion> beginner = [
    QuizQuestion(
      question: 'Who narrated the Bhagavad Gita to Arjuna?',
      options: ['Brahma', 'Krishna', 'Sanjaya', 'Bhishma'],
      correctIndex: 1,
      explanation: 'Lord Krishna narrated the Bhagavad Gita to Arjuna on the battlefield of Kurukshetra.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.characters,
    ),
    QuizQuestion(
      question: 'On which battlefield was the Bhagavad Gita spoken?',
      options: ['Lanka', 'Mathura', 'Kurukshetra', 'Hastinapur'],
      correctIndex: 2,
      explanation: 'The Bhagavad Gita was spoken by Lord Krishna on the battlefield of Kurukshetra.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'How many chapters does the Bhagavad Gita have?',
      options: ['12', '16', '18', '24'],
      correctIndex: 2,
      explanation: 'The Bhagavad Gita consists of 18 chapters (Adhyayas).',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'How many verses (shlokas) does the Bhagavad Gita contain?',
      options: ['500', '600', '700', '800'],
      correctIndex: 2,
      explanation: 'The Bhagavad Gita contains 700 verses in total.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'What does "Bhagavad Gita" mean?',
      options: ['Song of the Lord', 'Path of Wisdom', 'Book of Karma', 'Words of God'],
      correctIndex: 0,
      explanation: '"Bhagavad Gita" means "Song of the Lord" or "Song of God".',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.concepts,
    ),
    QuizQuestion(
      question: 'Who was Arjuna\'s charioteer in the Kurukshetra war?',
      options: ['Bhishma', 'Drona', 'Krishna', 'Yudhishthira'],
      correctIndex: 2,
      explanation: 'Lord Krishna agreed to be Arjuna\'s charioteer during the Kurukshetra war.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.characters,
    ),
    QuizQuestion(
      question: 'What is the name of the first chapter of the Bhagavad Gita?',
      options: ['Sankhya Yoga', 'Arjuna Vishada Yoga', 'Karma Yoga', 'Bhakti Yoga'],
      correctIndex: 1,
      explanation: 'The first chapter is called "Arjuna Vishada Yoga" — the Yoga of Arjuna\'s Grief.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'Which chapter of the Gita is called "Karma Yoga"?',
      options: ['Chapter 2', 'Chapter 3', 'Chapter 4', 'Chapter 5'],
      correctIndex: 1,
      explanation: 'Chapter 3 is called Karma Yoga — the Yoga of Action.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: '"कर्मण्येवाधिकारस्ते मा फलेषु कदाचन" — which chapter is this verse from?',
      options: ['Chapter 1', 'Chapter 2', 'Chapter 3', 'Chapter 4'],
      correctIndex: 1,
      explanation: 'This famous verse (2.47) is from Chapter 2 — Sankhya Yoga.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.shlokas,
    ),
    QuizQuestion(
      question: 'What does "Yoga" mean in the context of the Bhagavad Gita?',
      options: ['Physical exercise', 'Union or path', 'Prayer', 'Meditation only'],
      correctIndex: 1,
      explanation: 'In the Gita, Yoga refers to union with the divine, or a disciplined path toward self-realization.',
      difficulty: QuizDifficulty.beginner,
      category: QuizCategory.concepts,
    ),
  ];

  static const List<QuizQuestion> intermediate = [
    QuizQuestion(
      question: 'What are the three Gunas described in the Bhagavad Gita?',
      options: ['Dharma, Karma, Moksha', 'Sattva, Rajas, Tamas', 'Ahimsa, Satya, Tapas', 'Kama, Artha, Dharma'],
      correctIndex: 1,
      explanation: 'The three Gunas are Sattva (purity), Rajas (passion), and Tamas (ignorance), discussed in Chapter 14.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.teachings,
    ),
    QuizQuestion(
      question: 'Which chapter describes the Vishwarupa (Universal Form) of Krishna?',
      options: ['Chapter 9', 'Chapter 10', 'Chapter 11', 'Chapter 12'],
      correctIndex: 2,
      explanation: 'Chapter 11 — Vishwarupa Darshana Yoga — describes Krishna showing his Universal Form to Arjuna.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'What is "Nishkama Karma" as taught in the Gita?',
      options: ['Avoiding all action', 'Action without desire for fruit', 'Devotional service', 'Renunciation of the world'],
      correctIndex: 1,
      explanation: 'Nishkama Karma means performing actions without attachment to the results — a central teaching of Chapter 3.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.teachings,
    ),
    QuizQuestion(
      question: 'According to the Gita, the soul (Atman) is:',
      options: ['Destructible', 'Created by Brahma', 'Eternal and indestructible', 'Born with the body'],
      correctIndex: 2,
      explanation: 'Chapter 2 teaches that the Atman is eternal, indestructible, and cannot be cut by weapons or burned by fire.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.teachings,
    ),
    QuizQuestion(
      question: 'Which chapter is called "Bhakti Yoga"?',
      options: ['Chapter 10', 'Chapter 11', 'Chapter 12', 'Chapter 13'],
      correctIndex: 2,
      explanation: 'Chapter 12 is called Bhakti Yoga — the Yoga of Devotion.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'Who transmitted the Bhagavad Gita to King Dhritarashtra through divine sight?',
      options: ['Vyasa', 'Narada', 'Sanjaya', 'Vidura'],
      correctIndex: 2,
      explanation: 'Sanjaya, the minister of Dhritarashtra, narrated the events of Kurukshetra using divine sight granted by Vyasa.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.characters,
    ),
    QuizQuestion(
      question: 'In Bhagavad Gita Chapter 4, Krishna says he has taught this yoga to:',
      options: ['Brahma', 'Vivasvan (Sun God)', 'Narada', 'Shiva'],
      correctIndex: 1,
      explanation: 'Krishna says he taught this ancient yoga to Vivasvan (the Sun God), who taught it to Manu, and so on.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.teachings,
    ),
    QuizQuestion(
      question: 'What does Krishna call the highest secret in Chapter 9?',
      options: ['Karma Yoga', 'Raja Vidya (Royal Knowledge)', 'Jnana Yoga', 'Dhyana Yoga'],
      correctIndex: 1,
      explanation: 'Chapter 9 is titled "Raja Vidya Raja Guhya Yoga" — the Royal Knowledge and Royal Secret.',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'How many main types of Yoga are primarily discussed in the Bhagavad Gita?',
      options: ['2', '3', '4', '6'],
      correctIndex: 1,
      explanation: 'The Gita primarily discusses three paths: Jnana Yoga (knowledge), Bhakti Yoga (devotion), and Karma Yoga (action).',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.concepts,
    ),
    QuizQuestion(
      question: 'The field (Kshetra) and the knower of the field (Kshetrajna) are discussed in which chapter?',
      options: ['Chapter 11', 'Chapter 12', 'Chapter 13', 'Chapter 14'],
      correctIndex: 2,
      explanation: 'Chapter 13 — Kshetra-Kshetrajna Vibhaga Yoga — discusses the body (field) and the soul (knower of the field).',
      difficulty: QuizDifficulty.intermediate,
      category: QuizCategory.chapters,
    ),
  ];

  static const List<QuizQuestion> advanced = [
    QuizQuestion(
      question: 'What is the verse number of "Sarva-dharman parityajya mam ekam sharanam vraja"?',
      options: ['18.64', '18.65', '18.66', '18.67'],
      correctIndex: 2,
      explanation: 'This powerful verse (18.66) is Krishna\'s final instruction to Arjuna: "Abandon all dharmas and take refuge in Me alone."',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.shlokas,
    ),
    QuizQuestion(
      question: 'Which verse describes the Sthitaprajna (person of steady wisdom)?',
      options: ['Chapter 2, Verse 55', 'Chapter 3, Verse 42', 'Chapter 4, Verse 18', 'Chapter 6, Verse 20'],
      correctIndex: 0,
      explanation: 'Chapter 2, Verse 55 begins the description of a Sthitaprajna — one whose mind is unaffected by sorrow or desire.',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.shlokas,
    ),
    QuizQuestion(
      question: 'In which chapter does Krishna reveal "Aham brahmasmi" in the form of the Vibhuti Yoga?',
      options: ['Chapter 9', 'Chapter 10', 'Chapter 11', 'Chapter 15'],
      correctIndex: 1,
      explanation: 'Chapter 10 — Vibhuti Yoga — describes Krishna\'s divine manifestations in the world.',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.chapters,
    ),
    QuizQuestion(
      question: 'What is the meaning of "Kshetrajna" in Chapter 13?',
      options: ['The body', 'The knower of the field (the soul)', 'The battlefield', 'The senses'],
      correctIndex: 1,
      explanation: 'Kshetrajna means "knower of the field" — referring to the consciousness or soul that is aware of the body.',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.concepts,
    ),
    QuizQuestion(
      question: 'According to the Gita, how many Ashvattha tree roots reach upward?',
      options: ['One root', 'Two roots', 'Many roots', 'No roots'],
      correctIndex: 0,
      explanation: 'Chapter 15 describes the eternal Ashvattha (Peepal) tree with roots upward (in Brahman) and branches downward.',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.shlokas,
    ),
    QuizQuestion(
      question: 'Which shloka begins with "Yada yada hi dharmasya glanir bhavati Bharata"?',
      options: ['Chapter 3, Verse 21', 'Chapter 4, Verse 7', 'Chapter 4, Verse 8', 'Chapter 9, Verse 22'],
      correctIndex: 1,
      explanation: 'This is Chapter 4, Verse 7 — Krishna\'s promise to incarnate whenever righteousness declines.',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.shlokas,
    ),
    QuizQuestion(
      question: 'What are the two words Krishna uses to describe himself in Verse 15.12?',
      options: ['Param Brahma', 'Purushottama and Akshara', 'Adi Purusha', 'Brahman and Atman'],
      correctIndex: 1,
      explanation: 'Chapter 15 discusses three beings: Kshara (perishable), Akshara (imperishable), and Purushottama (Supreme Being/Krishna).',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.teachings,
    ),
    QuizQuestion(
      question: 'In the Gita, "Prakriti" primarily refers to:',
      options: ['The soul', 'Material nature / the body-mind complex', 'The Absolute Brahman', 'Karma'],
      correctIndex: 1,
      explanation: 'Prakriti refers to material nature — the body, mind, senses, and the three Gunas — as opposed to Purusha (consciousness).',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.concepts,
    ),
    QuizQuestion(
      question: 'What does Arjuna call Krishna in Chapter 11 after seeing the Vishwarupa?',
      options: ['Govinda', 'Madhusudana', 'Vishveshvara', 'All of the above'],
      correctIndex: 3,
      explanation: 'Arjuna addresses Krishna by many names in Chapter 11 including Vishveshvara, Deva, Purushottama, and others.',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.characters,
    ),
    QuizQuestion(
      question: 'The concept of "Svadharma" (one\'s own duty) is most strongly emphasized in which chapter?',
      options: ['Chapter 1', 'Chapter 2', 'Chapter 3', 'Chapter 18'],
      correctIndex: 1,
      explanation: 'Chapter 2 introduces Svadharma with Krishna urging Arjuna: "Better is one\'s own dharma, even imperfectly performed, than another\'s dharma."',
      difficulty: QuizDifficulty.advanced,
      category: QuizCategory.teachings,
    ),
  ];
}
