import 'package:streak_calculator/src/calculators/monthly_streak_calculator.dart';
import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:streak_calculator/src/utilities/month_key_generator.dart';
import 'package:test/test.dart';

/// Fake generator to control month keys and simulate "today".
class FakeMonthKeyGenerator extends MonthKeyGenerator {
  const FakeMonthKeyGenerator(this.fixedToday);
  final DateTime fixedToday;

  @override
  int getMonthKey(DateTime date) => date.year * 12 + date.month;

  @override
  int getPreviousMonth(int monthKey) => monthKey - 1;

  @override
  int getNextMonth(int monthKey) => monthKey + 1;

  int get currentMonthKey => getMonthKey(fixedToday);
}

void main() {
  group('MonthlyStreakCalculator', () {
    late DateTime today;
    late MonthlyStreakCalculator calculator;
    late FakeMonthKeyGenerator fakeGen;

    setUp(() {
      today = DateTime(2025, 9, 9); // fixed reference date
      fakeGen = FakeMonthKeyGenerator(today);
      calculator = MonthlyStreakCalculator(monthKeyGenerator: fakeGen);
    });

    test('returns 0 streaks for empty dates', () {
      final result = calculator.calculateStreak({}, null);
      expect(result.currentStreak, 0);
      expect(result.bestStreak, 0);
      expect(result.streakType, StreakType.monthly);
    });

    test('single activity this month counts as current=1, best=1 (no target)',
        () {
      final result = calculator.calculateStreak({today}, null);
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test(
        'single activity last month counts as current=1 if no activity this month',
        () {
      final lastMonthDate = DateTime(today.year, today.month - 1, 15);
      final result = calculator.calculateStreak({lastMonthDate}, null);
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test('non-consecutive months gives best=1, current=1', () {
      final d1 = DateTime(today.year, today.month - 2, 10);
      final d2 = DateTime(today.year, today.month, 5);
      final result = calculator.calculateStreak({d1, d2}, null);
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test('consecutive months streak ending this month', () {
      final d1 = DateTime(today.year, today.month, 5);
      final d2 = DateTime(today.year, today.month - 1, 10);
      final d3 = DateTime(today.year, today.month - 2, 15);
      final result = calculator.calculateStreak({d1, d2, d3}, null);
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 3);
    });

    test('consecutive months streak ending last month (no activity this month)',
        () {
      final d1 = DateTime(today.year, today.month - 1, 10);
      final d2 = DateTime(today.year, today.month - 2, 20);
      final d3 = DateTime(today.year, today.month - 3, 25);
      final result = calculator.calculateStreak({d1, d2, d3}, null);
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 3);
    });

    test('streak target enforces minimum days per month', () {
      final d1 = DateTime(today.year, today.month, 1); // only 1 day
      final d2 = DateTime(today.year, today.month - 1, 1);
      final d3 =
          DateTime(today.year, today.month - 1, 2); // 2 days in prev month
      final result = calculator.calculateStreak({d1, d2, d3}, 2);
      expect(result.currentStreak, 1); // only last month meets target
      expect(result.bestStreak, 1);
    });

    test('multiple streaks, best should be the longest', () {
      final dates = {
        DateTime(today.year, today.month, 1),
        DateTime(today.year, today.month - 1, 2),
        DateTime(today.year, today.month - 2, 3), // streak of 3
        DateTime(today.year, today.month - 5, 1),
        DateTime(today.year, today.month - 6, 2),
        DateTime(today.year, today.month - 7, 3),
        DateTime(today.year, today.month - 8, 4), // streak of 4
      };
      final result = calculator.calculateStreak(dates, null);
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 4);
    });

    /// ---- Edge Cases ----

    test('handles December to January transition across years', () {
      final decDate = DateTime(2024, 12, 20);
      final janDate = DateTime(2025, 1, 10);
      final febDate = DateTime(2025, 2, 15);
      final result =
          calculator.calculateStreak({decDate, janDate, febDate}, null);
      expect(result.bestStreak, 3); // Dec → Jan → Feb
    });

    test('handles leap year February transition Feb → Mar', () {
      final feb29 = DateTime(2024, 2, 29); // leap day
      final mar1 = DateTime(2024, 3, 1);
      final result = calculator.calculateStreak({feb29, mar1}, null);
      expect(result.bestStreak, 2); // Feb → Mar consecutive
    });
  });
}
