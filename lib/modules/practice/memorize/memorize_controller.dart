import 'package:get/get.dart';
import '../../../data/repositories/gita_repository.dart';
import '../../../data/models/slok_model.dart';

class MemorizeController extends GetxController {
  final GitaRepository _repo = Get.find<GitaRepository>();

  final Rx<SlokModel?> slok = Rx<SlokModel?>(null);
  final RxBool isLoading = false.obs;

  // Memorization state
  final RxInt hiddenWordCount = 0.obs;
  final RxString userInput = ''.obs;
  final RxBool showResult = false.obs;
  final RxBool isCorrect = false.obs;
  final RxInt attempts = 0.obs;
  final RxInt correctAttempts = 0.obs;
  final RxBool isFullyMemorized = false.obs;

  // Verse selection
  final RxInt selectedChapter = 2.obs;
  final RxInt selectedVerse = 47.obs;

  static const List<List<int>> memorizeVerses = [
    [2, 47], [2, 48], [2, 19], [3, 27], [4, 7], [6, 5], [9, 22], [18, 66],
  ];

  Future<void> loadVerse(int chapter, int verse) async {
    isLoading.value = true;
    selectedChapter.value = chapter;
    selectedVerse.value = verse;
    hiddenWordCount.value = 0;
    userInput.value = '';
    showResult.value = false;
    isCorrect.value = false;
    isFullyMemorized.value = false;

    try {
      slok.value = await _repo.getSlok(chapter, verse);
    } finally {
      isLoading.value = false;
    }
  }

  List<String> get words {
    final s = slok.value?.slok ?? '';
    return s.split(RegExp(r'[\s\n]+'));
  }

  String get maskedVerse {
    final ws = words;
    if (ws.isEmpty) return '';
    final showCount = ws.length - hiddenWordCount.value;
    final parts = <String>[];
    for (int i = 0; i < ws.length; i++) {
      if (i < showCount) {
        parts.add(ws[i]);
      } else {
        parts.add('________');
      }
    }
    return parts.join(' ');
  }

  void revealLess() {
    if (hiddenWordCount.value < words.length) {
      hiddenWordCount.value++;
    }
  }

  void revealMore() {
    if (hiddenWordCount.value > 0) {
      hiddenWordCount.value--;
    }
  }

  void checkAnswer() {
    final input = userInput.value.trim();
    attempts.value++;
    // Check if input is a reasonable attempt (contains key words)
    final ws = words;
    final hiddenWords = ws.sublist(ws.length - hiddenWordCount.value);
    int matchCount = 0;
    for (final w in hiddenWords) {
      if (input.contains(w)) matchCount++;
    }
    final accuracy = hiddenWords.isEmpty ? 1.0 : matchCount / hiddenWords.length;
    isCorrect.value = accuracy >= 0.7;
    if (isCorrect.value) correctAttempts.value++;
    showResult.value = true;
    if (hiddenWordCount.value >= words.length && isCorrect.value) {
      isFullyMemorized.value = true;
    }
  }

  void tryAgain() {
    userInput.value = '';
    showResult.value = false;
    isCorrect.value = false;
  }

  double get accuracy =>
      attempts.value == 0 ? 0 : correctAttempts.value / attempts.value;
}
