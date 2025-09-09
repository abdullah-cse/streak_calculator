import 'package:streak_calculator/src/calculators/daily_streak_calculator.dart';
import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:streak_calculator/src/utilities/date_normalizer.dart';
import 'package:test/test.dart';

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

void main() {
  group('DailyStreakCalculator', () {
    late DateTime today;
    late DailyStreakCalculator calculator;

    setUp(() {
      today = DateTime(2025, 9, 9); // fixed reference date
      calculator = DailyStreakCalculator(
        dateNormalizer: FakeDateNormalizer(today),
      );
    });

    test('returns 0 streaks for empty dates', () {
      final result = calculator.calculateStreak({});
      expect(result.currentStreak, 0);
      expect(result.bestStreak, 0);
      expect(result.streakType, StreakType.daily);
    });

    test('single activity today counts as current=1, best=1', () {
      final result = calculator.calculateStreak({today});
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test('single past date not today or yesterday counts as best=1, current=0',
        () {
      final oldDate = today.subtract(const Duration(days: 5));
      final result = calculator.calculateStreak({oldDate});
      expect(result.currentStreak, 0);
      expect(result.bestStreak, 1);
    });

    test('consecutive streak ending today', () {
      final dates = {
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      };
      final result = calculator.calculateStreak(dates);
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 3);
    });

    test('consecutive streak ending yesterday (no activity today)', () {
      final dates = {
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 3)),
      };
      final result = calculator.calculateStreak(dates);
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 3);
    });

    test('non-consecutive dates should give best streak correctly', () {
      final dates = {
        today,
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 5)),
        today.subtract(const Duration(days: 6)),
      };
      final result = calculator.calculateStreak(dates);
      expect(result.currentStreak, 1); // only today
      expect(result.bestStreak, 2); // from day-6 and day-5
    });

    test('multiple streaks, should return longest as best', () {
      final dates = {
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)), // streak of 3
        today.subtract(const Duration(days: 5)),
        today.subtract(const Duration(days: 6)),
        today.subtract(const Duration(days: 7)),
        today.subtract(const Duration(days: 8)), // streak of 4
      };
      final result = calculator.calculateStreak(dates);
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 4);
    });
  });
}
