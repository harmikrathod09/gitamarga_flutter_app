import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/chapter_model.dart';
import '../models/slok_model.dart';
import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService extends GetxService {
  late final Dio _dio;
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
    ));
  }

  // ─── Chapters ───────────────────────────────────────────────────────────────

  Future<List<ChapterModel>> getChapters() async {
    // Check cache first
    final cached = _storage.getCachedChapters();
    if (cached != null) return cached;

    try {
      final response = await _dio.get(ApiConstants.chapters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final chapters = data
            .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
            .toList();
        await _storage.cacheChapters(chapters);
        return chapters;
      }
      throw DioException(requestOptions: response.requestOptions);
    } on DioException catch (_) {
      final cached = _storage.getCachedChapters();
      if (cached != null) return cached;
      return _getFallbackChapters();
    } catch (e) {
      return _getFallbackChapters();
    }
  }

  Future<ChapterModel?> getChapter(int chapterNumber) async {
    try {
      final response = await _dio.get(ApiConstants.chapter(chapterNumber));
      if (response.statusCode == 200) {
        return ChapterModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // Return from cached chapters list if available
      final chapters = _storage.getCachedChapters();
      return chapters?.firstWhere(
        (c) => c.chapterNumber == chapterNumber,
        orElse: () => _getFallbackChapters()[chapterNumber - 1],
      );
    }
  }

  // ─── Verses ─────────────────────────────────────────────────────────────────

  Future<SlokModel?> getSlok(int chapter, int verse) async {
    // Check cache
    final cached = _storage.getCachedSlok(chapter, verse);
    if (cached != null) return cached;

    try {
      final response = await _dio.get(ApiConstants.slok(chapter, verse));
      if (response.statusCode == 200) {
        // API returns flat JSON with chapter/verse merged
        final data = response.data as Map<String, dynamic>;
        data['chapter'] = chapter;
        data['verse'] = verse;
        final slok = SlokModel.fromJson(data);
        await _storage.cacheSlok(chapter, verse, slok);
        return slok;
      }
      return null;
    } on DioException catch (_) {
      final cached = _storage.getCachedSlok(chapter, verse);
      return cached ?? _getFallbackSlok(chapter, verse);
    } catch (_) {
      return _getFallbackSlok(chapter, verse);
    }
  }

  // ─── Fallback Data ───────────────────────────────────────────────────────────

  List<ChapterModel> _getFallbackChapters() {
    final data = [
      {'chapter_number': 1, 'name': 'अर्जुनविषादयोग:', 'translation': 'Arjuna\'s Dilemma', 'verses_count': 47, 'summary': 'Arjuna, overwhelmed with grief and compassion, lays down his bow on the battlefield.'},
      {'chapter_number': 2, 'name': 'साङ्ख्ययोग:', 'translation': 'Sankhya Yoga', 'verses_count': 72, 'summary': 'Krishna begins his teachings by explaining the nature of the eternal soul, the path of action, and the wisdom of discrimination.'},
      {'chapter_number': 3, 'name': 'कर्मयोग:', 'translation': 'Karma Yoga', 'verses_count': 43, 'summary': 'Krishna explains the path of selfless action and the importance of performing one\'s duty without attachment to results.'},
      {'chapter_number': 4, 'name': 'ज्ञानकर्मसंन्यासयोग:', 'translation': 'Jnana Karma Sannyasa Yoga', 'verses_count': 42, 'summary': 'Krishna reveals the divine mystery of incarnation and the greatness of spiritual wisdom combined with action.'},
      {'chapter_number': 5, 'name': 'संन्यासयोग:', 'translation': 'Karma Sannyasa Yoga', 'verses_count': 29, 'summary': 'The reconciliation between renunciation of action and selfless service as paths to the same goal.'},
      {'chapter_number': 6, 'name': 'आत्मसंयमयोग:', 'translation': 'Dhyana Yoga', 'verses_count': 47, 'summary': 'The practice of meditation, self-discipline, and the withdrawal of the mind from sense objects.'},
      {'chapter_number': 7, 'name': 'ज्ञानविज्ञानयोग:', 'translation': 'Jnana Vijnana Yoga', 'verses_count': 30, 'summary': 'Krishna reveals his divine nature and the two aspects of his energy — material and spiritual.'},
      {'chapter_number': 8, 'name': 'अक्षरब्रह्मयोग:', 'translation': 'Aksara Brahma Yoga', 'verses_count': 28, 'summary': 'The mystery of God, the universe, and the paths available to the soul at the time of death.'},
      {'chapter_number': 9, 'name': 'राजविद्याराजगुह्ययोग:', 'translation': 'Raja Vidya Yoga', 'verses_count': 34, 'summary': 'The royal knowledge and supreme secret: the all-pervading nature of God and the devotion that leads to union.'},
      {'chapter_number': 10, 'name': 'विभूतियोग:', 'translation': 'Vibhuti Yoga', 'verses_count': 42, 'summary': 'Krishna describes his divine manifestations and glories in the universe.'},
      {'chapter_number': 11, 'name': 'विश्वरूपदर्शनयोग:', 'translation': 'Vishwarupa Darsana Yoga', 'verses_count': 55, 'summary': 'Arjuna sees the cosmic, universal form of Lord Krishna — the most awe-inspiring vision in the Gita.'},
      {'chapter_number': 12, 'name': 'भक्तियोग:', 'translation': 'Bhakti Yoga', 'verses_count': 20, 'summary': 'The supreme path of devotion and love as the highest means of knowing God.'},
      {'chapter_number': 13, 'name': 'क्षेत्रक्षेत्रज्ञविभागयोग:', 'translation': 'Kshetra Kshetrajna Vibhaga Yoga', 'verses_count': 35, 'summary': 'Distinguishing between the body (field) and the soul (knower of the field), and the path to liberation.'},
      {'chapter_number': 14, 'name': 'गुणत्रयविभागयोग:', 'translation': 'Gunatraya Vibhaga Yoga', 'verses_count': 27, 'summary': 'The three qualities of material nature (Sattva, Rajas, Tamas) and how to transcend them.'},
      {'chapter_number': 15, 'name': 'पुरुषोत्तमयोग:', 'translation': 'Purushottama Yoga', 'verses_count': 20, 'summary': 'The Eternal Tree and the Supreme Person — understanding God as beyond both perishable and imperishable.'},
      {'chapter_number': 16, 'name': 'दैवासुरसम्पद्विभागयोग:', 'translation': 'Daivasura Sampad Vibhaga Yoga', 'verses_count': 24, 'summary': 'The divine and demoniac natures — and the importance of following scriptural guidelines.'},
      {'chapter_number': 17, 'name': 'श्रद्धात्रयविभागयोग:', 'translation': 'Shraddhatraya Vibhaga Yoga', 'verses_count': 28, 'summary': 'The three kinds of faith — Sattvic, Rajasic, and Tamasic — and how they manifest in life.'},
      {'chapter_number': 18, 'name': 'मोक्षसंन्यासयोग:', 'translation': 'Moksha Sannyasa Yoga', 'verses_count': 78, 'summary': 'The final conclusion: surrender to God as the ultimate path to liberation and the highest wisdom.'},
    ];
    return data.map((e) => ChapterModel.fromJson(e)).toList();
  }

  SlokModel _getFallbackSlok(int chapter, int verse) {
    return SlokModel(
      chapter: chapter,
      verse: verse,
      slok: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
      transliteration: 'karmaṇy-evādhikāras te mā phaleṣhu kadāchana\nmā karma-phala-hetur bhūr mā te saṅgo \'stvakarmaṇi',
      sivananda: SivanandaTranslation(
        name: 'Swami Sivananda',
        et: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself the cause of the results of your activities, and never be attached to not doing your duty.',
        ec: 'This is one of the most important verses of the Bhagavad Gita. It teaches the central doctrine of Nishkama Karma — selfless action done without the desire for its fruits.',
      ),
      ramsukhdas: HindiTranslation(
        name: 'स्वामी रामसुखदास',
        ht: 'तेरा कर्म करने में ही अधिकार है, उसके फलों में कभी नहीं। इसलिए तू कर्मों के फल का हेतु मत बन तथा तेरी कर्म न करने में भी आसक्ति न हो।',
      ),
    );
  }
}
