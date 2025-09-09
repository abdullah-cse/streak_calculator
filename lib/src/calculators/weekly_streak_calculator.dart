import '../enum/streak_type.dart';
import '../enum/week_start_day.dart';
import '../model/streak_result.dart';
import '../utilities/date_normalizer.dart';
import '../utilities/week_key_generator.dart';

/// Calculator specialized for weekly streak calculations.
///
/// This calculator handles week-based streak logic where weeks that meet
/// the minimum activity target count towards the streak.
class WeeklyStreakCalculator {
  /// Creates a new weekly streak calculator instance.
  const WeeklyStreakCalculator({
    DateNormalizer? dateNormalizer,
    WeekKeyGenerator? weekKeyGenerator,
  })  : _dateNormalizer = dateNormalizer ?? const DateNormalizer(),
        _weekKeyGenerator = weekKeyGenerator ?? const WeekKeyGenerator();
  final DateNormalizer _dateNormalizer;
  final WeekKeyGenerator _weekKeyGenerator;

  /// Calculates weekly streak where weeks meeting the streak target count.
  ///
  /// [dates] A set of normalized dates (without time components)
  /// [weekStartDay] The day that starts each week
  /// [streakTarget] Minimum number of days required per week (nullable)
  ///
  /// Returns a [StreakResult] with current and best weekly streak counts.
  StreakResult calculateStreak(
    Set<DateTime> dates,
    WeekStartDay weekStartDay,
    int? streakTarget,
  ) {
    final normalizedToday = _dateNormalizer.getTodayNormalized();

    // Group dates by week
    final weeklyData = _groupDatesByWeek(dates, weekStartDay);

    // Calculate current streak
    final currentWeek =
        _weekKeyGenerator.getWeekKey(normalizedToday, weekStartDay);
    final currentStreak = _calculateCurrentWeeklyStreak(
      weeklyData,
      currentWeek,
      streakTarget,
    );

    // Calculate best streak
    final bestStreak = _findBestWeeklyStreak(weeklyData, streakTarget);

    return StreakResult(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      streakType: StreakType.weekly,
      streakTarget: streakTarget,
    );
  }

  /// Groups dates by week based on the week start day.
  ///
  /// [dates] Set of normalized activity dates
  /// [weekStartDay] The day that starts each week
  ///
  /// Returns a map where keys are week identifiers and values are sets of dates in that week
  Map<int, Set<DateTime>> _groupDatesByWeek(
    Set<DateTime> dates,
    WeekStartDay weekStartDay,
  ) {
    final weeklyData = <int, Set<DateTime>>{};

    for (final date in dates) {
      final weekKey = _weekKeyGenerator.getWeekKey(date, weekStartDay);
      weeklyData.putIfAbsent(weekKey, () => <DateTime>{}).add(date);
    }

    return weeklyData;
  }

  /// Calculates the current weekly streak.
  ///
  /// [weeklyData] Map of week keys to sets of dates
  /// [currentWeek] The current week identifier
  /// [streakTarget] Minimum days required per week
  ///
  /// Returns the current weekly streak count
  int _calculateCurrentWeeklyStreak(
    Map<int, Set<DateTime>> weeklyData,
    int currentWeek,
    int? streakTarget,
  ) {
    int currentStreak = 0;
    int checkWeek = currentWeek;

    // Count consecutive weeks that meet the target
    while (weeklyData.containsKey(checkWeek) &&
        _meetsWeeklyTarget(weeklyData[checkWeek]!, streakTarget)) {
      currentStreak++;
      checkWeek--;
    }

    // If no activity this week or doesn't meet target, check last week
    if (currentStreak == 0 &&
        weeklyData.containsKey(currentWeek - 1) &&
        _meetsWeeklyTarget(weeklyData[currentWeek - 1]!, streakTarget)) {
      currentStreak = 1;
      checkWeek = currentWeek - 2;

      while (weeklyData.containsKey(checkWeek) &&
          _meetsWeeklyTarget(weeklyData[checkWeek]!, streakTarget)) {
        currentStreak++;
        checkWeek--;
      }
    }

    return currentStreak;
  }

  /// Checks if a week meets the streak target requirement.
  ///
  /// [weekDates] Set of dates in the week
  /// [streakTarget] Minimum days required (null means any activity counts)
  ///
  /// Returns true if the week meets the target
  bool _meetsWeeklyTarget(Set<DateTime> weekDates, int? streakTarget) {
    if (streakTarget == null) return weekDates.isNotEmpty;
    return weekDates.length >= streakTarget;
  }

  /// Finds the longest weekly streak in the dataset that meets the target.
  ///
  /// [weeklyData] Map of week keys to sets of dates
  /// [streakTarget] Minimum days required per week
  ///
  /// Returns the length of the best weekly streak
  int _findBestWeeklyStreak(
    Map<int, Set<DateTime>> weeklyData,
    int? streakTarget,
  ) {
    if (weeklyData.isEmpty) return 0;

    final sortedWeeks = weeklyData.keys.toList()..sort();
    int bestStreak = 0;
    int currentStreak = 0;

    for (int i = 0; i < sortedWeeks.length; i++) {
      final weekKey = sortedWeeks[i];
      final weekDates = weeklyData[weekKey]!;

      // Check if this week meets the target
      if (_meetsWeeklyTarget(weekDates, streakTarget)) {
        // Check if this week is consecutive to the previous qualifying week
        if (currentStreak == 0 ||
            (i > 0 && sortedWeeks[i] == sortedWeeks[i - 1] + 1)) {
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
