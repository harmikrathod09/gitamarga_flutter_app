class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://vedicscriptures.github.io';

  static const String chapters = '/chapters';
  static String chapter(int n) => '/chapter/$n';
  static String slok(int chapter, int verse) => '/slok/$chapter/$verse';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // Fallback API
  static const String fallbackBaseUrl = 'https://bhagavadgita.theaum.org';
}
