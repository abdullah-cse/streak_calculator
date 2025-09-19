import 'dart:math' as math;
import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:streak_calculator/src/model/streak_result.dart';

/// Calculates weekly streaks based on activity dates.
///
/// Streaks are measured by counting active days within consecutive qualifying weeks.
/// A week qualifies if it has at least the target number of active days.
class WeeklyStreakCalculator {
  /// Creates a new weekly streak calculator instance.
  const WeeklyStreakCalculator();

  /// Calculates streak statistics for the given activity dates.
  ///
  /// Returns current streak (days in consecutive qualifying weeks ending at reference date)
  /// and best streak (highest total days in any consecutive qualifying sequence).
  ///
  /// If [referenceDate] is null, uses DateTime.now().
  StreakResult calculateStreak(
    Set<DateTime> normalizedDates,
    int weekStartDay,
    int streakTarget, {
    DateTime? referenceDate,
  }) {
    if (weekStartDay < 1 || weekStartDay > 7) {
      throw ArgumentError(
        'Week start day must be between 1 (Monday) and 7 (Sunday)',
      );
    }

    if (streakTarget < 1 || streakTarget > 7) {
      throw ArgumentError('Weekly target must be between 1 and 7 days');
    }

    if (normalizedDates.isEmpty) {
      return StreakResult(
        currentStreak: 0,
        bestStreak: 0,
        streakType: StreakType.weekly,
        streakTarget: streakTarget,
      );
    }

    final reference = referenceDate ?? DateTime.now();
    final weekGroups = _groupDatesByWeek(normalizedDates, weekStartDay);
    final qualifyingWeeks = _getQualifyingWeeks(weekGroups, streakTarget);

    if (qualifyingWeeks.isEmpty) {
      return StreakResult(
        currentStreak: 0,
        bestStreak: 0,
        streakType: StreakType.weekly,
        streakTarget: streakTarget,
      );
    }

    final currentStreak = _calculateCurrentStreak(
      qualifyingWeeks,
      weekGroups,
      weekStartDay,
      reference,
    );
    final bestStreak = _calculateBestStreak(qualifyingWeeks, weekGroups);

    return StreakResult(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      streakType: StreakType.weekly,
      streakTarget: streakTarget,
    );
  }

  /// Groups dates by their week identifier and counts active days per week.
  Map<int, int> _groupDatesByWeek(Set<DateTime> dates, int weekStartDay) {
    final weekGroups = <int, int>{};

    for (final date in dates) {
      final weekKey = _getWeekKey(date, weekStartDay);
      weekGroups[weekKey] = (weekGroups[weekKey] ?? 0) + 1;
    }

    return weekGroups;
  }

  /// Generates a unique week identifier based on weeks since epoch.
  int _getWeekKey(DateTime date, int weekStartDay) {
    final daysSinceEpoch = date.difference(DateTime(1970, 1, 1)).inDays;
    final epochWeekday = DateTime(1970, 1, 1).weekday;
    final adjustment = (epochWeekday - weekStartDay + 7) % 7;
    final adjustedDays = daysSinceEpoch + adjustment;
    return adjustedDays ~/ 7;
  }

  /// Returns sorted list of weeks that meet the activity target.
  List<int> _getQualifyingWeeks(Map<int, int> weekGroups, int target) {
    final qualifying = weekGroups.entries
        .where((entry) => entry.value >= target)
        .map((entry) => entry.key)
        .toList()
      ..sort();
    return qualifying;
  }

  /// Calculates current streak as total active days in consecutive qualifying weeks ending at reference date.
  /// Returns 0 if the week containing the reference date doesn't qualify.
  int _calculateCurrentStreak(
    List<int> qualifyingWeeks,
    Map<int, int> weekGroups,
    int weekStartDay,
    DateTime referenceDate,
  ) {
    final currentWeekKey = _getWeekKey(referenceDate, weekStartDay);
    final qualifyingSet = qualifyingWeeks.toSet();

    if (!qualifyingSet.contains(currentWeekKey)) {
      return 0;
    }

    int totalActiveDays = 0;
    int checkWeek = currentWeekKey;

    while (qualifyingSet.contains(checkWeek)) {
      totalActiveDays += weekGroups[checkWeek]!;
      checkWeek--;
    }

    return totalActiveDays;
  }

  /// Finds the longest sequence of consecutive qualifying weeks and returns total active days.
  int _calculateBestStreak(
      List<int> qualifyingWeeks, Map<int, int> weekGroups) {
    if (qualifyingWeeks.isEmpty) return 0;
    if (qualifyingWeeks.length == 1) {
      return weekGroups[qualifyingWeeks.first]!;
    }

    int bestStreakDays = 0;
    int currentSequenceStart = 0;

    for (int i = 1; i <= qualifyingWeeks.length; i++) {
      final bool sequenceBreaks = (i == qualifyingWeeks.length) ||
          (qualifyingWeeks[i] != qualifyingWeeks[i - 1] + 1);

      if (sequenceBreaks) {
        int sequenceDays = 0;
        for (int j = currentSequenceStart; j < i; j++) {
          sequenceDays += weekGroups[qualifyingWeeks[j]]!;
        }
        bestStreakDays = math.max(bestStreakDays, sequenceDays);
        currentSequenceStart = i;
      }
    }

    return bestStreakDays;
  }
}
