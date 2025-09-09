import '../enum/week_start_day.dart';

/// Utility class for generating unique week identifiers.
///
/// This class handles the logic for converting dates to week keys
/// based on configurable week start days.
class WeekKeyGenerator {
  /// Creates a new week key generator instance.
  const WeekKeyGenerator();

  /// Generates a unique week key based on the date and week start day.
  ///
  /// The week key is calculated by:
  /// 1. Finding days since Unix epoch (Jan 1, 1970)
  /// 2. Adjusting for the specified week start day
  /// 3. Dividing by 7 to get the week number
  ///
  /// [date] The date to generate a week key for
  /// [weekStartDay] The day that starts each week
  ///
  /// Returns an integer representing the week containing the given date
  int getWeekKey(DateTime date, WeekStartDay weekStartDay) {
    // Calculate days since epoch
    final daysSinceEpoch = date.difference(DateTime(1970, 1, 1)).inDays;

    // Adjust for week start day
    final adjustedDays = daysSinceEpoch - (weekStartDay.value - 1);

    // Return week number
    return adjustedDays ~/ 7;
  }

  /// Gets the week key for the previous week.
  ///
  /// [weekKey] The current week key
  ///
  /// Returns the week key for the week immediately before the given week
  int getPreviousWeek(int weekKey) => weekKey - 1;

  /// Gets the week key for the next week.
  ///
  /// [weekKey] The current week key
  ///
  /// Returns the week key for the week immediately after the given week
  int getNextWeek(int weekKey) => weekKey + 1;

  /// Converts a week key back to the date of the week's start.
  ///
  /// [weekKey] The week key to convert
  /// [weekStartDay] The day that starts each week
  ///
  /// Returns the date representing the start of the specified week
  DateTime weekKeyToStartDate(int weekKey, WeekStartDay weekStartDay) {
    final adjustedDays = weekKey * 7 + (weekStartDay.value - 1);
    return DateTime(1970, 1, 1).add(Duration(days: adjustedDays));
  }
}
