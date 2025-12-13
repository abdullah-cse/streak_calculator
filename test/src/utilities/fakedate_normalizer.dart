import 'package:streak_calculator/src/utilities/date_normalizer.dart';

/// A fake DateNormalizer so we can control "today".
class FakeDateNormalizer extends DateNormalizer {
  const FakeDateNormalizer(this.fixedToday);
  final DateTime fixedToday;

  @override
  DateTime getTodayNormalized() => DateTime(
        fixedToday.year,
        fixedToday.month,
        fixedToday.day,
      );
}
