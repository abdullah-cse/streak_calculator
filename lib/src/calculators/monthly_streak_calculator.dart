import '../enum/streak_type.dart';
import '../model/streak_result.dart';

/// A calculator that computes monthly streaks based on a target number of days per month.
///
/// A monthly streak counts consecutive months where there are at least [streakTarget] 
/// entries within that month. The streak breaks if any month fails to meet the target.
///
/// Uses `Set<DateTime>` for automatic deduplication and efficient iteration, making it
/// highly efficient for large datasets.
///
/// Example:
/// ```dart
/// final calculator = MonthlyStreakCalculator();
/// final dates = {
///   DateTime(2025, 1, 5), DateTime(2025, 1, 10), DateTime(2025, 1, 15), // 3 days in Jan
///   DateTime(2025, 2, 1), DateTime(2025, 2, 5), DateTime(2025, 2, 10), // 3 days in Feb
///   DateTime(2025, 3, 1), DateTime(2025, 3, 2), // 2 days in March
/// };
/// 
/// // With target of 3 days per month
/// final result = calculator.calculateStreak(dates, 3);
/// // Current streak: 2 (Jan and Feb qualify, March doesn't)
/// // Best streak: 2 (consecutive months Jan-Feb)
/// ```
class MonthlyStreakCalculator {
  /// Creates a new monthly streak calculator instance.
  const MonthlyStreakCalculator();

  /// Calculates the monthly streak for the given normalized dates and target.
  ///
  /// [normalizedDates] must be a Set of DateTime objects with normalized dates
  /// (time components should be set to midnight). Duplicates are automatically handled.
  /// 
  /// [streakTarget] specifies the minimum number of days required per month
  /// to maintain the streak. Must be between 1 and 28.
  ///
  /// Returns a [StreakResult] containing both current and best streak counts.
  ///
  /// Throws [ArgumentError] if [streakTarget] is not between 1 and 28.
  StreakResult calculateStreak(Set<DateTime> normalizedDates, int streakTarget) {
    if (streakTarget < 1 || streakTarget > 28) {
      throw ArgumentError.value(
        streakTarget,
        'streakTarget',
        'Monthly streak target must be between 1 and 28',
      );
    }

    if (normalizedDates.isEmpty) {
      return StreakResult(
        currentStreak: 0,
        bestStreak: 0,
        streakType: StreakType.monthly,
        streakTarget: streakTarget,
      );
    }

    // Group dates by month-year with fast Set operations
    final monthlyActiveDays = _groupDatesByMonth(normalizedDates);
    
    // Get sorted list of months for sequential processing
    final sortedMonths = monthlyActiveDays.keys.toList()..sort();
    
    // Calculate current and best streaks
    final currentStreak = _calculateCurrentStreak(
      monthlyActiveDays,
      sortedMonths,
      streakTarget,
    );
    
    final bestStreak = _calculateBestStreak(
      monthlyActiveDays,
      sortedMonths,
      streakTarget,
    );

    return StreakResult(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      streakType: StreakType.monthly,
      streakTarget: streakTarget,
    );
  }

  /// Groups dates by their month-year combination.
  ///
  /// Returns a map where keys are month identifiers (YYYYMM format) and
  /// values are the count of unique days with activity in that month.
  ///
  /// Time complexity: O(n) where n is the number of dates
  Map<int, int> _groupDatesByMonth(Set<DateTime> dates) {
    final monthlyActiveDays = <int, int>{};
    
    for (final date in dates) {
      final monthKey = date.year * 100 + date.month; // Inline month key calculation
      monthlyActiveDays.update(monthKey, (count) => count + 1, ifAbsent: () => 1);
    }
    
    return monthlyActiveDays;
  }

