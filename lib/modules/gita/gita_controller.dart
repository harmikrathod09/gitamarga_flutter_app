import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/slok_model.dart';
import '../../data/repositories/gita_repository.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GitaController extends GetxController {
  final GitaRepository _repo = Get.find<GitaRepository>();
  late FlutterTts flutterTts;

  final RxList<ChapterModel> chapters = <ChapterModel>[].obs;
  final RxBool isLoadingChapters = false.obs;

  final Rx<SlokModel?> currentSlok = Rx<SlokModel?>(null);
  final RxBool isLoadingSlok = false.obs;

  final RxBool isFavorite = false.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxBool isSpeaking = false.obs;

  @override
  void onInit() {
    super.onInit();
    flutterTts = FlutterTts();
    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
    flutterTts.setCancelHandler(() {
      isSpeaking.value = false;
    });
    flutterTts.setErrorHandler((msg) {
      isSpeaking.value = false;
      debugPrint('TTS Error: $msg');
    });

    loadChapters();
    selectedLanguage.value = Get.locale?.languageCode ?? 'en';
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> loadChapters() async {
    isLoadingChapters.value = true;
    try {
      chapters.value = await _repo.getChapters();
    } finally {
      isLoadingChapters.value = false;
    }
  }

  Future<void> loadSlok(int chapter, int verse) async {
    isLoadingSlok.value = true;
    currentSlok.value = null;
    await stopSpeaking();
    try {
      var fetchedSlok = await _repo.getSlok(chapter, verse);
      if (fetchedSlok != null) {
        SlokModel slok = fetchedSlok;
        if (slok.santvani == null && slok.hindiTranslation != 'अनुवाद उपलब्ध नहीं।') {
          try {
            final translator = GoogleTranslator();
            final translation = await translator.translate(slok.hindiTranslation, from: 'hi', to: 'gu');
            slok = slok.copyWith(santvani: GujaratiTranslation(gt: translation.text));
          } catch (e) {
            debugPrint('Translation error: $e');
          }
        }

        final currentLang = selectedLanguage.value;
        bool needsTranslation = false;
        
        // Determine if we need to dynamically translate this slok
        if (currentLang == 'en' && slok.englishTranslation == 'Translation not available.') needsTranslation = true;
        if (currentLang == 'hi' && slok.hindiTranslation == 'अनुवाद उपलब्ध नहीं।') needsTranslation = true;
        if (currentLang == 'gu' && slok.gujaratiTranslation == 'ગુજરાતી અનુવાદ ઉપલબ્ધ નથી.') needsTranslation = true;
        if (currentLang != 'en' && currentLang != 'hi' && currentLang != 'gu' && currentLang != 'sa') needsTranslation = true;

        if (needsTranslation && currentLang != 'sa') {
          try {
            final translator = GoogleTranslator();
            // Translate from Sanskrit if English/Hindi are not available
            String sourceText = slok.slok;
            String sourceLang = 'sa';
            
            // Prefer translating from English or Hindi if they happen to be available
            if (slok.englishTranslation != 'Translation not available.') {
              sourceText = slok.englishTranslation;
              sourceLang = 'en';
            } else if (slok.hindiTranslation != 'अनुवाद उपलब्ध नहीं।') {
              sourceText = slok.hindiTranslation;
              sourceLang = 'hi';
            }

            final translation = await translator.translate(sourceText, from: sourceLang, to: currentLang);
            String? translatedCommentary;
            if (slok.englishCommentary != 'No commentary available.' && slok.englishCommentary.isNotEmpty) {
              final commentary = await translator.translate(slok.englishCommentary, from: 'en', to: currentLang);
              translatedCommentary = commentary.text;
            }
            slok = slok.copyWith(
              dynamicTranslation: translation.text,
              dynamicCommentary: translatedCommentary,
            );
          } catch (e) {
            debugPrint('Dynamic Translation error: $e');
          }
        }

        currentSlok.value = slok;
        isFavorite.value = _repo.isFavorite(chapter, verse);
        await _repo.markVerseRead(chapter, verse);
      }
    } finally {
      isLoadingSlok.value = false;
    }
  }

  Future<void> changeLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    Get.updateLocale(Locale(langCode));
    if (currentSlok.value != null) {
      await loadSlok(currentSlok.value!.chapter, currentSlok.value!.verse);
    }
  }

  Future<void> toggleFavorite() async {
    final slok = currentSlok.value;
    if (slok == null) return;
    await _repo.toggleFavorite(slok);
    isFavorite.value = _repo.isFavorite(slok.chapter, slok.verse);
    final message = isFavorite.value ? 'added_favorite'.tr : 'removed_favorite'.tr;
    Get.snackbar('', message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16));
  }

  Future<void> speakVerse() async {
    final slok = currentSlok.value;
    if (slok == null) return;

    if (isSpeaking.value) {
      await stopSpeaking();
      return;
    }

    isSpeaking.value = true;
    final lang = selectedLanguage.value;
    String textToSpeak = '';
    String ttsLanguage = 'en-US';

    switch (lang) {
      case 'hi':
        textToSpeak = slok.hindiTranslation;
        ttsLanguage = 'hi-IN';
        break;
      case 'gu':
        textToSpeak = slok.gujaratiTranslation;
        ttsLanguage = 'gu-IN';
        break;
      case 'sa':
        textToSpeak = slok.slok;
        ttsLanguage = 'hi-IN'; // Fallback for Sanskrit
        break;
      case 'en':
      default:
        textToSpeak = slok.dynamicTranslation ?? slok.englishTranslation;
        ttsLanguage = 'en-US';
        break;
    }

    if (textToSpeak.isEmpty || textToSpeak == 'Translation not available.' || textToSpeak == 'अनुवाद उपलब्ध नहीं।' || textToSpeak == 'ગુજરાતી અનુવાદ ઉપલબ્ધ નથી.') {
      isSpeaking.value = false;
      return;
    }

    try {
      await flutterTts.setLanguage(ttsLanguage);
      await flutterTts.speak(textToSpeak);
    } catch (e) {
      isSpeaking.value = false;
      debugPrint('TTS Error: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    isSpeaking.value = false;
  }

  double getChapterProgress(int chapter, int totalVerses) =>
      _repo.getChapterProgress(chapter, totalVerses);

  String getTranslation(SlokModel slok, String langCode) {
    if (langCode == 'sa') return slok.slok;
    if (slok.dynamicTranslation != null) return slok.dynamicTranslation!;

    switch (langCode) {
      case 'hi':
        return slok.hindiTranslation;
      case 'gu':
        return slok.gujaratiTranslation;
      case 'en':
        return slok.englishTranslation;
      default:
        return slok.englishTranslation;
    }
  }

  String getCommentary(SlokModel slok, String langCode) {
    if (langCode == 'en' || langCode == 'hi' || langCode == 'gu' || langCode == 'sa') {
      return slok.englishCommentary;
    }
    return slok.dynamicCommentary ?? slok.englishCommentary;
  }
}
