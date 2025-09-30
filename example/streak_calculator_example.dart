import 'package:streak_calculator/streak_calculator.dart';

void main() {
  print('=== Streak Calculator Examples ===\n');

  runDailyExample();
  runWeeklyExample();
  runMonthlyExample();
}

// ============================================
// Daily Streak Example
// ============================================

void runDailyExample() {
  print('📊 Daily Streak');

  final dates = createDailyDates();
  final calculator = createDailyCalculator(dates);

  print('Current: ${calculator.currentStreak}');
  print('Best: ${calculator.bestStreak}');
  print('\n${'=' * 30}\n');
}

List<DateTime> createDailyDates() => [
      DateTime(2025, 9, 4),
      DateTime(2025, 9, 25),
      DateTime(2025, 9, 26),
      DateTime(2025, 9, 27), // Gap breaks streak
      DateTime(2025, 9, 29),
      DateTime(2025, 9, 30),
    ];

StreakCalculator createDailyCalculator(List<DateTime> dates) =>
    StreakCalculator(
      streakType: StreakType.daily,
      dates: dates,
    );

// ============================================
// Weekly Streak Example
// ============================================

void runWeeklyExample() {
  print('📊 Weekly Streak');

  final dates = createWeeklyDates();
  final calculator = createWeeklyCalculator(dates);

  print('Current: ${calculator.currentStreak}');
  print('Best: ${calculator.bestStreak}');
  print('\n${'=' * 30}\n');
}

List<DateTime> createWeeklyDates() => [
      DateTime(2025, 6, 1),
      DateTime(2025, 7, 8),
      DateTime(2025, 8, 25),
      DateTime(2025, 9, 28),
      DateTime(2025, 9, 30),
    ];

StreakCalculator createWeeklyCalculator(List<DateTime> dates) =>
    StreakCalculator(
      streakType: StreakType.weekly,
      dates: dates,
      streakTarget: 1,
    );

// ============================================
// Monthly Streak Example
// ============================================

void runMonthlyExample() {
  print('📊 Monthly Streak');

  final dates = createMonthlyDates();
  final calculator = createMonthlyCalculator(dates);

  print('Current: ${calculator.currentStreak}');
  print('Best: ${calculator.bestStreak}');
}

List<DateTime> createMonthlyDates() => [
      DateTime(2025, 1, 15),
      DateTime(2025, 2, 3),
      DateTime(2025, 7, 20),
      DateTime(2025, 7, 8),
      DateTime(2025, 9, 14),
    ];

StreakCalculator createMonthlyCalculator(List<DateTime> dates) =>
    StreakCalculator(
      streakType: StreakType.monthly,
      dates: dates,
      streakTarget: 1,
    );
