import 'dart:math';
import 'package:streak_calculator/streak_calculator.dart';

void main() {
  print('🔥 Streak Calculator Benchmark Results\n');

  // Run benchmarks with different dataset sizes
  _benchmarkDatasetSizes();
  _benchmarkStreakTypes();
  _benchmarkMessyData();
}

void _benchmarkDatasetSizes() {
  print('📊 Dataset Size Performance:');
  print('─' * 50);

  final sizes = [100, 1000, 10000, 50000, 100000];

  for (final size in sizes) {
    final dates = _generateConsecutiveDates(size);

    final stopwatch = Stopwatch()..start();
    final calculator = StreakCalculator(
      dates: dates,
      streakType: StreakType.daily,
    );
    final _ = calculator.currentStreak; // Access result
    stopwatch.stop();

    final microseconds = stopwatch.elapsedMicroseconds;
    final milliseconds = (microseconds / 1000).toStringAsFixed(2);

    print('${size.toString().padLeft(6)} dates: ${milliseconds.padLeft(8)} ms');
  }
  print('');
}

void _benchmarkStreakTypes() {
  print('🎯 Streak Type Performance (10,000 dates):');
  print('─' * 50);

  final dates = _generateRandomDates(10000);

  // Daily streak benchmark
  final dailyStopwatch = Stopwatch()..start();
  final dailyCalc = StreakCalculator(
    dates: dates,
    streakType: StreakType.daily,
  );
  final _ = dailyCalc.currentStreak;
  dailyStopwatch.stop();

  // Weekly streak benchmark
  final weeklyStopwatch = Stopwatch()..start();
  final weeklyCalc = StreakCalculator(
    dates: dates,
    streakType: StreakType.weekly,
    streakTarget: 3,
    weekStartDay: DateTime.monday,
  );
  final __ = weeklyCalc.currentStreak;
  weeklyStopwatch.stop();

  // Monthly streak benchmark
  final monthlyStopwatch = Stopwatch()..start();
  final monthlyCalc = StreakCalculator(
    dates: dates,
    streakType: StreakType.monthly,
    streakTarget: 10,
  );
  final ___ = monthlyCalc.currentStreak;
  monthlyStopwatch.stop();

  print(
      'Daily  : ${(dailyStopwatch.elapsedMicroseconds / 1000).toStringAsFixed(2).padLeft(8)} ms');
  print(
      'Weekly : ${(weeklyStopwatch.elapsedMicroseconds / 1000).toStringAsFixed(2).padLeft(8)} ms');
  print(
      'Monthly: ${(monthlyStopwatch.elapsedMicroseconds / 1000).toStringAsFixed(2).padLeft(8)} ms');
  print('');
}

void _benchmarkMessyData() {
  print('🧹 Messy Data Handling (10,000 dates with duplicates):');
  print('─' * 50);

  // Generate messy data with duplicates and random times
  final messyDates = _generateMessyDates(10000);

  final stopwatch = Stopwatch()..start();
  final calculator = StreakCalculator(
    dates: messyDates,
    streakType: StreakType.daily,
  );
  final _ = calculator.currentStreak;
  stopwatch.stop();

  final milliseconds =
      (stopwatch.elapsedMicroseconds / 1000).toStringAsFixed(2);
  print('Messy data processing: ${milliseconds.padLeft(8)} ms');
  print('(includes duplicate removal, sorting, normalization)');
  print('');
}

/// Generates consecutive dates for performance testing
List<DateTime> _generateConsecutiveDates(int count) {
  final dates = <DateTime>[];
  final baseDate = DateTime(2024, 1, 1);

  for (int i = 0; i < count; i++) {
    dates.add(baseDate.add(Duration(days: i)));
  }

  return dates;
}

/// Generates random dates over 2 years for realistic testing
List<DateTime> _generateRandomDates(int count) {
  final random = Random();
  final dates = <DateTime>[];
  final baseDate = DateTime(2024, 1, 1);

  for (int i = 0; i < count; i++) {
    final randomDays = random.nextInt(730); // 2 years
    dates.add(baseDate.add(Duration(days: randomDays)));
  }

  return dates;
}

/// Generates messy data with duplicates, random times, and unsorted order
List<DateTime> _generateMessyDates(int count) {
  final random = Random();
  final dates = <DateTime>[];
  final baseDate = DateTime(2024, 1, 1);

  for (int i = 0; i < count; i++) {
    final randomDays = random.nextInt(365);
    final randomHour = random.nextInt(24);
    final randomMinute = random.nextInt(60);
    final randomSecond = random.nextInt(60);

    dates.add(baseDate.add(Duration(
      days: randomDays,
      hours: randomHour,
      minutes: randomMinute,
      seconds: randomSecond,
    )));
  }

  // Add some duplicates (same day, different times)
  for (int i = 0; i < count ~/ 10; i++) {
    final existingDate = dates[random.nextInt(dates.length)];
    dates.add(existingDate.add(Duration(
      hours: random.nextInt(24),
      minutes: random.nextInt(60),
    )));
  }

  // Shuffle to make it unsorted
  dates.shuffle(random);

  return dates;
}
