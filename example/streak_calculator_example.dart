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

  const calculator = StreakCalculator();

  // Simulate habit tracking data (exercise days)
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

  final result = calculator.calculateStreak(
    dates: exerciseDates,
    streakType: StreakType.daily,
  );

  print(
    'Exercise dates: ${exerciseDates.map((d) => '${d.month}/${d.day}').join(', ')}',
  );
  print('Current daily streak: ${result.currentStreak} days');
  print('Best daily streak: ${result.bestStreak} days');
  print('Streak type: ${result.streakType}');
}

void _weeklyStreakExample() {
  print('📊 Weekly Streak Example');
  print('-' * 26);

  const calculator = StreakCalculator();

  // Simulate weekly goal completion (at least once per week)
  final goalCompletionDates = [
    DateTime(2024, 1, 1), // Week 1
    DateTime(2024, 1, 8), // Week 2
    DateTime(2024, 1, 15), // Week 3
    DateTime(2024, 1, 22), // Week 4
    DateTime(2024, 1, 29), // Week 5
    DateTime(2024, 2, 5), // Week 6
    DateTime(2024, 2, 19), // Week 8 (gap in week 7)
    DateTime(2024, 2, 26), // Week 9
  ];

  // Calculate with Monday as week start (default)
  final mondayResult = calculator.calculateStreak(
    dates: goalCompletionDates,
    streakType: StreakType.weekly,
    weekStartDay: WeekStartDay.monday,
  );

  // Calculate with Sunday as week start
  final sundayResult = calculator.calculateStreak(
    dates: goalCompletionDates,
    streakType: StreakType.weekly,
    weekStartDay: WeekStartDay.sunday,
  );

  print(
    'Goal completion dates: ${goalCompletionDates.map((d) => '${d.month}/${d.day}').join(', ')}',
  );
  print(
    'Weekly streak (Mon start): Current ${mondayResult.currentStreak}, Best ${mondayResult.bestStreak}',
  );
  print(
    'Weekly streak (Sun start): Current ${sundayResult.currentStreak}, Best ${sundayResult.bestStreak}',
  );
}

void _monthlyStreakExample() {
  print('📈 Monthly Streak Example');
  print('-' * 27);

  const calculator = StreakCalculator();

  // Simulate monthly project contributions
  final contributionDates = [
    DateTime(2023, 10, 15), // October
    DateTime(2023, 11, 3), // November
    DateTime(2023, 12, 20), // December
    DateTime(2024, 1, 8), // January
    DateTime(2024, 1, 22), // January (multiple in same month)
    DateTime(2024, 2, 14), // February
    DateTime(2024, 2, 28), // February
    // March missing - breaks current streak
    DateTime(2024, 4, 10), // April
    DateTime(2024, 5, 5), // May
  ];

  final result = calculator.calculateStreak(
    dates: contributionDates,
    streakType: StreakType.monthly,
  );

  final monthNames = contributionDates
      .map((d) => '${_getMonthName(d.month)} ${d.year}')
      .toSet()
      .toList()
    ..sort();

  print('Active months: ${monthNames.join(', ')}');
  print('Current monthly streak: ${result.currentStreak} months');
  print('Best monthly streak: ${result.bestStreak} months');
}

void _performanceExample() {
  print('⚡ Performance Example');
  print('-' * 21);

  const calculator = StreakCalculator();

  // Generate a large dataset (10,000 dates over ~27 years)
  print('Generating large dataset...');
  final stopwatch = Stopwatch()..start();

  final largeDateSet = <DateTime>[];
  final baseDate = DateTime(2000, 1, 1);

  // Create dates with some gaps to make it realistic
  for (int i = 0; i < 10000; i++) {
    // Skip some days randomly to create realistic gaps
    final skipDays = i % 7 == 0 ? 2 : 0; // Skip 2 days every 7th iteration
    largeDateSet.add(baseDate.add(Duration(days: i + skipDays)));
  }

  final generationTime = stopwatch.elapsedMilliseconds;
  stopwatch.reset();

  // Calculate daily streak
  final dailyResult = calculator.calculateStreak(
    dates: largeDateSet,
    streakType: StreakType.daily,
  );

  final dailyCalculationTime = stopwatch.elapsedMilliseconds;
  stopwatch.reset();

  // Calculate weekly streak
  final weeklyResult = calculator.calculateStreak(
    dates: largeDateSet,
    streakType: StreakType.weekly,
  );

  final weeklyCalculationTime = stopwatch.elapsedMilliseconds;
  stopwatch.reset();

  // Calculate monthly streak
  final monthlyResult = calculator.calculateStreak(
    dates: largeDateSet,
    streakType: StreakType.monthly,
  );

  final monthlyCalculationTime = stopwatch.elapsedMilliseconds;
  stopwatch.stop();

  print('Dataset size: ${largeDateSet.length} dates');
  print('Date range: ${largeDateSet.first.year}-${largeDateSet.last.year}');
  print('');
  print('Performance Results:');
  print('  Generation time: ${generationTime}ms');
  print(
    '  Daily calculation: ${dailyCalculationTime}ms (Current: ${dailyResult.currentStreak}, Best: ${dailyResult.bestStreak})',
  );
  print(
    '  Weekly calculation: ${weeklyCalculationTime}ms (Current: ${weeklyResult.currentStreak}, Best: ${weeklyResult.bestStreak})',
  );
  print(
    '  Monthly calculation: ${monthlyCalculationTime}ms (Current: ${monthlyResult.currentStreak}, Best: ${monthlyResult.bestStreak})',
  );
  print('');
  print('✅ All calculations completed efficiently!');
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
