import 'package:streak_calculator/src/model/streak_result.dart';
import 'calculators/daily_streak_calculator.dart';
import 'calculators/monthly_streak_calculator.dart';
import 'calculators/weekly_streak_calculator.dart';
import 'enum/streak_type.dart';
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
/// // Weekly streak requiring 3 days per week, starting on Monday
/// final weeklyResult = calculator.calculateStreak(
///   dates: dates,
///   streakType: StreakType.weekly,
///   weekStartDay: DateTime.monday,
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
  ///
  /// Dependency injection is supported for testing and customization:
  /// - [dailyCalculator] handles daily streak calculations
  /// - [weeklyCalculator] handles weekly streak calculations
  /// - [monthlyCalculator] handles monthly streak calculations
  /// - [dateNormalizer] normalizes and deduplicates dates
  /// - [streakValidator] validates streak parameters
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

  /// Calculator for daily streak operations.
  final DailyStreakCalculator _dailyCalculator;

  /// Calculator for weekly streak operations.
  final WeeklyStreakCalculator _weeklyCalculator;

  /// Calculator for monthly streak operations.
  final MonthlyStreakCalculator _monthlyCalculator;

  /// Utility for normalizing and deduplicating dates.
  final DateNormalizer _dateNormalizer;

  /// Utility for validating streak parameters.
  final StreakValidator _streakValidator;

  /// Calculates streak information from the provided date dataset.
  ///
  /// [dates] is required and contains the activity dates to analyze.
  /// Can be unsorted and contain duplicates - they will be processed automatically.
  ///
  /// [streakType] determines the type of streak calculation:
  /// - [StreakType.daily]: Consecutive days with activity
  /// - [StreakType.weekly]: Consecutive weeks meeting the target
  /// - [StreakType.monthly]: Consecutive months meeting the target
  ///
  /// [weekStartDay] specifies which day starts the week (1=Monday, 7=Sunday).
  /// Defaults to Monday (1). Only used for weekly streak calculations.
  ///
  /// [streakTarget] specifies the minimum days required for weekly/monthly streaks:
  /// - For daily streaks: ignored (parameter not used)
  /// - For weekly streaks: must be 1-7 days per week
  /// - For monthly streaks: must be 1-28 days per month
  /// Required for weekly and monthly calculations.
  ///
  /// Returns a [StreakResult] containing:
  /// - Current streak: includes today and counts backwards
  /// - Best streak: longest streak found in the entire dataset
  /// - Streak type and target information
  ///
  /// The method efficiently handles large datasets by:
  /// - Normalizing dates to remove time components (O(n))
  /// - Removing duplicates using Set operations (O(n))
  /// - Using optimized algorithms for each streak type
  /// - Minimizing memory allocations during processing
  ///
  /// Throws [ArgumentError] if:
  /// - The dates list is empty
  /// - streakTarget is invalid for the given streak type
  /// - weekStartDay is not between 1 and 7
  StreakResult calculateStreak({
    required List<DateTime> dates,
    required StreakType streakType,
    int weekStartDay = DateTime.monday,
    int? streakTarget,
  }) {
    // Validate input parameters
    if (dates.isEmpty) {
      throw ArgumentError('Dates list cannot be empty');
    }

    if (weekStartDay < 1 || weekStartDay > 7) {
      throw ArgumentError(
        'Week start day must be between 1 (Monday) and 7 (Sunday), got: $weekStartDay',
      );
    }

    // Validate streak target based on streak type
    _streakValidator.validateStreakTarget(streakType, streakTarget);

    // Normalize dates to remove time component and eliminate duplicates
    // This creates a sorted list of unique dates for efficient processing
    final normalizedDates = _dateNormalizer.normalizeDates(dates);

    // Delegate to appropriate specialized calculator
    switch (streakType) {
      case StreakType.daily:
        return _dailyCalculator.calculateStreak(normalizedDates);

      case StreakType.weekly:
        // Weekly calculations require both weekStartDay and streakTarget
        return _weeklyCalculator.calculateStreak(
          normalizedDates,
          weekStartDay,
          streakTarget!,
        );

      case StreakType.monthly:
        // Monthly calculations require streakTarget
        return _monthlyCalculator.calculateStreak(
          normalizedDates,
          streakTarget,
        );
    }
  }
}
