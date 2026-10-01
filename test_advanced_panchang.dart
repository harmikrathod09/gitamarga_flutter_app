import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/all.dart';

void main() {
  final panchang = Panchang([registerAllCities]);
  final now = DateTime.now();
  final utcNow = DateTime.utc(now.year, now.month, now.day);
  try {
    final nak = panchang.nakshatraOnDate(utcNow, City.ujjain);
    print('Nakshatra: ${nak.displayName}');
    
    final yoga = panchang.yogaOnDate(utcNow, City.ujjain);
    print('Yoga: ${yoga.displayName}');
    
    final karana = panchang.karanaOnDate(utcNow, City.ujjain);
    print('Karana: ${karana.displayName}');
    
    print('Sun: ${panchang.sun(City.ujjain)}');
  } catch (e) {
    print('Error: $e');
  }
}
