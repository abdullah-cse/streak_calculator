import 'package:streak_calculator/src/calculators/monthly_streak_calculator.dart';
import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:test/test.dart';

void main() {
  late MonthlyStreakCalculator calculator;

  setUp(() {
    calculator = const MonthlyStreakCalculator();
  });

  /// Helper to create dates for a specific month
  Set<DateTime> datesInMonth(int year, int month, List<int> days) =>
      days.map((day) => DateTime(year, month, day)).toSet();

  /// Helper to create consecutive days spanning multiple months
  Set<DateTime> consecutiveDaysFromDate(DateTime startDate, int count) {
    final dates = <DateTime>{};
    for (int i = 0; i < count; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  group('MonthlyStreakCalculator', () {
    group('Validation', () {
      test('empty dates returns 0 streaks', () {
        final result = calculator.calculateStreak({}, 5);
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 0);
        expect(result.streakType, StreakType.monthly);
        expect(result.streakTarget, 5);
      });

      test('invalid streak target throws ArgumentError', () {
        final dates = {DateTime(2025, 1, 1)};
        
        expect(() => calculator.calculateStreak(dates, 0), throwsArgumentError);
        expect(() => calculator.calculateStreak(dates, 29), throwsArgumentError);
        expect(() => calculator.calculateStreak(dates, -1), throwsArgumentError);
      });

      test('valid streak targets work correctly', () {
        final dates = {DateTime(2025, 1, 1)};
        
        expect(() => calculator.calculateStreak(dates, 1), returnsNormally);
        expect(() => calculator.calculateStreak(dates, 28), returnsNormally);
      });
    });

    group('Single month scenarios', () {
      test('current month meets target', () {
        final dates = datesInMonth(2025, 9, [1, 5, 10, 15, 20]); // 5 days
        final result = calculator.calculateStreak(dates, 3);
        
        expect(result.currentStreak, 1);
        expect(result.bestStreak, 1);
      });

      test('current month fails target', () {
        final dates = datesInMonth(2025, 9, [1, 5]); // Only 2 days
        final result = calculator.calculateStreak(dates, 3);
        
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 0);
      });

      test('past month meets target', () {
        final dates = datesInMonth(2025, 1, [1, 5, 10, 15, 20]); // 5 days
        final result = calculator.calculateStreak(dates, 3);
        
        expect(result.currentStreak, 0); // Not current month
        expect(result.bestStreak, 1);
      });
    });

    group('Consecutive months', () {
      test('perfect consecutive streak from past to current', () {
        final dates = datesInMonth(2025, 7, [1, 5, 10, 15, 20]) // July: 5 days
            .union(datesInMonth(2025, 8, [2, 8, 14, 20])) // August: 4 days  
            .union(datesInMonth(2025, 9, [3, 9, 15])); // September: 3 days
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 3);
        expect(result.bestStreak, 3);
      });

      test('streak broken by insufficient month', () {
        final dates = datesInMonth(2025, 7, [1, 5, 10, 15]) // July: 4 days
            .union(datesInMonth(2025, 8, [2, 8])) // August: 2 days (breaks streak)
            .union(datesInMonth(2025, 9, [3, 9, 15, 21])); // September: 4 days
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 1); // Only September
        expect(result.bestStreak, 1); // July and September individually
      });

      test('gap in months breaks current streak', () {
        final dates = datesInMonth(2025, 6, [1, 5, 10, 15]) // June: 4 days
            .union(datesInMonth(2025, 9, [3, 9, 15, 21])); // September: 4 days (gap in July-Aug)
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 1); // Only September
        expect(result.bestStreak, 1); // Each month individually
      });
    });

    group('Best streak calculation', () {
      test('best streak longer than current', () {
        final dates = datesInMonth(2025, 1, [1, 5, 10, 15]) // Jan: 4 days
            .union(datesInMonth(2025, 2, [2, 8, 14, 20])) // Feb: 4 days
            .union(datesInMonth(2025, 3, [3, 9, 15, 21])) // Mar: 4 days
            .union(datesInMonth(2025, 5, [1, 7])) // May: 2 days (breaks)
            .union(datesInMonth(2025, 9, [3, 9, 15])); // Sep: 3 days
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 1); // Only September
        expect(result.bestStreak, 3); // Jan-Feb-Mar streak
      });

      test('multiple streaks - longest wins', () {
        final dates = datesInMonth(2025, 1, [1, 5, 10, 15]) // Jan: 4 days
            .union(datesInMonth(2025, 2, [2, 8, 14, 20])) // Feb: 4 days (streak of 2)
            .union(datesInMonth(2025, 4, [1, 7, 14, 21, 28])) // Apr: 5 days
            .union(datesInMonth(2025, 5, [3, 9, 15, 21])) // May: 4 days
            .union(datesInMonth(2025, 6, [1, 8, 15, 22])) // Jun: 4 days
            .union(datesInMonth(2025, 7, [5, 12, 19, 26])); // Jul: 4 days (streak of 4)
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 0); // No current streak
        expect(result.bestStreak, 4); // Apr-May-Jun-Jul streak
      });
    });

    group('Month variations (28-31 days)', () {
      test('february leap year vs non-leap year', () {
        // Leap year 2024
        final leapDates = datesInMonth(2024, 2, [1, 5, 10, 15, 20, 25, 29]); // 7 days
        final leapResult = calculator.calculateStreak(leapDates, 5);
        
        // Non-leap year 2025  
        final nonLeapDates = datesInMonth(2025, 2, [1, 5, 10, 15, 20, 25]); // 6 days
        final nonLeapResult = calculator.calculateStreak(nonLeapDates, 5);
        
        expect(leapResult.bestStreak, 1); // 7 days meets target of 5
        expect(nonLeapResult.bestStreak, 1); // 6 days meets target of 5
      });

      test('february with exactly 28 days target', () {
        final dates = List.generate(28, (i) => DateTime(2025, 2, i + 1)).toSet();
        final result = calculator.calculateStreak(dates, 28);
        
        expect(result.bestStreak, 1); // Exactly meets target
      });

      test('different month lengths handle targets correctly', () {
        final dates = datesInMonth(2025, 1, List.generate(31, (i) => i + 1)) // Jan: 31 days
            .union(datesInMonth(2025, 2, List.generate(28, (i) => i + 1))) // Feb: 28 days
            .union(datesInMonth(2025, 3, List.generate(31, (i) => i + 1))); // Mar: 31 days
        
        final result = calculator.calculateStreak(dates, 25);
        expect(result.bestStreak, 3); // All consecutive months exceed 25 days
      });
    });

    group('Year boundary scenarios', () {
      test('streak spanning years', () {
        final dates = datesInMonth(2024, 11, [1, 8, 15, 22, 29]) // Nov 2024: 5 days
            .union(datesInMonth(2024, 12, [3, 10, 17, 24, 31])) // Dec 2024: 5 days
            .union(datesInMonth(2025, 1, [2, 9, 16, 23, 30])); // Jan 2025: 5 days
        
        final result = calculator.calculateStreak(dates, 4);
        expect(result.bestStreak, 3); // Consecutive across year boundary
      });

      test('current streak across year boundary', () {
        final dates = datesInMonth(2024, 12, [1, 8, 15, 22, 29]) // Dec 2024: 5 days
            .union(datesInMonth(2025, 1, [2, 9, 16, 23])) // Jan 2025: 4 days
            .union(datesInMonth(2025, 2, [1, 7, 14, 21])) // Feb 2025: 4 days
            .union(datesInMonth(2025, 9, [3, 9, 15, 21])); // Sep 2025: 4 days (current)
        
        final result = calculator.calculateStreak(dates, 4);
        expect(result.currentStreak, 1); // Only current September
        expect(result.bestStreak, 3); // Dec 2024 - Jan 2025 - Feb 2025
      });
    });

    group('Edge cases', () {
      test('duplicate dates handled correctly', () {
        final dates = {
          DateTime(2025, 9, 1),
          DateTime(2025, 9, 1), // Duplicate
          DateTime(2025, 9, 5),
          DateTime(2025, 9, 5), // Duplicate
          DateTime(2025, 9, 10),
        };
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 1); // Only 3 unique days
        expect(result.bestStreak, 1);
      });

      test('very high target never met', () {
        final dates = datesInMonth(2025, 9, [1, 5, 10, 15, 20, 25]); // 6 days
        final result = calculator.calculateStreak(dates, 25);
        
        expect(result.currentStreak, 0);
        expect(result.bestStreak, 0);
      });

      test('target of 1 always met when dates exist', () {
        final dates = datesInMonth(2025, 9, [15]); // Single day
        final result = calculator.calculateStreak(dates, 1);
        
        expect(result.currentStreak, 1);
        expect(result.bestStreak, 1);
      });

      test('long streak maintains accuracy', () {
        // Create 12 consecutive months with sufficient activity
        final dates = <DateTime>{};
        for (int month = 1; month <= 12; month++) {
          dates.addAll(datesInMonth(2024, month, [1, 8, 15, 22])); // 4 days each month
        }
        dates.addAll(datesInMonth(2025, 9, [1, 8, 15, 22])); // Current month
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 1); // Only current September 2025
        expect(result.bestStreak, 12); // All 12 months of 2024
      });

      test('consecutive days spanning months', () {
        // Create 10 consecutive days that span from January to February
        final dates = consecutiveDaysFromDate(DateTime(2025, 1, 28), 10);
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.bestStreak, 2); // Both January and February have ≥3 days
      });
    });

    group('Current streak logic', () {
      test('current month gap breaks current streak', () {
        final dates = datesInMonth(2025, 7, [1, 8, 15, 22]); // July: 4 days, gap to current
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 0); // Gap > 1 month from current
        expect(result.bestStreak, 1);
      });

      test('previous month continues current streak', () {
        final dates = datesInMonth(2025, 8, [1, 8, 15, 22]) // August: 4 days
            .union(datesInMonth(2025, 9, [3, 9, 15, 21])); // September: 4 days
        
        final result = calculator.calculateStreak(dates, 3);
        expect(result.currentStreak, 2); // August and September
        expect(result.bestStreak, 2);
      });
    });
  });
}