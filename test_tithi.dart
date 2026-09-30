import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/all.dart';

void main() {
  try {
    final panchang = Panchang([registerAllCities]);
    final now = DateTime.now();
    final info = panchang.tithiOnDate(DateTime.utc(now.year, now.month, now.day), City.ujjain);
    print('SUCCESS: ${info.displayName}');
  } catch (e, stack) {
    print('ERROR: $e');
    print(stack);
  }
}
