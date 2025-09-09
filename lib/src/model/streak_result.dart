import '../enum/streak_type.dart';

/// Represents the result of a streak calculation.
///
/// Contains both the current streak (including today and yesterday) and
/// the best streak (highest occurrence) found in the dataset.
class StreakResult {
  /// Creates a new streak result.
  ///
  /// [currentStreak] represents the ongoing streak including today.
  /// [bestStreak] represents the longest streak found in the dataset.
  /// [streakType] indicates the type of streak calculation performed.
  /// [streakTarget] specifies the target for weekly (1-7) or monthly (1-28) streaks.
  /// For daily streaks, this parameter is ignored.
  const StreakResult({
    required this.currentStreak,
    required this.bestStreak,
    required this.streakType,
    this.streakTarget,
  });

  /// The current ongoing streak count.
  ///
  /// This includes today and counts backwards to find consecutive periods
  /// (days, weeks, or months depending on [streakType]) with activity.
  final int currentStreak;

  /// The best (longest) streak count found in the entire dataset.
  ///
  /// This represents the highest consecutive count of periods with activity
  /// found when analyzing the complete dataset.
  final int bestStreak;

  /// The type of streak calculation that was performed.
  final StreakType streakType;

  /// The target number for streak calculation.
  ///
  /// - For [StreakType.daily]: This parameter is ignored
  /// - For [StreakType.weekly]: Must be between 1-7 (days per week)
  /// - For [StreakType.monthly]: Must be between 1-28 (days per month)
  ///
  /// When specified, weekly/monthly streaks only count if the target is met.
  final int? streakTarget;

  @override
  String toString() =>
      'StreakResult(current: $currentStreak, best: $bestStreak, type: $streakType${streakTarget != null ? ', target: $streakTarget' : ''})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreakResult &&
        other.currentStreak == currentStreak &&
        other.bestStreak == bestStreak &&
        other.streakType == streakType &&
        other.streakTarget == streakTarget;
  }

  @override
  int get hashCode =>
      currentStreak.hashCode ^
      bestStreak.hashCode ^
      streakType.hashCode ^
      (streakTarget?.hashCode ?? 0);

  /// Creates a copy of this result with some values replaced.
  StreakResult copyWith({
    int? currentStreak,
    int? bestStreak,
    StreakType? streakType,
    int? streakTarget,
  }) =>
      StreakResult(
        currentStreak: currentStreak ?? this.currentStreak,
        bestStreak: bestStreak ?? this.bestStreak,
        streakType: streakType ?? this.streakType,
        streakTarget: streakTarget ?? this.streakTarget,
      );
}
