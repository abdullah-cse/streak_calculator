import 'package:streak_calculator/src/calculators/weekly_streak_calculator.dart';
import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:test/test.dart';

void main() {
  late WeeklyStreakCalculator calculator;
  late DateTime today;

  setUp(() {
    calculator = const WeeklyStreakCalculator();
    today = DateTime(2025, 9, 18); //Fixed date for consistent testing
  });

  DateTime daysAgo(int days) => today.subtract(Duration(days: days));

  Set<DateTime> consecutiveDays(int startOffset, int count) =>
      {for (var i = 0; i < count; i++) daysAgo(startOffset + i)};

  group('WeeklyStreakCalculator', () {
    group('Validation', () {
      test('empty dates returns 0 streaks', () {
        final result = calculator.calculateStreak({}, 1, 3);
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 0);
        expect(result.streakType, StreakType.weekly);
        expect(result.streakTarget, 3);
      });

      test('invalid week start day throws', () {
        expect(() => calculator.calculateStreak({today}, 0, 3),
            throwsArgumentError);
        expect(() => calculator.calculateStreak({today}, 8, 3),
            throwsArgumentError);
      });

      test('invalid streak target throws', () {
        expect(() => calculator.calculateStreak({today}, 1, 0),
            throwsArgumentError);
        expect(() => calculator.calculateStreak({today}, 1, 8),
            throwsArgumentError);
      });
    });

    group('Single activity', () {
      test('today with target 1', () {
        final result = calculator.calculateStreak({today}, 1, 1);
        expect(result.currentStreak, 1);
        expect(result.bestStreak, 1);
      });

      test('today with higher target fails', () {
        final result = calculator.calculateStreak({today}, 1, 3);
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 0);
      });

      test('past date not this week', () {
        final result = calculator.calculateStreak({daysAgo(8)}, 1, 1);
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 1);
      });
    });

    group('Consecutive streaks', () {
      test('ending today', () {
        final dates = consecutiveDays(0, 3).union(consecutiveDays(7, 2));
        final result = calculator.calculateStreak(dates, 1, 2);
        expect(result.currentStreak, 5);
        expect(result.bestStreak, 5);
      });

      test('ending yesterday', () {
        final dates = consecutiveDays(7, 2).union(consecutiveDays(14, 3));
        final result = calculator.calculateStreak(
          dates,
          1,
          2,
          referenceDate: today, // Make it explicit
        );
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 5);
      });
    });

    group('Non-consecutive and multiple streaks', () {
      test('best streak correct', () {
        final dates = consecutiveDays(0, 1)
            .union(consecutiveDays(14, 3))
            .union(consecutiveDays(28, 2));
        final result = calculator.calculateStreak(dates, 1, 2);
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 3);
      });

      test('longest streak chosen as best', () {
        final dates = consecutiveDays(0, 2)
            .union(consecutiveDays(7, 3))
            .union(consecutiveDays(21, 4))
            .union(consecutiveDays(28, 3));
        final result = calculator.calculateStreak(dates, 1, 2);
        expect(result.currentStreak, 5);
        expect(result.bestStreak, 7);
      });
    });

    group('Streak target scenarios', () {
      test('break streak if not fulfilled', () {
        final dates = consecutiveDays(0, 1).union(consecutiveDays(8, 5));
        final result = calculator.calculateStreak(dates, 1, 3);
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 3); // Only 3 days qualify in the same week
      });

      test('dates exceeding target behave correctly', () {
        final dates = consecutiveDays(0, 6).union(consecutiveDays(7, 4));
        final result = calculator.calculateStreak(dates, 1, 3);
        expect(result.currentStreak, 10);
        expect(result.bestStreak, 10);
      });
    });

    group('Week start day effects', () {
      // test('different week starts create different streaks', () {
      //   final wednesday = DateTime(2024, 1, 10);
      //   final tuesday = wednesday.subtract(const Duration(days: 1));
      //   final monday = wednesday.subtract(const Duration(days: 2));
      //   final dates = {monday, tuesday, wednesday};

      //   final resultMon = calculator.calculateStreak(dates, 1, 2);
      //   final resultWed = calculator.calculateStreak(dates, 3, 2);

      //   expect(resultMon.currentStreak != resultWed.currentStreak, true);
      // });

      test('sunday vs monday start - different behavior', () {
        // Use dates that will span different weeks based on start day
        final saturday = DateTime(2024, 1, 6); // Saturday
        final sunday = DateTime(2024, 1, 7); // Sunday
        final monday = DateTime(2024, 1, 8); // Monday
        final dates = {saturday, sunday, monday};

        // Use Monday as reference date
        final referenceDate = DateTime(2024, 1, 8);

        final resultMon = calculator.calculateStreak(
          dates, 1, 2, // Monday start
          referenceDate: referenceDate,
        );
        final resultSun = calculator.calculateStreak(
          dates, 7, 2, // Sunday start
          referenceDate: referenceDate,
        );

        expect(resultMon.currentStreak != resultSun.currentStreak, true);
      });
    });

    group('Year boundary and leap year', () {
      test('spanning years', () {
        final dates = {
          DateTime(2023, 12, 29),
          DateTime(2023, 12, 30),
          DateTime(2023, 12, 31),
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 2),
        };
        final result = calculator.calculateStreak(dates, 1, 3);
        expect(result.bestStreak, greaterThan(0));
      });

      test('leap day handling', () {
        final dates = {
          DateTime(2024, 2, 28),
          DateTime(2024, 2, 29),
          DateTime(2024, 3, 1),
        };
        final result = calculator.calculateStreak(dates, 1, 2);
        expect(result.bestStreak, greaterThan(0));
      });
    });

    group('Edge cases', () {
      test('duplicates handled correctly', () {
        final dates = {today, today, today};
        final result = calculator.calculateStreak(dates, 1, 1);
        expect(result.currentStreak, 1);
        expect(result.bestStreak, 1);
      });

      test('long streaks maintain accuracy', () {
        // Create 50 consecutive days (10 weeks × 5 days) going backwards from today
        final dates = consecutiveDays(0, 50);

        final result = calculator.calculateStreak(dates, 1, 3);
        expect(result.currentStreak, 50);
        expect(result.bestStreak, 50);
      });

      test('week with exact target days', () {
        final dates = consecutiveDays(0, 3);
        final result = calculator.calculateStreak(dates, 1, 3);
        expect(result.currentStreak, 3);
        expect(result.bestStreak, 3);
      });
    });
  });
}
