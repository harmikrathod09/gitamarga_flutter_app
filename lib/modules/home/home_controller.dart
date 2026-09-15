import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/slok_model.dart';
import '../../data/models/reading_progress_model.dart';
import '../../data/repositories/gita_repository.dart';

class HomeController extends GetxController {
  final GitaRepository _repo = Get.find<GitaRepository>();

  final Rx<SlokModel?> dailyShloka = Rx<SlokModel?>(null);
  final RxBool isLoadingDaily = false.obs;
  final RxBool isDailyFavorite = false.obs;

  final Rx<ReadingProgressModel?> progress = Rx<ReadingProgressModel?>(null);
  final RxMap<String, dynamic> stats = RxMap<String, dynamic>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoadingDaily.value = true;
    try {
      final slok = await _repo.getDailyShloka();
      dailyShloka.value = slok;
      if (slok != null) {
        isDailyFavorite.value = _repo.isFavorite(slok.chapter, slok.verse);
      }
    } finally {
      isLoadingDaily.value = false;
    }
    progress.value = _repo.getReadingProgress();
    stats.value = _repo.getStats();
  }

  Future<void> toggleDailyFavorite() async {
    final slok = dailyShloka.value;
    if (slok == null) return;
    await _repo.toggleFavorite(slok);
    isDailyFavorite.value = _repo.isFavorite(slok.chapter, slok.verse);
    final message = isDailyFavorite.value ? 'added_favorite'.tr : 'removed_favorite'.tr;
    Get.snackbar('', message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16));
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greeting_morning'.tr;
    if (hour < 17) return 'greeting_afternoon'.tr;
    if (hour < 21) return 'greeting_evening'.tr;
    return 'greeting_night'.tr;
  }

  String get todayWisdom {
    final wisdoms = [
      'Focus on your actions, not only on their results.',
      'The soul is eternal; the body is temporary.',
      'Perform your duty sincerely without attachment.',
      'True equanimity is maintained in both success and failure.',
      'Control the mind; it is your greatest friend or your worst enemy.',
      'Rise above the three Gunas — be beyond sorrow and desire.',
      'Surrender your ego to the divine and act without selfish motive.',
    ];
    return wisdoms[DateTime.now().day % wisdoms.length];
  }
}
