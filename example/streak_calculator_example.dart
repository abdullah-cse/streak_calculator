import 'package:streak_calculator/streak_calculator.dart';

void main() {
  print('=== Streak Calculator Examples ===\n');

  // Example 1: Daily Streak
  _dailyStreakExample();

  print('\n${'=' * 40}\n');

  // Example 2: Weekly Streak
  _weeklyStreakExample();

  print('\n${'=' * 40}\n');

  // Example 3: Monthly Streak
  _monthlyStreakExample();

  print('\n${'=' * 40}\n');

  // Example 4: Large Dataset Performance
  _performanceExample();
}

void _dailyStreakExample() {
  print('📅 Daily Streak Example');
  print('-' * 25);

  final exerciseDates = [
    DateTime(2024, 1, 1),
    DateTime(2024, 1, 2),
    DateTime(2024, 1, 3),
    DateTime(2024, 1, 5), // Gap here breaks the streak
    DateTime(2024, 1, 6),
    DateTime(2024, 1, 7),
    DateTime(2024, 1, 8),
    DateTime(2024, 1, 9),
  ];

  final calculator = StreakCalculator(
    streakType: StreakType.daily,
    dates: exerciseDates,
  );

  print(
    'Exercise dates: ${exerciseDates.map((d) => '${d.month}/${d.day}').join(', ')}',
  );
  print('Current daily streak: ${calculator.currentStreak} days');
  print('Best daily streak: ${calculator.bestStreak} days');
}

void _weeklyStreakExample() {
  print('📊 Weekly Streak Example');
  print('-' * 26);

  final goalCompletionDates = [
    DateTime(2024, 1, 1),
    DateTime(2024, 1, 8),
    DateTime(2024, 1, 15),
    DateTime(2024, 1, 22),
    DateTime(2024, 1, 29),
    DateTime(2024, 2, 5),
    DateTime(2024, 2, 19),
    DateTime(2024, 2, 26),
  ];

  final mondayCalculator = StreakCalculator(
    streakType: StreakType.weekly,
    dates: goalCompletionDates,
    streakTarget: 1,
    weekStartDay: DateTime.monday,
  );

  final sundayCalculator = StreakCalculator(
    streakType: StreakType.weekly,
    dates: goalCompletionDates,
    streakTarget: 1,
    weekStartDay: DateTime.sunday,
  );

  print(
    'Goal completion dates: ${goalCompletionDates.map((d) => '${d.month}/${d.day}').join(', ')}',
  );
  print(
    'Weekly streak (Mon start): Current ${mondayCalculator.currentStreak}, Best ${mondayCalculator.bestStreak}',
  );
  print(
    'Weekly streak (Sun start): Current ${sundayCalculator.currentStreak}, Best ${sundayCalculator.bestStreak}',
  );
}

void _monthlyStreakExample() {
  print('📈 Monthly Streak Example');
  print('-' * 27);

  final contributionDates = [
    DateTime(2023, 10, 15),
    DateTime(2023, 11, 3),
    DateTime(2023, 12, 20),
    DateTime(2024, 1, 8),
    DateTime(2024, 1, 22),
    DateTime(2024, 2, 14),
    DateTime(2024, 2, 28),
    DateTime(2024, 4, 10),
    DateTime(2024, 5, 5),
  ];

  final calculator = StreakCalculator(
    streakType: StreakType.monthly,
    dates: contributionDates,
    streakTarget: 1,
  );

  final monthNames = contributionDates
      .map((d) => '${_getMonthName(d.month)} ${d.year}')
      .toSet()
      .toList()
    ..sort();

  print('Active months: ${monthNames.join(', ')}');
  print('Current monthly streak: ${calculator.currentStreak} months');
  print('Best monthly streak: ${calculator.bestStreak} months');
}

void _performanceExample() {
  print('⚡ Performance Example');
  print('-' * 21);

  final stopwatch = Stopwatch()..start();

  final largeDateSet = <DateTime>[];
  final baseDate = DateTime(2000, 1, 1);

  for (int i = 0; i < 10000; i++) {
    final skipDays = i % 7 == 0 ? 2 : 0;
    largeDateSet.add(baseDate.add(Duration(days: i + skipDays)));
  }

  final generationTime = stopwatch.elapsedMilliseconds;
  stopwatch.reset();

  final dailyCalculator = StreakCalculator(
    streakType: StreakType.daily,
    dates: largeDateSet,
  );
  final dailyTime = stopwatch.elapsedMilliseconds;
  stopwatch.reset();

  final weeklyCalculator = StreakCalculator(
    streakType: StreakType.weekly,
    dates: largeDateSet,
    streakTarget: 1,
  );
  final weeklyTime = stopwatch.elapsedMilliseconds;
  stopwatch.reset();

  final monthlyCalculator = StreakCalculator(
    streakType: StreakType.monthly,
    dates: largeDateSet,
    streakTarget: 1,
  );
  final monthlyTime = stopwatch.elapsedMilliseconds;
  stopwatch.stop();

  print('Dataset size: ${largeDateSet.length} dates');
  print('Date range: ${largeDateSet.first.year}-${largeDateSet.last.year}\n');

  print('Performance Results:');
  print('  Generation time: ${generationTime}ms');
  print(
    '  Daily calculation: ${dailyTime}ms (Current: ${dailyCalculator.currentStreak}, Best: ${dailyCalculator.bestStreak})',
  );
  print(
    '  Weekly calculation: ${weeklyTime}ms (Current: ${weeklyCalculator.currentStreak}, Best: ${weeklyCalculator.bestStreak})',
  );
  print(
    '  Monthly calculation: ${monthlyTime}ms (Current: ${monthlyCalculator.currentStreak}, Best: ${monthlyCalculator.bestStreak})',
  );

  print('\n✅ All calculations completed efficiently!');
}

String _getMonthName(int month) {
  const monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return monthNames[month];
}
