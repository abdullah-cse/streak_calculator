/// Utility class for normalizing dates by removing time components.
///
/// This class is responsible for converting datetime objects to date-only
/// representations and removing duplicates for efficient processing.
class DateNormalizer {
  /// Creates a new date normalizer instance.
  const DateNormalizer();

  /// Normalizes dates by removing time components and converting to a sorted set.
  ///
  /// This method:
  /// - Removes time components from all dates
  /// - Eliminates duplicate dates (same day)
  /// - Returns a set for O(1) lookup performance
  ///
  /// [dates] The list of datetime objects to normalize
  /// Returns a set of normalized dates with only year, month, and day components
  Set<DateTime> normalizeDates(List<DateTime> dates) =>
      dates.map((date) => DateTime(date.year, date.month, date.day)).toSet();

  /// Gets today's date normalized (without time component).
  ///
  /// Returns today's date with only year, month, and day components
  DateTime getTodayNormalized() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  /// Gets yesterday's date normalized (without time component).
  ///
  /// Returns yesterday's date with only year, month, and day components
  DateTime getYesterdayNormalized() {
    final today = getTodayNormalized();
    return today.subtract(const Duration(days: 1));
  }
}
