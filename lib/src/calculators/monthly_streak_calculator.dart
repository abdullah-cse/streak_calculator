import '../enum/streak_type.dart';
import '../model/streak_result.dart';
import '../utilities/month_key_generator.dart';

/// Calculator specialized for monthly streak calculations.
///
/// This calculator handles month-based streak logic where months that meet
/// the minimum activity target count towards the streak.
class MonthlyStreakCalculator {
  /// Creates a new monthly streak calculator instance.
  const MonthlyStreakCalculator({
    MonthKeyGenerator? monthKeyGenerator,
  }) : _monthKeyGenerator = monthKeyGenerator ?? const MonthKeyGenerator();
  final MonthKeyGenerator _monthKeyGenerator;

  /// Calculates monthly streak where months meeting the streak target count.
  ///
  /// [dates] A set of normalized dates (without time components)
  /// [streakTarget] Minimum number of days required per month (nullable)
  ///
  /// Returns a [StreakResult] with current and best monthly streak counts.
  StreakResult calculateStreak(Set<DateTime> dates, int? streakTarget) {
    final today = DateTime.now();

    // Group dates by month
    final monthlyData = _groupDatesByMonth(dates);

    // Calculate current streak
    final currentMonth = _monthKeyGenerator.getMonthKey(today);
    final currentStreak = _calculateCurrentMonthlyStreak(
      monthlyData,
      currentMonth,
      streakTarget,
    );

    // Calculate best streak
    final bestStreak = _findBestMonthlyStreak(monthlyData, streakTarget);

    return StreakResult(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      streakType: StreakType.monthly,
      streakTarget: streakTarget,
    );
  }

  /// Groups dates by month.
  ///
  /// [dates] Set of normalized activity dates
  ///
  /// Returns a map where keys are month identifiers and values are sets of dates in that month
  Map<int, Set<DateTime>> _groupDatesByMonth(Set<DateTime> dates) {
    final monthlyData = <int, Set<DateTime>>{};

    for (final date in dates) {
      final monthKey = _monthKeyGenerator.getMonthKey(date);
      monthlyData.putIfAbsent(monthKey, () => <DateTime>{}).add(date);
    }

    return monthlyData;
  }

  /// Calculates the current monthly streak.
  ///
  /// [monthlyData] Map of month keys to sets of dates
  /// [currentMonth] The current month identifier
  /// [streakTarget] Minimum days required per month
  ///
  /// Returns the current monthly streak count
  int _calculateCurrentMonthlyStreak(
    Map<int, Set<DateTime>> monthlyData,
    int currentMonth,
    int? streakTarget,
  ) {
    int currentStreak = 0;
    int checkMonth = currentMonth;

    // Count consecutive months that meet the target
    while (monthlyData.containsKey(checkMonth) &&
        _meetsMonthlyTarget(monthlyData[checkMonth]!, streakTarget)) {
      currentStreak++;
      checkMonth = _monthKeyGenerator.getPreviousMonth(checkMonth);
    }

    // If no activity this month or doesn't meet target, check last month
    if (currentStreak == 0) {
      final lastMonth = _monthKeyGenerator.getPreviousMonth(currentMonth);
      if (monthlyData.containsKey(lastMonth) &&
          _meetsMonthlyTarget(monthlyData[lastMonth]!, streakTarget)) {
        currentStreak = 1;
        checkMonth = _monthKeyGenerator.getPreviousMonth(lastMonth);

        while (monthlyData.containsKey(checkMonth) &&
            _meetsMonthlyTarget(monthlyData[checkMonth]!, streakTarget)) {
          currentStreak++;
          checkMonth = _monthKeyGenerator.getPreviousMonth(checkMonth);
        }
      }
    }

    return currentStreak;
  }

  /// Checks if a month meets the streak target requirement.
  ///
  /// [monthDates] Set of dates in the month
  /// [streakTarget] Minimum days required (null means any activity counts)
  ///
  /// Returns true if the month meets the target
  bool _meetsMonthlyTarget(Set<DateTime> monthDates, int? streakTarget) {
    if (streakTarget == null) return monthDates.isNotEmpty;
    return monthDates.length >= streakTarget;
  }

  /// Finds the longest monthly streak in the dataset that meets the target.
  ///
  /// [monthlyData] Map of month keys to sets of dates
  /// [streakTarget] Minimum days required per month
  ///
  /// Returns the length of the best monthly streak
  int _findBestMonthlyStreak(
    Map<int, Set<DateTime>> monthlyData,
    int? streakTarget,
  ) {
    if (monthlyData.isEmpty) return 0;

    final sortedMonths = monthlyData.keys.toList()..sort();
    int bestStreak = 0;
    int currentStreak = 0;

    for (int i = 0; i < sortedMonths.length; i++) {
      final monthKey = sortedMonths[i];
      final monthDates = monthlyData[monthKey]!;

      // Check if this month meets the target
      if (_meetsMonthlyTarget(monthDates, streakTarget)) {
        // Check if this month is consecutive to the previous qualifying month
        if (currentStreak == 0 ||
            (i > 0 &&
                sortedMonths[i] ==
                    _monthKeyGenerator.getNextMonth(sortedMonths[i - 1]))) {
          currentStreak++;
        } else {
          // Reset streak if not consecutive
          currentStreak = 1;
        }
        bestStreak = bestStreak > currentStreak ? bestStreak : currentStreak;
      } else {
        // Reset streak if target not met
        currentStreak = 0;
      }
    }

    return bestStreak;
  }
}
