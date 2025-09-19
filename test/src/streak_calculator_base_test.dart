import 'package:streak_calculator/streak_calculator.dart';
import 'package:test/test.dart';

void main() {
  group('StreakCalculator - Validation', () {
    final validDates = [
      DateTime(2025, 9, 15),
      DateTime(2025, 9, 16),
      DateTime(2025, 9, 17),
    ];

    test('throws AssertionError when dates list is empty (constructor, debug)',
        () {
      expect(
        () => StreakCalculator(dates: [], streakType: StreakType.daily),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws ArgumentError when dates list is empty (validateArguments)',
        () {
      expect(
        () => StreakCalculator.validateArguments(
            [], StreakType.daily, 1, DateTime.monday),
        throwsArgumentError,
      );
    });

    test(
        'throws AssertionError for invalid weekly streakTarget (constructor, debug)',
        () {
      expect(
        () => StreakCalculator(
          dates: validDates,
          streakType: StreakType.weekly,
          streakTarget: 0,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => StreakCalculator(
          dates: validDates,
          streakType: StreakType.weekly,
          streakTarget: 8,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'throws ArgumentError for invalid weekly streakTarget (validateArguments)',
        () {
      expect(
        () => StreakCalculator.validateArguments(
            validDates, StreakType.weekly, 0, DateTime.monday),
        throwsArgumentError,
      );

      expect(
        () => StreakCalculator.validateArguments(
            validDates, StreakType.weekly, 8, DateTime.monday),
        throwsArgumentError,
      );
    });

    test(
        'throws AssertionError for invalid monthly streakTarget (constructor, debug)',
        () {
      expect(
        () => StreakCalculator(
          dates: validDates,
          streakType: StreakType.monthly,
          streakTarget: 0,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => StreakCalculator(
          dates: validDates,
          streakType: StreakType.monthly,
          streakTarget: 29,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'throws ArgumentError for invalid monthly streakTarget (validateArguments)',
        () {
      expect(
        () => StreakCalculator.validateArguments(
            validDates, StreakType.monthly, 0, DateTime.monday),
        throwsArgumentError,
      );

      expect(
        () => StreakCalculator.validateArguments(
            validDates, StreakType.monthly, 29, DateTime.monday),
        throwsArgumentError,
      );
    });

    test('throws AssertionError for invalid weekStartDay (constructor, debug)',
        () {
      expect(
        () => StreakCalculator(
          dates: validDates,
          streakType: StreakType.weekly,
          streakTarget: 3,
          weekStartDay: 0,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => StreakCalculator(
          dates: validDates,
          streakType: StreakType.weekly,
          streakTarget: 3,
          weekStartDay: 8,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws ArgumentError for invalid weekStartDay (validateArguments)',
        () {
      expect(
        () => StreakCalculator.validateArguments(
            validDates, StreakType.weekly, 3, 0),
        throwsArgumentError,
      );

      expect(
        () => StreakCalculator.validateArguments(
            validDates, StreakType.weekly, 3, 8),
        throwsArgumentError,
      );
    });
  });

  group('StreakCalculator - Valid construction', () {
    final dates = [
      DateTime(2025, 9, 15),
      DateTime(2025, 9, 16),
      DateTime(2025, 9, 17),
    ];

    test('constructs daily streak successfully', () {
      final calc = StreakCalculator(dates: dates, streakType: StreakType.daily);
      expect(calc.currentStreak, isA<int>());
      expect(calc.bestStreak, isA<int>());
    });

    test('constructs weekly streak successfully', () {
      final calc = StreakCalculator(
        dates: dates,
        streakType: StreakType.weekly,
        streakTarget: 2,
        weekStartDay: DateTime.monday,
      );
      expect(calc.currentStreak, isA<int>());
      expect(calc.bestStreak, isA<int>());
    });

    test('constructs monthly streak successfully', () {
      final calc = StreakCalculator(
        dates: dates,
        streakType: StreakType.monthly,
        streakTarget: 5,
      );
      expect(calc.currentStreak, isA<int>());
      expect(calc.bestStreak, isA<int>());
    });
  });
}
