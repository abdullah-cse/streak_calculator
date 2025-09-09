/// Utility class for generating unique month identifiers.
///
/// This class handles the logic for converting dates to month keys
/// and navigating between months.
class MonthKeyGenerator {
  /// Creates a new month key generator instance.
  const MonthKeyGenerator();

  /// Generates a unique month key from a date.
  ///
  /// The month key is calculated as: year * 12 + month
  /// This creates a unique integer for each month that preserves chronological ordering.
  ///
  /// [date] The date to generate a month key for
  ///
  /// Returns an integer representing the month containing the given date
  int getMonthKey(DateTime date) => date.year * 12 + date.month;

  /// Gets the month key for the previous month.
  ///
  /// Handles year boundaries correctly (e.g., January -> December of previous year).
  ///
  /// [monthKey] The current month key
  ///
  /// Returns the month key for the month immediately before the given month
  int getPreviousMonth(int monthKey) {
    final year = monthKey ~/ 12;
    final month = monthKey % 12;

    if (month == 1) {
      return (year - 1) * 12 + 12;
    } else {
      return monthKey - 1;
    }
  }

  /// Gets the month key for the next month.
  ///
  /// Handles year boundaries correctly (e.g., December -> January of next year).
  ///
  /// [monthKey] The current month key
  ///
  /// Returns the month key for the month immediately after the given month
  int getNextMonth(int monthKey) {
    final year = monthKey ~/ 12;
    final month = monthKey % 12;

    if (month == 12) {
      return (year + 1) * 12 + 1;
    } else {
      return monthKey + 1;
    }
  }

  /// Converts a month key back to a DateTime representing the first day of the month.
  ///
  /// [monthKey] The month key to convert
  ///
  /// Returns a DateTime representing the first day of the specified month
  DateTime monthKeyToDate(int monthKey) {
    final year = monthKey ~/ 12;
    final month = monthKey % 12;
    return DateTime(year, month == 0 ? 12 : month, 1);
  }

  /// Gets the current month key.
  ///
  /// Returns the month key for the current month
  int getCurrentMonthKey() => getMonthKey(DateTime.now());
}
