import 'package:streak_calculator/src/model/streak_result.dart';
import 'calculators/daily_streak_calculator.dart';
import 'calculators/monthly_streak_calculator.dart';
import 'calculators/weekly_streak_calculator.dart';
import 'enum/streak_type.dart';
import 'utilities/date_normalizer.dart';
import 'utilities/streak_validator.dart';

/// A high-performance streak calculator that handles large datasets efficiently.
///
/// Example usage:
/// ```dart
/// final daily = StreakCalculator(
///   streakType: StreakType.daily,
///   dates: [
///     DateTime(2025, 8, 27),
///     DateTime(2025, 8, 28),
///     DateTime(2025, 8, 29),
///   ],
/// );
///
/// print(daily.currentStreak); // e.g. 3
/// print(daily.bestStreak);    // e.g. 3
///
/// final weekly = StreakCalculator(
///   streakType: StreakType.weekly,
///   dates: [
///     DateTime(2025, 8, 27),
///     DateTime(2025, 8, 29),
///     DateTime(2025, 8, 30),
///   ],
///   streakTarget: 2,
///   weekStartDay: DateTime.sunday,
/// );
///
/// print(weekly.currentStreak);
/// print(weekly.bestStreak);
/// ```
class StreakCalculator {
  /// Creates a streak calculator.
  ///
  /// [dates] may be unsorted and contain duplicates (they will be cleaned automatically).
  /// [streakType] determines which streak calculation will be used.
  /// [streakTarget] is required for weekly/monthly streaks, ignored for daily.
  /// [weekStartDay] is required for weekly streaks (default Monday).
  StreakCalculator({
    required List<DateTime> dates,
    required StreakType streakType,
    int? streakTarget,
    int weekStartDay = DateTime.monday,
  })  : _dates = dates,
        _streakType = streakType,
        _streakTarget = streakTarget,
        _weekStartDay = weekStartDay {
    _result = _calculate();
  }

  final List<DateTime> _dates;
  final StreakType _streakType;
  final int? _streakTarget;
  final int _weekStartDay;

  late final StreakResult _result;

  // Internal calculators (hidden from API)
  static const _dailyCalculator = DailyStreakCalculator();
  static const _weeklyCalculator = WeeklyStreakCalculator();
  static const _monthlyCalculator = MonthlyStreakCalculator();
  static const _dateNormalizer = DateNormalizer();
  static const _streakValidator = StreakValidator();

  /// The computed streak result.
  StreakResult get result => _result;

  /// Shortcut for `result.currentStreak`.
  int get currentStreak => _result.currentStreak;

  /// Shortcut for `result.bestStreak`.
  int get bestStreak => _result.bestStreak;

  StreakResult _calculate() {
    if (_dates.isEmpty) {
      throw ArgumentError('Dates list cannot be empty');
    }

    if (_weekStartDay < 1 || _weekStartDay > 7) {
      throw ArgumentError(
        'Week start day must be between 1 (Monday) and 7 (Sunday), got: $_weekStartDay',
      );
    }

    // Validate streak target
    _streakValidator.validateStreakTarget(_streakType, _streakTarget);

    // Normalize dates (remove time, duplicates, sort)
    final normalizedDates = _dateNormalizer.normalizeDates(_dates);

    // Delegate to specific calculator
    switch (_streakType) {
      case StreakType.daily:
        return _dailyCalculator.calculateStreak(normalizedDates);

      case StreakType.weekly:
        return _weeklyCalculator.calculateStreak(
          normalizedDates,
          _weekStartDay,
          _streakTarget!,
        );

      case StreakType.monthly:
        return _monthlyCalculator.calculateStreak(
          normalizedDates,
          _streakTarget,
        );
    }
  }
}
