/// Defines the different types of streak calculations supported.
enum StreakType {
  /// A daily streak counts consecutive days where there is at least one entry.
  /// The streak breaks if there's a gap of more than one day.
  /// Streak target parameter is ignored for daily streaks (always requires 1 activity per day).
  daily,

  /// A weekly streak counts consecutive weeks where there are at least [streakTarget] entries
  /// within that week. The week boundaries are determined by the [WeekStartDay].
  /// Streak target must be between 1-7 (days per week).
  weekly,

  /// A monthly streak counts consecutive months where there are at least [streakTarget] entries
  /// within that month. Streak target must be between 1-28 (days per month).
  monthly,
}
