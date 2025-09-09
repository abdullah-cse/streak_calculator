# Streak Calculator

A comprehensive and high-performance streak calculation library for Dart applications. Calculate current and best streaks from date datasets with support for daily, weekly, and monthly streak types.

## Features

- 🚀 **High Performance**: Optimized for large datasets with O(1) lookups and minimal iterations
- 📅 **Multiple Streak Types**: Support for daily, weekly, and monthly streaks
- 🔧 **Configurable**: Customizable week start day (Monday by default)
- 📊 **Comprehensive Results**: Get both current and best (longest) streaks


### Basic Example

```dart
import 'package:streak_calculator/streak_calculator.dart';

void main() {
  final calculator = StreakCalculator();
  
  // Your activity dates
  final dates = [
    DateTime(2025, 9, 1),
    DateTime(2025, 9, 2),
    DateTime(2025, 9, 3),
    DateTime(2025, 9, 5),
    DateTime(2025, 9, 6),
  ];
  
  // Calculate daily streak
  final result = calculator.calculateStreak(
    dates: dates,
    streakType: StreakType.daily,
  );
  
  print('Current streak: ${result.currentStreak}');
  print('Best streak: ${result.bestStreak}');
}
```

### Advanced Usage

#### Weekly Streak with Custom Week Start

```dart
// Calculate weekly streak starting from Sunday
final weeklyResult = calculator.calculateStreak(
  dates: dates,
  streakType: StreakType.weekly,
  weekStartDay: WeekStartDay.sunday,
);

print('Weekly streak (Sun-Sat): ${weeklyResult.currentStreak}');
```

#### Monthly Streak

```dart
// Calculate monthly streak
final monthlyResult = calculator.calculateStreak(
  dates: dates,
  streakType: StreakType.monthly,
);

print('Monthly streak: ${monthlyResult.currentStreak}');
```

### Sara my Heart.
```dart
// Weekly streak requiring at least 3 days per week
final weeklyResult = calculator.calculateStreak(
  dates: dates,
  streakType: StreakType.weekly,
  streakTarget: 3,
);

// Monthly streak requiring at least 10 days per month
final monthlyResult = calculator.calculateStreak(
  dates: dates,
  streakType: StreakType.monthly,
  streakTarget: 10,
);
```


#### Working with Large Datasets

```dart
// The calculator is optimized for large datasets
final largeDateSet = List.generate(10000, (index) {
  return DateTime.now().subtract(Duration(days: index * 2));
});

final result = calculator.calculateStreak(
  dates: largeDateSet,
  streakType: StreakType.daily,
);
```

## Streak Types

### Daily Streak
Counts consecutive days with activity. A daily streak breaks if there's a gap of more than one day.

### Weekly Streak
Counts consecutive weeks with at least one activity day. Week boundaries are determined by the `WeekStartDay` parameter.

### Monthly Streak
Counts consecutive months with at least one activity day.

## API Reference

### StreakCalculator

Main class for calculating streaks.

#### Methods

##### calculateStreak()

```dart
StreakResult calculateStreak({
  required List<DateTime> dates,
  required StreakType streakType,
  WeekStartDay weekStartDay = WeekStartDay.monday,
})
```

**Parameters:**
- `dates` (required): List of activity dates to analyze
- `streakType` (required): Type of streak calculation (daily, weekly, monthly)
- `weekStartDay` (optional): Which day starts the week (defaults to Monday)

**Returns:** `StreakResult` containing current and best streak counts

**Throws:** `ArgumentError` if the dates list is empty

### StreakResult

Represents the result of a streak calculation.

**Properties:**
- `currentStreak` (int): The ongoing streak including today
- `bestStreak` (int): The longest streak found in the dataset
- `streakType` (StreakType): The type of streak calculation performed

### Enums

#### StreakType
- `daily`: Daily streak calculation
- `weekly`: Weekly streak calculation  
- `monthly`: Monthly streak calculation

#### WeekStartDay
- `sunday`: Week starts on Sunday
- `monday`: Week starts on Monday (default, ISO 8601)
- `tuesday`: Week starts on Tuesday
- `wednesday`: Week starts on Wednesday
- `thursday`: Week starts on Thursday
- `friday`: Week starts on Friday
- `saturday`: Week starts on Saturday

## Performance

The library is optimized for performance with large datasets:

- **O(1) Date Lookups**: Uses HashSet for constant-time date existence checks
- **Smart Sorting**: Handles unsorted data efficiently with single sort operation
- **Duplicate Removal**: Eliminates redundant dates during normalization
- **Memory Efficient**: Normalizes dates and removes time components
- **Lazy Evaluation**: Only calculates what's needed
- **Streak Target Optimization**: Filters data early when targets are specified

**Benchmarks:**
- 10,000+ dates processed in <100ms
- Handles unsorted, duplicated data seamlessly
- Memory usage scales linearly with unique dates

## Examples

### Habit Tracking App

```dart
class HabitTracker {
  final StreakCalculator _calculator = StreakCalculator();
  
  StreakResult getHabitStreak(List<DateTime> exerciseDates) {
    return _calculator.calculateStreak(
      dates: exerciseDates,
      streakType: StreakType.daily,
    );
  }
}
```

### Weekly Goal Tracking

```dart
class WeeklyGoalTracker {
  final StreakCalculator _calculator = StreakCalculator();
  
  StreakResult getWeeklyProgress(List<DateTime> activityDates) {
    return _calculator.calculateStreak(
      dates: activityDates,
      streakType: StreakType.weekly,
      weekStartDay: WeekStartDay.monday,
    );
  }
}
```

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.