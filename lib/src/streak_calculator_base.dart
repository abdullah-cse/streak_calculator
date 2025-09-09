import 'calculators/daily_streak_calculator.dart';
import 'calculators/monthly_streak_calculator.dart';
import 'calculators/weekly_streak_calculator.dart';
import 'enum/streak_type.dart';
import 'enum/week_start_day.dart';
import 'model/streak_result.dart';
import 'utilities/date_normalizer.dart';
import 'utilities/streak_validator.dart';

/// A high-performance streak calculator that handles large datasets efficiently.
///
/// This calculator supports daily, weekly, and monthly streak calculations
/// with configurable parameters including streak targets and week start days.
/// It processes date datasets (can be unsorted/duplicated) to find both current and best streaks.
///
/// The calculator automatically:
/// - Removes duplicate dates
/// - Normalizes dates to ignore time components
/// - Sorts dates for optimal processing
/// - Validates streak target parameters
///
/// Example usage:
/// ```dart
/// final calculator = StreakCalculator();
/// final dates = [
///   DateTime(2024, 1, 1, 10, 30), // Time ignored
///   DateTime(2024, 1, 2, 15, 45),
///   DateTime(2024, 1, 3, 9, 15),
///   DateTime(2024, 1, 3, 14, 20), // Duplicate date (same day) removed
/// ];
///
/// // Daily streak (streak target ignored)
/// final dailyResult = calculator.calculateStreak(
///   dates: dates,
///   streakType: StreakType.daily,
/// );
///
/// // Weekly streak requiring 3 days per week
/// final weeklyResult = calculator.calculateStreak(
///   dates: dates,
///   streakType: StreakType.weekly,
///   streakTarget: 3, // Must have 3+ days per week
/// );
///
/// // Monthly streak requiring 10 days per month
/// final monthlyResult = calculator.calculateStreak(
///   dates: dates,
///   streakType: StreakType.monthly,
///   streakTarget: 10, // Must have 10+ days per month
/// );
///
/// print('Current streak: ${dailyResult.currentStreak}');
/// print('Best streak: ${dailyResult.bestStreak}');
/// ```
class StreakCalculator {
  /// Creates a new streak calculator instance.
  const StreakCalculator({
    DailyStreakCalculator? dailyCalculator,
    WeeklyStreakCalculator? weeklyCalculator,
    MonthlyStreakCalculator? monthlyCalculator,
    DateNormalizer? dateNormalizer,
    StreakValidator? streakValidator,
  })  : _dailyCalculator = dailyCalculator ?? const DailyStreakCalculator(),
        _weeklyCalculator = weeklyCalculator ?? const WeeklyStreakCalculator(),
        _monthlyCalculator =
            monthlyCalculator ?? const MonthlyStreakCalculator(),
        _dateNormalizer = dateNormalizer ?? const DateNormalizer(),
        _streakValidator = streakValidator ?? const StreakValidator();
  final DailyStreakCalculator _dailyCalculator;
  final WeeklyStreakCalculator _weeklyCalculator;
  final MonthlyStreakCalculator _monthlyCalculator;
  final DateNormalizer _dateNormalizer;
  final StreakValidator _streakValidator;

  /// Calculates streak information from the provided date dataset.
  ///
  /// [dates] is required and contains the activity dates to analyze.
  /// [streakType] determines the type of streak calculation (daily, weekly, monthly).
  /// [weekStartDay] specifies which day starts the week (defaults to Monday).
  /// [streakTarget] specifies the minimum days required for weekly/monthly streaks.
  ///   - For daily streaks: ignored
  ///   - For weekly streaks: must be 1-7 days per week
  ///   - For monthly streaks: must be 1-28 days per month
  ///
  /// Returns a [StreakResult] containing current and best streak counts.
  ///
  /// The method efficiently handles large datasets by:
  /// - Normalizing dates to remove time components
  /// - Using sets for O(1) date lookups
  /// - Minimizing iterations over the dataset
  ///
  /// Throws [ArgumentError] if the dates list is empty or streakTarget is invalid.
  StreakResult calculateStreak({
    required List<DateTime> dates,
    required StreakType streakType,
    WeekStartDay weekStartDay = WeekStartDay.monday,
    int? streakTarget,
  }) {
    if (dates.isEmpty) {
      throw ArgumentError('Dates list cannot be empty');
    }

    // Validate streak target based on streak type
    _streakValidator.validateStreakTarget(streakType, streakTarget);

    // Normalize dates to remove time component and convert to set for O(1) lookup
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
}
