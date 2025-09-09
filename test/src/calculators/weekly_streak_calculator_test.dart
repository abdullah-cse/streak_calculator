import 'package:streak_calculator/src/calculators/weekly_streak_calculator.dart';
import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:streak_calculator/src/enum/week_start_day.dart';
import 'package:streak_calculator/src/utilities/date_normalizer.dart';
import 'package:streak_calculator/src/utilities/week_key_generator.dart';
import 'package:test/test.dart';

/// Fake DateNormalizer to fix "today".
class FakeDateNormalizer extends DateNormalizer {
  const FakeDateNormalizer(this.fixedToday);
  final DateTime fixedToday;

  @override
  DateTime getTodayNormalized() =>
      DateTime(fixedToday.year, fixedToday.month, fixedToday.day);
}

/// Fake WeekKeyGenerator for predictable week keys.
/// Simplified: each Monday starts a new week, key = ISO year*100 + weekNumber.
class FakeWeekKeyGenerator extends WeekKeyGenerator {
  const FakeWeekKeyGenerator();

  @override
  int getWeekKey(DateTime date, WeekStartDay weekStartDay) {
    // ISO-ish: Monday-based weeks
    final diff = date.weekday - (weekStartDay == WeekStartDay.monday ? 1 : 7);
    final monday = date.subtract(Duration(days: diff));
    final weekOfYear = int.parse(
      "${monday.year}${monday.month.toString().padLeft(2, '0')}${monday.day.toString().padLeft(2, '0')}",
    );
    return weekOfYear;
  }
}

void main() {
  group('WeeklyStreakCalculator', () {
    late DateTime today;
    late WeeklyStreakCalculator calculator;

    setUp(() {
      today = DateTime(2025, 9, 9); // Tuesday
      calculator = WeeklyStreakCalculator(
        dateNormalizer: FakeDateNormalizer(today),
        weekKeyGenerator: const FakeWeekKeyGenerator(),
      );
    });

    test('empty dates returns 0 streaks', () {
      final result = calculator.calculateStreak({}, WeekStartDay.monday, null);
      expect(result.currentStreak, 0);
      expect(result.bestStreak, 0);
      expect(result.streakType, StreakType.weekly);
    });

    test('single activity this week counts as current=1, best=1', () {
      final result = calculator.calculateStreak(
        {today},
        WeekStartDay.monday,
        null,
      );
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test(
        'single activity last week counts as current=1 if no activity this week',
        () {
      final lastWeek = today.subtract(const Duration(days: 7));
      final result = calculator.calculateStreak(
        {lastWeek},
        WeekStartDay.monday,
        null,
      );
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test('non-consecutive weeks gives best=1, current=1', () {
      final w1 = today.subtract(const Duration(days: 7));
      final w3 = today.subtract(const Duration(days: 21));
      final result = calculator.calculateStreak(
        {w1, w3},
        WeekStartDay.monday,
        null,
      );
      expect(result.currentStreak, 1);
      expect(result.bestStreak, 1);
    });

    test('consecutive weekly streak ending this week', () {
      final d1 = today;
      final d2 = today.subtract(const Duration(days: 7));
      final d3 = today.subtract(const Duration(days: 14));
      final result = calculator.calculateStreak(
        {d1, d2, d3},
        WeekStartDay.monday,
        null,
      );
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 3);
    });

    test('consecutive weekly streak ending last week (no activity this week)',
        () {
      final d1 = today.subtract(const Duration(days: 7));
      final d2 = today.subtract(const Duration(days: 14));
      final d3 = today.subtract(const Duration(days: 21));
      final result = calculator.calculateStreak(
        {d1, d2, d3},
        WeekStartDay.monday,
        null,
      );
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 3);
    });

    test('streak target enforces minimum days per week', () {
      final d1 = today; // only 1 day this week
      final d2 = today.subtract(const Duration(days: 7));
      final d3 = today
          .subtract(const Duration(days: 7, hours: -1)); // 2nd day same week
      final result = calculator.calculateStreak(
        {d1, d2, d3},
        WeekStartDay.monday,
        2,
      );
      expect(
          result.currentStreak, 1,); // last week qualifies, this week does not
      expect(result.bestStreak, 1);
    });

    test('multiple streaks, best should be the longest', () {
      final dates = {
        today,
        today.subtract(const Duration(days: 7)),
        today.subtract(const Duration(days: 14)), // streak of 3
        today.subtract(const Duration(days: 35)),
        today.subtract(const Duration(days: 42)),
        today.subtract(const Duration(days: 49)),
        today.subtract(const Duration(days: 56)), // streak of 4
      };
      final result = calculator.calculateStreak(
        dates,
        WeekStartDay.monday,
        null,
      );
      expect(result.currentStreak, 3);
      expect(result.bestStreak, 4);
    });

    test('handles Sunday as week start day', () {
      final sunday = DateTime(2025, 9, 7); // Sunday before "today"
      final monday = DateTime(2025, 9, 8); // Monday (this week)
      final result = calculator.calculateStreak(
        {sunday, monday},
        WeekStartDay.sunday,
        null,
      );
      expect(
          result.currentStreak, 1,); // both fall into same week by Sunday-start
      expect(result.bestStreak, 1);
    });
  });
}
