
import 'lib/utils/choghadiya_calculator.dart';

void main() {
  // Let's assume today's sunrise and sunset times
  // For a real app, you can use tithi_engine or a weather API to get exact times
  
  // Example for Today (Using generic times: 6:00 AM to 6:00 PM)
  DateTime now = DateTime.now();
  
  DateTime sunrise = DateTime(now.year, now.month, now.day, 6, 0); // 6:00 AM
  DateTime sunset = DateTime(now.year, now.month, now.day, 18, 0); // 6:00 PM
  DateTime nextSunrise = DateTime(now.year, now.month, now.day + 1, 6, 0); // 6:00 AM next day

  print('--- Day Choghadiya ---');
  List<ChoghadiyaPeriod> dayPeriods = ChoghadiyaCalculator.getDayChoghadiya(sunrise, sunset);
  for (var period in dayPeriods) {
    print(period);
  }

  print('\n--- Night Choghadiya ---');
  List<ChoghadiyaPeriod> nightPeriods = ChoghadiyaCalculator.getNightChoghadiya(sunset, nextSunrise);
  for (var period in nightPeriods) {
    print(period);
  }
}
