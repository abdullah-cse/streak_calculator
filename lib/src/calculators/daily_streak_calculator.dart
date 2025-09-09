import '../enum/streak_type.dart';
import '../model/streak_result.dart';
import '../utilities/date_normalizer.dart';

/// Calculator specialized for daily streak calculations.
///
/// This calculator handles consecutive day streak logic where each
/// consecutive day with activity counts towards the streak.
class DailyStreakCalculator {
  /// Creates a new daily streak calculator instance.
  const DailyStreakCalculator({
    DateNormalizer? dateNormalizer,
  }) : _dateNormalizer = dateNormalizer ?? const DateNormalizer();
  final DateNormalizer _dateNormalizer;

  /// Calculates daily streak where each consecutive day counts.
  ///
  /// [dates] A set of normalized dates (without time components)
  ///
  /// Returns a [StreakResult] with current and best daily streak counts.
  /// Current streak includes today if there's activity today, or yesterday
  /// if there's no activity today but there was activity yesterday.
  StreakResult calculateStreak(Set<DateTime> dates) {
    final normalizedToday = _dateNormalizer.getTodayNormalized();

    // Calculate current streak starting from today
    final currentStreak = _calculateCurrentDailyStreak(dates, normalizedToday);

    // Calculate best streak
    final bestStreak = _findBestDailyStreak(dates);

    return StreakResult(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      streakType: StreakType.daily,
      streakTarget: null, // Not used for daily streaks
    );
  }

  /// Calculates the current daily streak starting from today.
  ///
  /// [dates] Set of normalized activity dates
  /// [today] Today's normalized date
  ///
  /// Returns the length of the current streak
  int _calculateCurrentDailyStreak(Set<DateTime> dates, DateTime today) {
    int currentStreak = 0;
    DateTime checkDate = today;

    // Count consecutive days starting from today
    while (dates.contains(checkDate)) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // If no activity today, check if there was activity yesterday
    if (currentStreak == 0) {
      final yesterday = today.subtract(const Duration(days: 1));
      if (dates.contains(yesterday)) {
        currentStreak = 1;
        checkDate = yesterday.subtract(const Duration(days: 1));

        while (dates.contains(checkDate)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        }
      }
    }

    return currentStreak;
  }

  /// Finds the longest daily streak in the dataset.
  ///
  /// [dates] Set of normalized activity dates
  ///
  /// Returns the length of the best (longest) streak found
  int _findBestDailyStreak(Set<DateTime> dates) {
    if (dates.isEmpty) return 0;

    final sortedDates = dates.toList()..sort();
    int bestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final previousDate = sortedDates[i - 1];
      final currentDate = sortedDates[i];

      // Check if current date is consecutive to previous date
      if (currentDate.difference(previousDate).inDays == 1) {
        currentStreak++;
      } else {
        bestStreak = bestStreak > currentStreak ? bestStreak : currentStreak;
        currentStreak = 1;
      }
    }

    return bestStreak > currentStreak ? bestStreak : currentStreak;
  }
}
