# 🔥 Streak Calculator

[![License: MIT](https://badgen.net/static/license/MIT/blue)](https://opensource.org/license/mit) [![Pub Version](https://badgen.net/pub/v/streak_calculator)](https://pub.dev/packages/streak_calculator/versions) [![Pub Likes](https://badgen.net/pub/likes/streak_calculator)](https://pub.dev/packages/streak_calculator/score) [![Pub Monthly Downloads](https://badgen.net/pub/dm/streak_calculator?color=purple)](https://pub.dev/packages/streak_calculator/score)
[![Github Stars](https://badgen.net/github/stars/abdullah-cse/streak_calculator?icon=github)](https://github.com/abdullah-cse/streak_calculator/stargazers) [![Github Open Isssues](https://badgen.net/github/open-issues/abdullah-cse/streak_calculator/?icon=github)](https://github.com/abdullah-cse/streak_calculator/issues) [![Github Pull Request](https://badgen.net/github/open-prs/abdullah-cse/streak_calculator/?icon=github)](https://github.com/abdullah-cse/streak_calculator/pulls) [![Github Last Commit](https://badgen.net/github/last-commit/abdullah-cse/streak_calculator/?icon=github)](https://github.com/abdullah-cse/streak_calculator/commits/main/)
[![X (formerly Twitter) Follow](https://badgen.net/static/Follow/@abdullahPBD/black?icon=twitter)](https://x.com/abdullahPDB)


A powerful and flexible Dart package for calculating activity streaks with support for daily, weekly, and monthly patterns.

Perfect for habit tracking apps, fitness applications, productivity tools, and any app that needs to measure user engagement consistency.


## ✨ Features

- **🔥 Current & Best Streaks**: Track both ongoing streaks and historical records
- **🗓️ Multiple Streak Types**: Daily, weekly, and monthly streak calculations
- **🎯 Configurable Targets**: Set custom goals for weekly (1-7 days) and monthly (1-28 days) streaks
- **📅 Flexible Week Start**: Configure any day of the week as your week start (Monday-Sunday)
- **🧹 Smart Data Processing**: Automatic duplicate removal, sorting, and time normalization
- **⚡ High Performance**: Optimized algorithms with O(1) lookups for large datasets

- **✅ Null Safety**: Full null safety support


## 🚀 Quick Start

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  streak_calculator: ^0.2.1
```

Then run:

```bash
dart pub get
```

## 📋  Basic Usage

### Daily Streaks (Current + Best)

Perfect for tracking daily habits like meditation, exercise, or reading:

```dart
import 'package:streak_calculator/streak_calculator.dart';

void main() {
  // Track daily meditation sessions
  final meditationDates = [
    DateTime(2025, 9, 15),
    DateTime(2025, 9, 16),
    DateTime(2025, 9, 17),
    DateTime(2025, 9, 18),
    DateTime(2025, 9, 19), // Today
  ];
  final streakCalc = StreakCalculator(
    dates: meditationDates,
    streakType: StreakType.daily,
  );

  print('Current meditation streak: ${streakCalc.currentStreak} days');
  print('Best meditation streak: ${streakCalc.bestStreak} days');
}
```

###  Weekly Streaks (Current + Best)

Great for fitness goals like "workout at least 3 times per week":

```dart
import 'package:streak_calculator/streak_calculator.dart';

void main() {
  // Track workout sessions with goal of 3 workouts per week
  final workoutDates = [
    DateTime(2025, 9, 1),  // Week 1: Mon
    DateTime(2025, 9, 3),  // Week 1: Wed  
    DateTime(2025, 9, 5),  // Week 1: Fri (3 days - goal met!)
    DateTime(2025, 9, 9),  // Week 2: Mon
    DateTime(2025, 9, 11), // Week 2: Wed
    DateTime(2025, 9, 12), // Week 2: Thu (3 days - goal met!)
    DateTime(2025, 9, 16), // Week 3: Mon
    DateTime(2025, 9, 18), // Week 3: Wed (only 2 days - streak broken)
  ];

  final weeklyStreak = StreakCalculator(
    dates: workoutDates,
    streakType: StreakType.weekly,
    streakTarget: 3, // Need at least 3 workouts per week
    weekStartDay: DateTime.monday,
  );

  print('Weekly workout streak: ${weeklyStreak.currentStreak} weeks');
  print('Best weekly streak: ${weeklyStreak.bestStreak} weeks');
}
```

### Monthly Streaks (Current + Best)

Ideal for broader goals like "read at least 10 days per month":

```dart
import 'package:streak_calculator/streak_calculator.dart';

void main() {
  // Track reading sessions with monthly target
  final readingDates = [
    // January 2025 - 12 reading days (goal met!)
    DateTime(2025, 1, 1), DateTime(2025, 1, 3), DateTime(2025, 1, 5),
    DateTime(2025, 1, 7), DateTime(2025, 1, 9), DateTime(2025, 1, 11),
    DateTime(2025, 1, 13), DateTime(2025, 1, 15), DateTime(2025, 1, 17),
    DateTime(2025, 1, 19), DateTime(2025, 1, 21), DateTime(2025, 1, 23),
    
    // February 2025 - 15 reading days (goal met!)
    DateTime(2025, 2, 2), DateTime(2025, 2, 4), DateTime(2025, 2, 6),
    DateTime(2025, 2, 8), DateTime(2025, 2, 10), DateTime(2025, 2, 12),
    DateTime(2025, 2, 14), DateTime(2025, 2, 16), DateTime(2025, 2, 18),
    DateTime(2025, 2, 20), DateTime(2025, 2, 22), DateTime(2025, 2, 24),
    DateTime(2025, 2, 26), DateTime(2025, 2, 27), DateTime(2025, 2, 28),
  ];

  final monthlyStreak = StreakCalculator(
    dates: readingDates,
    streakType: StreakType.monthly,
    streakTarget: 10, // Need at least 10 reading days per month
  );

  print('Monthly reading streak: ${monthlyStreak.currentStreak} months');
  print('Best monthly streak: ${monthlyStreak.bestStreak} months');
}
```
## ⚙️ Configuration Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dates` | `List<DateTime>` | Required | List of activity dates |
| `streakType` | `StreakType` | Required | `daily`, `weekly`, or `monthly` |
| `streakTarget` | `int` | `1` | Days required per week (1-7) or month (1-28) |
| `weekStartDay` | `int` | `DateTime.monday` | First day of week (1=Monday, 7=Sunday) |

### 🧮 Streak Calculation Logic

- **Daily**: Each consecutive day counts as +1 to streak
- **Weekly**: Consecutive weeks with ≥ `streakTarget` days count as +1 to streak
- **Monthly**: Consecutive months with ≥ `streakTarget` days count as +1 to streak

## 🔧 Advanced Configuration

### Custom Week Start Days

```dart
// Start weeks on Sunday (perfect for US-based apps)
final sundayWeekStreak = StreakCalculator(
  dates: dates,
  streakType: StreakType.weekly,
  streakTarget: 2,
  weekStartDay: DateTime.sunday,
);

// Start weeks on Wednesday (custom business cycle)
final midWeekStreak = StreakCalculator(
  dates: dates,
  streakType: StreakType.weekly,
  streakTarget: 4,
  weekStartDay: DateTime.wednesday,
);
```


## 🛠️ Data Handling

The package automatically handles messy real-world data:

```dart
void main() {
  // Messy data with duplicates, unsorted dates, and time components
  final messyData = [
    DateTime(2025, 9, 17, 14, 30), // Afternoon
    DateTime(2025, 9, 15, 9, 15),  // Morning (out of order)
    DateTime(2025, 9, 16, 23, 45), // Night
    DateTime(2025, 9, 17, 8, 0),   // Duplicate date (different time)
    DateTime(2025, 9, 18, 12, 0),  // Noon
  ];

  // The package automatically:
  // 1. Removes duplicate dates (keeps unique days only)
  // 2. Sorts dates chronologically
  // 3. Normalizes times to midnight
  // 4. Validates input parameters

  final calculator = StreakCalculator(
    dates: messyData,
    streakType: StreakType.daily,
  );

  print('Clean streak calculation: ${calculator.currentStreak}'); // 4 days
}
```

## 📊 Performance & Benchmarks

### Time Complexity
- **Initial Processing**: O(n log n) for sorting and normalization
- **Streak Calculation**: O(n) linear pass through sorted data
- **Memory Usage**: O(n) for date storage with duplicate removal

### Benchmark Results

Tested on MacMini M2 (2023), 16GB RAM, Dart 3.0+

#### Dataset Size Performance (Daily Streaks)
```
   100 dates:     0.45 ms
 1,000 dates:     1.23 ms
10,000 dates:     8.91 ms
50,000 dates:    33.92 ms
100,000 dates:   62.08 ms
```

#### Streak Type Performance (10,000 dates)
```
Daily  :  6.85 ms
Weekly :  6.96 ms
Monthly:  4.81 ms
```

#### Real-World Data Handling
```
Messy data processing:    4.47 ms
(10,000 dates with duplicates, random times, unsorted)
```
Want to test performance on your own hardware? See [BenchMark Guide](/benchmark/benchMark.md)


## 📝 Contributing

Feel free to contribute! Check out the [guides](/CONTRIBUTING.md) for more information.


## ❤️‍🔥 Enjoying this package?

Here are a few ways you can show support:
- ⭐️ Star it on [GitHub](https://github.com/abdullah-cse/streak_calculator) – stars help others discover it!
- If this package helped you, please give it a ⭐ on [pub.dev](https://pub.dev/packages/streak_calculator)!
- 👉 Try my [TypeFast app](https://web.typefast.app), a fun way to sharpen your touch typing skills with games.
- 👉  Explore more of my [work!](https://abdullah.com.bd)
