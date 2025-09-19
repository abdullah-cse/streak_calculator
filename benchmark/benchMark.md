## 🔬 Running Benchmarks

Want to test performance on your own hardware? Create a benchmark file:

```dart
// benchmark/streak_calculator_benchmark.dart
import 'dart:math';
import 'package:streak_calculator/streak_calculator.dart';

void main() {
  // Test with 10,000 random dates
  final random = Random();
  final dates = List.generate(10000, (i) {
    final randomDays = random.nextInt(365 * 2); // 2 years of data
    return DateTime(2024, 1, 1).add(Duration(days: randomDays));
  });
  
  print('Testing ${dates.length} dates...');
  
  final stopwatch = Stopwatch()..start();
  final calculator = StreakCalculator(
    dates: dates,
    streakType: StreakType.daily,
  );
  
  final currentStreak = calculator.currentStreak;
  final bestStreak = calculator.bestStreak;
  stopwatch.stop();
  
  print('Current streak: $currentStreak');
  print('Best streak: $bestStreak');
  print('Execution time: ${stopwatch.elapsedMilliseconds}ms');
}
```

Run with:
```bash
dart run benchmark/streak_calculator_benchmark.dart
```