import 'calculators/daily_streak_calculator.dart';
import 'calculators/monthly_streak_calculator.dart';
import 'calculators/weekly_streak_calculator.dart';
import 'enum/streak_type.dart';
import 'model/streak_result.dart';
import 'utilities/date_normalizer.dart';

/// A utility class for calculating streaks (daily, weekly, or monthly)
/// based on a list of [DateTime] values.
///
/// Computes both the **current streak** and the **best streak** for
/// the provided dates and configuration.
///
/// Example usage:
/// ```dart
/// import 'package:streak_calculator/streak_calculator.dart';
///
/// void main() {
///   final dates = [
///     DateTime(2025, 9, 15),
///     DateTime(2025, 9, 16),
///     DateTime(2025, 9, 17),
///   ];
///
///   final daily = StreakCalculator(dates: dates, streakType: StreakType.daily);
///   print('Daily Current Streak: ${daily.currentStreak}');
///   print('Daily Best Streak: ${daily.bestStreak}');
///
///   final weekly = StreakCalculator(
///     dates: dates,
///     streakType: StreakType.weekly,
///     streakTarget: 3,
///     weekStartDay: DateTime.monday,
///   );
///   print('Weekly Current Streak: ${weekly.currentStreak}');
///   print('Weekly Best Streak: ${weekly.bestStreak}');
///
///   final monthly = StreakCalculator(
///     dates: dates,
///     streakType: StreakType.monthly,
///     streakTarget: 5,
///   );
///   print('Monthly Current Streak: ${monthly.currentStreak}');
///   print('Monthly Best Streak: ${monthly.bestStreak}');
/// }
/// ```
class StreakCalculator {
  /// Creates a [StreakCalculator] instance and computes the streak result.
  ///
  /// Throws [ArgumentError] in release mode if:
  /// - `dates` is empty.
  /// - `streakTarget` is out of valid range for weekly/monthly streaks.
  /// - `weekStartDay` is not between 1 and 7.
  StreakCalculator({
    required this.dates,
    required this.streakType,
    this.streakTarget = 1,
    this.weekStartDay = DateTime.monday,
  })  : assert(dates.isNotEmpty, 'Dates list cannot be empty'),
        assert(
          streakType != StreakType.weekly ||
              (streakTarget >= 1 && streakTarget <= 7),
          'Weekly streakTarget must be between 1 and 7',
        ),
        assert(
          streakType != StreakType.monthly ||
              (streakTarget >= 1 && streakTarget <= 28),
          'Monthly streakTarget must be between 1 and 28',
        ),
        assert(
          weekStartDay >= DateTime.monday && weekStartDay <= DateTime.sunday,
          'weekStartDay must be between 1 (Monday) and 7 (Sunday)',
        ),
        // Create result via helper that runs runtime validation first:
        _result = _createResult(dates, streakType, streakTarget, weekStartDay);

  /// The list of dates used to calculate the streak.
  final List<DateTime> dates;

  /// The type of streak to calculate.
  final StreakType streakType;

  /// The target number of days to achieve a streak.
  final int streakTarget;

  /// The first day of the week (only used in weekly streaks).
  final int weekStartDay;

  /// The computed streak result.
  final StreakResult _result;

  static const _dailyCalculator = DailyStreakCalculator();
  static const _weeklyCalculator = WeeklyStreakCalculator();
  static const _monthlyCalculator = MonthlyStreakCalculator();
  static const _dateNormalizer = DateNormalizer();

  /// Public runtime validator (callable from tests). Throws [ArgumentError]
  /// on invalid input (release-mode semantics).
  static void validateArguments(
    List<DateTime> dates,
    StreakType streakType,
    int? streakTarget,
    int weekStartDay,
  ) {
    if (dates.isEmpty) {
      throw ArgumentError('Dates list cannot be empty');
    }

    if (streakType == StreakType.weekly) {
      if (streakTarget == null || streakTarget < 1 || streakTarget > 7) {
        throw ArgumentError.value(
          streakTarget,
          'streakTarget',
          'Weekly streakTarget must be between 1 and 7',
        );
      }
    }

    if (streakType == StreakType.monthly) {
      if (streakTarget == null || streakTarget < 1 || streakTarget > 28) {
        throw ArgumentError.value(
          streakTarget,
          'streakTarget',
          'Monthly streakTarget must be between 1 and 28',
        );
      }
    }

    if (weekStartDay < DateTime.monday || weekStartDay > DateTime.sunday) {
      throw ArgumentError.value(
        weekStartDay,
        'weekStartDay',
        'Must be between 1 (Monday) and 7 (Sunday)',
      );
    }
  }

  // Internal helper used in initializer to ensure validation runs BEFORE _calculate.
  static StreakResult _createResult(
    List<DateTime> dates,
    StreakType streakType,
    int streakTarget,
    int weekStartDay,
  ) {
    // runtime validation (throws ArgumentError on invalid input)
    validateArguments(dates, streakType, streakTarget, weekStartDay);

    // delegate to calculation (private)
    return _calculate(dates, streakType, streakTarget, weekStartDay);
  }

  /// Internal calculation entry point(private).
  static StreakResult _calculate(
    List<DateTime> dates,
    StreakType streakType,
    int streakTarget,
    int weekStartDay,
  ) {
    // Normalize dates (remove time, duplicates, sort)
    final normalizedDates = _dateNormalizer.normalizeDates(dates);

    switch (streakType) {
      case StreakType.daily:
        return _dailyCalculator.calculateStreak(normalizedDates);

      case StreakType.weekly:
        return _weeklyCalculator.calculateStreak(
          normalizedDates,
          weekStartDay,
          streakTarget,
        );

      case StreakType.monthly:
        return _monthlyCalculator.calculateStreak(
          normalizedDates,
          streakTarget,
        );
    }
  }

  /// Returns the **current streak**.
  int get currentStreak => _result.currentStreak;

  /// Returns the **best streak**.
  int get bestStreak => _result.bestStreak;
}
