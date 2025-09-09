// ignore_for_file: require_trailing_commas

import '../enum/streak_type.dart';

/// Utility class for validating streak calculation parameters.
///
/// This class ensures that streak targets are valid for their respective
/// streak types and throws appropriate errors for invalid configurations.
class StreakValidator {
  /// Creates a new streak validator instance.
  const StreakValidator();

  /// Validates the streak target parameter based on streak type.
  ///
  /// [streakType] The type of streak being calculated
  /// [streakTarget] The target value to validate (can be null)
  ///
  /// Throws [ArgumentError] if the streak target is invalid for the given type:
  /// - Daily streaks: streak target is ignored (no validation needed)
  /// - Weekly streaks: must be between 1 and 7
  /// - Monthly streaks: must be between 1 and 28
  void validateStreakTarget(StreakType streakType, int? streakTarget) {
    if (streakTarget == null) return;

    switch (streakType) {
      case StreakType.daily:
        // Streak target is ignored for daily streaks
        break;
      case StreakType.weekly:
        if (streakTarget < 1 || streakTarget > 7) {
          throw ArgumentError(
            'Weekly streak target must be between 1 and 7, got: $streakTarget',
          );
        }
        break;
      case StreakType.monthly:
        if (streakTarget < 1 || streakTarget > 28) {
          throw ArgumentError(
            'Monthly streak target must be between 1 and 28, got: $streakTarget',
          );
        }
        break;
    }
  }

  /// Validates that a dates collection is not empty.
  ///
  /// [dates] The collection of dates to validate
  /// [parameterName] The name of the parameter being validated (for error messages)
  ///
  /// Throws [ArgumentError] if the dates collection is empty
  void validateDatesNotEmpty(Iterable<DateTime> dates,
      [String parameterName = 'dates']) {
    if (dates.isEmpty) {
      throw ArgumentError('$parameterName cannot be empty');
    }
  }
}
