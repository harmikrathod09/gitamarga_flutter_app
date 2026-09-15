import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/services/storage_service.dart';

class QuizController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final Rx<QuizDifficulty> selectedDifficulty = QuizDifficulty.beginner.obs;
  final RxList<QuizQuestion> questions = <QuizQuestion>[].obs;
  final RxInt currentIndex = 0.obs;
  final Rx<int?> selectedAnswer = Rx<int?>(null);
  final RxBool answered = false.obs;
  final RxList<bool> answers = <bool>[].obs;
  final RxBool quizComplete = false.obs;

  List<QuizQuestion> get _pool {
    switch (selectedDifficulty.value) {
      case QuizDifficulty.intermediate:
        return QuizBank.intermediate;
      case QuizDifficulty.advanced:
        return QuizBank.advanced;
      default:
        return QuizBank.beginner;
    }
  }

  void startQuiz(QuizDifficulty difficulty) {
    selectedDifficulty.value = difficulty;
    final pool = [..._pool]..shuffle();
    questions.value = pool.take(10).toList();
    currentIndex.value = 0;
    selectedAnswer.value = null;
    answered.value = false;
    answers.value = [];
    quizComplete.value = false;
  }

  void selectAnswer(int index) {
    if (answered.value) return;
    selectedAnswer.value = index;
    answered.value = true;
    final correct = index == questions[currentIndex.value].correctIndex;
    answers.add(correct);
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedAnswer.value = null;
      answered.value = false;
    } else {
      quizComplete.value = true;
      _saveResult();
    }
  }

  void _saveResult() {
    final score = answers.where((a) => a).length;
    final result = QuizResult(
      score: score,
      total: questions.length,
      completedAt: DateTime.now(),
      difficulty: selectedDifficulty.value,
    );
    _storage.addQuizResult(result);
  }

  int get score => answers.where((a) => a).length;
  int get total => questions.length;
  double get percentage => total > 0 ? score / total : 0;

  String get gradeLabel {
    if (percentage >= 0.9) return 'excellent'.tr;
    if (percentage >= 0.6) return 'good'.tr;
    return 'keep_learning'.tr;
  }

  int get stars {
    if (percentage >= 0.9) return 5;
    if (percentage >= 0.75) return 4;
    if (percentage >= 0.6) return 3;
    if (percentage >= 0.4) return 2;
    return 1;
  }
}
