

enum ChoghadiyaType {
  udveg,
  chal,
  labh,
  amrut,
  kaal,
  shubh,
  rog,
}

class ChoghadiyaName {
  final ChoghadiyaType type;

  const ChoghadiyaName(this.type);

  String get english {
    switch (type) {
      case ChoghadiyaType.udveg: return 'Udveg';
      case ChoghadiyaType.chal: return 'Chal';
      case ChoghadiyaType.labh: return 'Labh';
      case ChoghadiyaType.amrut: return 'Amrut';
      case ChoghadiyaType.kaal: return 'Kaal';
      case ChoghadiyaType.shubh: return 'Shubh';
      case ChoghadiyaType.rog: return 'Rog';
    }
  }

  String get hindi {
    switch (type) {
      case ChoghadiyaType.udveg: return 'उद्वेग';
      case ChoghadiyaType.chal: return 'चर';
      case ChoghadiyaType.labh: return 'लाभ';
      case ChoghadiyaType.amrut: return 'अमृत';
      case ChoghadiyaType.kaal: return 'काल';
      case ChoghadiyaType.shubh: return 'शुभ';
      case ChoghadiyaType.rog: return 'रोग';
    }
  }

  String get sanskrit {
    switch (type) {
      case ChoghadiyaType.udveg: return 'उद्वेग';
      case ChoghadiyaType.chal: return 'चल';
      case ChoghadiyaType.labh: return 'लाभ';
      case ChoghadiyaType.amrut: return 'अमृत';
      case ChoghadiyaType.kaal: return 'काल';
      case ChoghadiyaType.shubh: return 'शुभ';
      case ChoghadiyaType.rog: return 'रोग';
    }
  }

  String get gujarati {
    switch (type) {
      case ChoghadiyaType.udveg: return 'ઉદ્વેગ';
      case ChoghadiyaType.chal: return 'ચલ';
      case ChoghadiyaType.labh: return 'લાભ';
      case ChoghadiyaType.amrut: return 'અમૃત';
      case ChoghadiyaType.kaal: return 'કાળ';
      case ChoghadiyaType.shubh: return 'શુભ';
      case ChoghadiyaType.rog: return 'રોગ';
    }
  }

  String get displayMeaning {
    switch (type) {
      case ChoghadiyaType.udveg: return 'Bad';
      case ChoghadiyaType.chal: return 'Neutral';
      case ChoghadiyaType.labh: return 'Good';
      case ChoghadiyaType.amrut: return 'Best';
      case ChoghadiyaType.kaal: return 'Bad';
      case ChoghadiyaType.shubh: return 'Good';
      case ChoghadiyaType.rog: return 'Bad';
    }
  }
}

class ChoghadiyaPeriod {
  final ChoghadiyaName name;
  final DateTime startTime;
  final DateTime endTime;
  final bool isDay;

  ChoghadiyaPeriod({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.isDay,
  });

  @override
  String toString() {
    String formatTime(DateTime time) => 
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    
    return '${formatTime(startTime)} - ${formatTime(endTime)} | '
           '${name.english.padRight(7)} | ${name.hindi.padRight(6)} | '
           '${name.sanskrit.padRight(6)} | ${name.gujarati.padRight(6)} | '
           '(${name.displayMeaning})';
  }
}

class ChoghadiyaCalculator {
  static const Map<int, List<ChoghadiyaType>> _daySequences = {
    DateTime.sunday: [ChoghadiyaType.udveg, ChoghadiyaType.chal, ChoghadiyaType.labh, ChoghadiyaType.amrut, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg],
    DateTime.monday: [ChoghadiyaType.amrut, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.chal, ChoghadiyaType.labh, ChoghadiyaType.amrut],
    DateTime.tuesday: [ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.chal, ChoghadiyaType.labh, ChoghadiyaType.amrut, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog],
    DateTime.wednesday: [ChoghadiyaType.labh, ChoghadiyaType.amrut, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.chal, ChoghadiyaType.labh],
    DateTime.thursday: [ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.chal, ChoghadiyaType.labh, ChoghadiyaType.amrut, ChoghadiyaType.kaal, ChoghadiyaType.shubh],
    DateTime.friday: [ChoghadiyaType.chal, ChoghadiyaType.labh, ChoghadiyaType.amrut, ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.chal],
    DateTime.saturday: [ChoghadiyaType.kaal, ChoghadiyaType.shubh, ChoghadiyaType.rog, ChoghadiyaType.udveg, ChoghadiyaType.chal, ChoghadiyaType.labh, ChoghadiyaType.amrut, ChoghadiyaType.kaal],
  };

  static const Map<int, List<ChoghadiyaType>> _nightSequences = {
    DateTime.sunday: [ChoghadiyaType.shubh, ChoghadiyaType.amrut, ChoghadiyaType.chal, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh],
    DateTime.monday: [ChoghadiyaType.chal, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrut, ChoghadiyaType.chal],
    DateTime.tuesday: [ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrut, ChoghadiyaType.chal, ChoghadiyaType.rog, ChoghadiyaType.kaal],
    DateTime.wednesday: [ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrut, ChoghadiyaType.chal, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg],
    DateTime.thursday: [ChoghadiyaType.amrut, ChoghadiyaType.chal, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrut],
    DateTime.friday: [ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrut, ChoghadiyaType.chal, ChoghadiyaType.rog],
    DateTime.saturday: [ChoghadiyaType.labh, ChoghadiyaType.udveg, ChoghadiyaType.shubh, ChoghadiyaType.amrut, ChoghadiyaType.chal, ChoghadiyaType.rog, ChoghadiyaType.kaal, ChoghadiyaType.labh],
  };

  /// Calculates Choghadiya periods for daytime (Sunrise to Sunset)
  static List<ChoghadiyaPeriod> getDayChoghadiya(DateTime sunrise, DateTime sunset) {
    int weekday = sunrise.weekday;
    final sequence = _daySequences[weekday]!;
    
    Duration totalDayDuration = sunset.difference(sunrise);
    Duration choghadiyaDuration = Duration(minutes: totalDayDuration.inMinutes ~/ 8);
    
    List<ChoghadiyaPeriod> periods = [];
    DateTime currentStart = sunrise;
    
    for (int i = 0; i < 8; i++) {
      DateTime currentEnd = i == 7 ? sunset : currentStart.add(choghadiyaDuration);
      periods.add(ChoghadiyaPeriod(
        name: ChoghadiyaName(sequence[i]),
        startTime: currentStart,
        endTime: currentEnd,
        isDay: true,
      ));
      currentStart = currentEnd;
    }
    
    return periods;
  }

  /// Calculates Choghadiya periods for nighttime (Sunset to next day's Sunrise)
  static List<ChoghadiyaPeriod> getNightChoghadiya(DateTime sunset, DateTime nextSunrise) {
    int weekday = sunset.weekday; // Sequence depends on the day the sunset occurred
    final sequence = _nightSequences[weekday]!;
    
    Duration totalNightDuration = nextSunrise.difference(sunset);
    Duration choghadiyaDuration = Duration(minutes: totalNightDuration.inMinutes ~/ 8);
    
    List<ChoghadiyaPeriod> periods = [];
    DateTime currentStart = sunset;
    
    for (int i = 0; i < 8; i++) {
      DateTime currentEnd = i == 7 ? nextSunrise : currentStart.add(choghadiyaDuration);
      periods.add(ChoghadiyaPeriod(
        name: ChoghadiyaName(sequence[i]),
        startTime: currentStart,
        endTime: currentEnd,
        isDay: false,
      ));
      currentStart = currentEnd;
    }
    
    return periods;
  }
}
