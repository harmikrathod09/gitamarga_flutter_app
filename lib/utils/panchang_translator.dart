import 'package:get/get.dart';

class PanchangTranslator {
  static const Map<String, Map<String, String>> _translations = {
    // Paksha (Phases of Moon)
    'Shukla': {
      'en': 'Shukla',
      'hi': 'शुक्ल',
      'gu': 'શુક્લ',
      'sa': 'शुक्ल',
    },
    'Krishna': {
      'en': 'Krishna',
      'hi': 'कृष्ण',
      'gu': 'કૃષ્ણ',
      'sa': 'कृष्ण',
    },
    
    // Tithis (Lunar Days)
    'Pratipada': {
      'en': 'Pratipada',
      'hi': 'प्रतिपदा',
      'gu': 'પડવો (પ્રતિપદા)',
      'sa': 'प्रतिपदा',
    },
    'Dwitiya': {
      'en': 'Dwitiya',
      'hi': 'द्वितीया',
      'gu': 'બીજ (દ્વિતીયા)',
      'sa': 'द्वितीया',
    },
    'Tritiya': {
      'en': 'Tritiya',
      'hi': 'तृतीया',
      'gu': 'ત્રીજ (તૃતીયા)',
      'sa': 'तृतीया',
    },
    'Chaturthi': {
      'en': 'Chaturthi',
      'hi': 'चतुर्थी',
      'gu': 'ચોથ (ચતુર્થી)',
      'sa': 'चतुर्थी',
    },
    'Panchami': {
      'en': 'Panchami',
      'hi': 'पंचमी',
      'gu': 'પાંચમ (પંચમી)',
      'sa': 'पञ्चमी',
    },
    'Shashthi': {
      'en': 'Shashthi',
      'hi': 'षष्ठी',
      'gu': 'છઠ (ષષ્ઠી)',
      'sa': 'षष्ठी',
    },
    'Saptami': {
      'en': 'Saptami',
      'hi': 'सप्तमी',
      'gu': 'સાતમ (સપ્તમી)',
      'sa': 'सप्तमी',
    },
    'Ashtami': {
      'en': 'Ashtami',
      'hi': 'अष्टमी',
      'gu': 'આઠમ (અષ્ટમી)',
      'sa': 'अष्टमी',
    },
    'Navami': {
      'en': 'Navami',
      'hi': 'नवमी',
      'gu': 'નોમ (નવમી)',
      'sa': 'नवमी',
    },
    'Dashami': {
      'en': 'Dashami',
      'hi': 'दशमी',
      'gu': 'દશમ (દશમી)',
      'sa': 'दशमी',
    },
    'Ekadashi': {
      'en': 'Ekadashi',
      'hi': 'एकादशी',
      'gu': 'અગિયારસ (એકાદશી)',
      'sa': 'एकादशी',
    },
    'Dwadashi': {
      'en': 'Dwadashi',
      'hi': 'द्वादशी',
      'gu': 'બારસ (દ્વાદશી)',
      'sa': 'द्वादशी',
    },
    'Trayodashi': {
      'en': 'Trayodashi',
      'hi': 'त्रयोदशी',
      'gu': 'તેરસ (ત્રયોદશી)',
      'sa': 'त्रयोदशी',
    },
    'Chaturdashi': {
      'en': 'Chaturdashi',
      'hi': 'चतुर्दशी',
      'gu': 'ચૌદસ (ચતુર્દશી)',
      'sa': 'चतुर्दशी',
    },
    'Purnima': {
      'en': 'Purnima',
      'hi': 'पूर्णिमा',
      'gu': 'પૂનમ (પૂર્ણિમા)',
      'sa': 'पूर्णिमा',
    },
    'Amavasya': {
      'en': 'Amavasya',
      'hi': 'अमावस्या',
      'gu': 'અમાસ (અમાવસ્યા)',
      'sa': 'अमावास्या',
    },
    
    // Miscellaneous
    'Calculation Error': {
      'en': 'Calculation Error',
      'hi': 'गणना त्रुटि',
      'gu': 'ગણતરીની ભૂલ',
      'sa': 'गणना त्रुटिः',
    },
    'TODAY': {
      'en': 'TODAY',
      'hi': 'आज',
      'gu': 'આજે',
      'sa': 'अद्य',
    },
  };

  static String translate(String englishText) {
    if (englishText.isEmpty) return '';
    
    final currentLang = Get.locale?.languageCode ?? 'en';
    
    // If it's english, just return as is
    if (currentLang == 'en') return englishText;

    // Split text by space in case of "Shukla Ekadashi"
    final words = englishText.split(' ');
    
    final translatedWords = words.map((word) {
      // Find the exact translation or return original word if not found
      return _translations[word]?[currentLang] ?? word;
    }).toList();

    return translatedWords.join(' ');
  }
}