  /// Calculates the current streak including the most recent month.
  ///
  /// The current streak counts backwards from the current/most recent month,
  /// including only consecutive months that meet or exceed the streak target.
  /// Handles gaps between current time and latest data intelligently.
  ///
  /// Time complexity: O(s) where s is the length of the current streak
  int _calculateCurrentStreak(
    Map<int, int> monthlyActiveDays,
    List<int> sortedMonths,
    int streakTarget,
  ) {
    if (sortedMonths.isEmpty) return 0;

    // Get current month key for "including today" logic
    final now = DateTime.now();
    final currentMonthKey = now.year * 100 + now.month;
    
    // Determine starting point for current streak calculation
    int startingMonthKey = currentMonthKey;
    
    // If current month has no data, start from the most recent month with data
    if (!monthlyActiveDays.containsKey(currentMonthKey)) {
      startingMonthKey = sortedMonths.last;
      
      // Check if there's a gap between current month and latest data month
      // If gap > 1 month, current streak is broken
      if (_getMonthDifference(startingMonthKey, currentMonthKey) > 1) {
        return 0;
      }
    }
    
    // Count backwards from starting month while target is met
    int currentStreak = 0;
    int checkingMonthKey = startingMonthKey;
    
    while (monthlyActiveDays.containsKey(checkingMonthKey)) {
      final activeDays = monthlyActiveDays[checkingMonthKey]!;
      
      if (activeDays >= streakTarget) {
        currentStreak++;
        checkingMonthKey = _getPreviousMonth(checkingMonthKey);
      } else {
        break; // Target not met, streak ends
      }
    }
    
    return currentStreak;
  }

  /// Calculates the best (longest) streak in the entire dataset.
  ///
  /// Examines all possible consecutive month sequences to find the longest
  /// streak where each month meets or exceeds the target. Handles gaps by
  /// resetting the streak counter.
  ///
  /// Time complexity: O(r) where r is the range of months from first to last
  int _calculateBestStreak(
    Map<int, int> monthlyActiveDays,
    List<int> sortedMonths,
    int streakTarget,
  ) {
    if (sortedMonths.isEmpty) return 0;

    int bestStreak = 0;
    int currentBestStreak = 0;
    
    // Generate complete month range to properly handle gaps
    final allMonthsInRange = _generateCompleteMonthRange(
      sortedMonths.first, 
      sortedMonths.last
    );
    
    // Scan through all months in range
    for (final monthKey in allMonthsInRange) {
      final activeDays = monthlyActiveDays[monthKey] ?? 0;
      
      if (activeDays >= streakTarget) {
        currentBestStreak++;
        // Update best streak if current is better
        if (currentBestStreak > bestStreak) {
          bestStreak = currentBestStreak;
        }
      } else {
        // Reset current streak on gap or insufficient activity
        currentBestStreak = 0;
      }
    }
    
    return bestStreak;
  }

  /// Generates a complete range of months between start and end (inclusive).
  ///
  /// This ensures we can detect gaps in the data by including months with
  /// zero activity. Essential for proper streak break detection.
  ///
  /// Example: _generateCompleteMonthRange(202501, 202503) 
  /// returns [202501, 202502, 202503]
  ///
  /// Time complexity: O(r) where r is the number of months in range
  List<int> _generateCompleteMonthRange(int startMonth, int endMonth) {
    if (startMonth > endMonth) return [];
    
    final months = <int>[];
    int currentMonth = startMonth;
    
    while (currentMonth <= endMonth) {
      months.add(currentMonth);
      currentMonth = _getNextMonth(currentMonth);
    }
    
    return months;
  }

  /// Gets the next month key with proper year rollover.
  ///
  /// Handles December to January transitions correctly.
  /// Example: 202512 -> 202601
  int _getNextMonth(int monthKey) {
    final year = monthKey ~/ 100;
    final month = monthKey % 100;
    
    if (month == 12) {
      return (year + 1) * 100 + 1; // December -> January of next year
    } else {
      return monthKey + 1; // Simple increment
    }
  }

  /// Gets the previous month key with proper year rollover.
  ///
  /// Handles January to December transitions correctly.
  /// Example: 202501 -> 202412
  int _getPreviousMonth(int monthKey) {
    final year = monthKey ~/ 100;
    final month = monthKey % 100;
    
    if (month == 1) {
      return (year - 1) * 100 + 12; // January -> December of previous year
    } else {
      return monthKey - 1; // Simple decrement
    }
  }

  /// Calculates the difference in months between two month keys.
  ///
  /// Returns the absolute difference in months, useful for detecting
  /// gaps in the data that would break a current streak.
  ///
  /// Example: _getMonthDifference(202501, 202503) returns 2
  /// Example: _getMonthDifference(202412, 202501) returns 1
  int _getMonthDifference(int month1, int month2) {
    final year1 = month1 ~/ 100;
    final mon1 = month1 % 100;
    final year2 = month2 ~/ 100;
    final mon2 = month2 % 100;
    
    // Calculate total months for each date and find difference
    final totalMonths1 = year1 * 12 + mon1;
    final totalMonths2 = year2 * 12 + mon2;
    
    return (totalMonths2 - totalMonths1).abs();
  }
}