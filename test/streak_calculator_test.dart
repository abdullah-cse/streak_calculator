// import 'package:streak_calculator/streak_calculator.dart';
// import 'package:test/test.dart';

// void main() {
//   group('StreakCalculator', () {
//     late StreakCalculator calculator;

//     setUp(() {
//       calculator = const StreakCalculator();
//     });

//     group('Daily Streaks', () {
//       test('calculates current daily streak correctly', () {
//         final today = DateTime.now();
//         final dates = [
//           DateTime(today.year, today.month, today.day), // Today
//           DateTime(today.year, today.month, today.day - 1), // Yesterday
//           DateTime(today.year, today.month, today.day - 2), // Day before
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         expect(result.currentStreak, equals(3));
//         expect(result.bestStreak, equals(3));
//         expect(result.streakType, equals(StreakType.daily));
//       });

//       test('handles gaps in daily streak correctly', () {
//         final dates = [
//           DateTime(2024, 1, 1),
//           DateTime(2024, 1, 2),
//           DateTime(2024, 1, 3),
//           DateTime(2024, 1, 5), // Gap here
//           DateTime(2024, 1, 6),
//           DateTime(2024, 1, 7),
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         expect(result.bestStreak, equals(3)); // Best streak is 1,2,3
//       });

//       test('calculates best daily streak when current is broken', () {
//         final dates = [
//           DateTime(2024, 1, 1),
//           DateTime(2024, 1, 2),
//           DateTime(2024, 1, 3),
//           DateTime(2024, 1, 4),
//           DateTime(2024, 1, 5), // Best streak of 5 days
//           DateTime(2024, 1, 7), // Gap breaks it
//           DateTime(2024, 1, 8), // New streak of 2
//           DateTime(2024, 1, 9),
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         expect(result.bestStreak, equals(5));
//       });

//       test('handles single day correctly', () {
//         final dates = [DateTime(2024, 1, 1)];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         expect(result.bestStreak, equals(1));
//       });
//     });

//     group('Weekly Streaks', () {
//       test('calculates weekly streak with Monday start', () {
//         final dates = [
//           DateTime(2024, 1, 1), // Monday, Week 1
//           DateTime(2024, 1, 8), // Monday, Week 2
//           DateTime(2024, 1, 15), // Monday, Week 3
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.weekly,
//           weekStartDay: WeekStartDay.monday,
//         );

//         expect(result.bestStreak, equals(3));
//       });

//       test('calculates weekly streak with Sunday start', () {
//         final dates = [
//           DateTime(2024, 1, 7), // Sunday, Week 1
//           DateTime(2024, 1, 14), // Sunday, Week 2
//           DateTime(2024, 1, 21), // Sunday, Week 3
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.weekly,
//           weekStartDay: WeekStartDay.sunday,
//         );

//         expect(result.bestStreak, equals(3));
//       });

//       test('counts multiple days in same week as one', () {
//         final dates = [
//           DateTime(2024, 1, 1), // Monday
//           DateTime(2024, 1, 3), // Wednesday (same week)
//           DateTime(2024, 1, 5), // Friday (same week)
//           DateTime(2024, 1, 8), // Next Monday (week 2)
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.weekly,
//         );

//         expect(result.bestStreak, equals(2)); // 2 weeks
//       });

//       test('handles gaps in weekly streaks', () {
//         final dates = [
//           DateTime(2024, 1, 1), // Week 1
//           DateTime(2024, 1, 8), // Week 2
//           DateTime(2024, 1, 22), // Week 4 (Week 3 missing)
//           DateTime(2024, 1, 29), // Week 5
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.weekly,
//         );

//         expect(result.bestStreak, equals(2)); // Best streak is weeks 4-5
//       });
//     });

//     group('Monthly Streaks', () {
//       test('calculates monthly streak correctly', () {
//         final dates = [
//           DateTime(2024, 1, 15), // January
//           DateTime(2024, 2, 20), // February
//           DateTime(2024, 3, 10), // March
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.monthly,
//         );

//         expect(result.bestStreak, equals(3));
//       });

//       test('counts multiple days in same month as one', () {
//         final dates = [
//           DateTime(2024, 1, 1),
//           DateTime(2024, 1, 15),
//           DateTime(2024, 1, 30), // All January
//           DateTime(2024, 2, 15), // February
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.monthly,
//         );

//         expect(result.bestStreak, equals(2)); // 2 months
//       });

//       test('handles gaps in monthly streaks', () {
//         final dates = [
//           DateTime(2024, 1, 1), // January
//           DateTime(2024, 2, 1), // February
//           DateTime(2024, 4, 1), // April (March missing)
//           DateTime(2024, 5, 1), // May
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.monthly,
//         );

//         expect(result.bestStreak, equals(2)); // Best is Jan-Feb or Apr-May
//       });

//       test('handles year boundaries correctly', () {
//         final dates = [
//           DateTime(2023, 11, 15), // November 2023
//           DateTime(2023, 12, 20), // December 2023
//           DateTime(2024, 1, 10), // January 2024
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.monthly,
//         );

//         expect(result.bestStreak, equals(3));
//       });
//     });

//     group('Edge Cases', () {
//       test('throws error for empty date list', () {
//         expect(
//           () => calculator.calculateStreak(
//             dates: [],
//             streakType: StreakType.daily,
//           ),
//           throwsA(isA<ArgumentError>()),
//         );
//       });

//       test('handles duplicate dates correctly', () {
//         final dates = [
//           DateTime(2024, 1, 1),
//           DateTime(2024, 1, 1), // Duplicate
//           DateTime(2024, 1, 2),
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         expect(result.bestStreak, equals(2));
//       });

//       test('normalizes dates with time components', () {
//         final dates = [
//           DateTime(2024, 1, 1, 10, 30), // With time
//           DateTime(2024, 1, 1, 15, 45), // Same day, different time
//           DateTime(2024, 1, 2, 9, 15), // Next day with time
//         ];

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         expect(result.bestStreak, equals(2)); // Should count as 2 days
//       });

//       test('handles very large datasets efficiently', () {
//         // Generate 1000 consecutive dates
//         final dates = List.generate(
//           1000,
//           (index) => DateTime(2024, 1, 1).add(Duration(days: index)),
//         );

//         final stopwatch = Stopwatch()..start();

//         final result = calculator.calculateStreak(
//           dates: dates,
//           streakType: StreakType.daily,
//         );

//         stopwatch.stop();

//         expect(result.bestStreak, equals(1000));
//         expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be fast
//       });
//     });

//     group('StreakResult', () {
//       test('equality works correctly', () {
//         const result1 = StreakResult(
//           currentStreak: 5,
//           bestStreak: 10,
//           streakType: StreakType.daily,
//         );

//         const result2 = StreakResult(
//           currentStreak: 5,
//           bestStreak: 10,
//           streakType: StreakType.daily,
//         );

//         const result3 = StreakResult(
//           currentStreak: 3,
//           bestStreak: 10,
//           streakType: StreakType.daily,
//         );

//         expect(result1, equals(result2));
//         expect(result1, isNot(equals(result3)));
//       });

//       test('copyWith works correctly', () {
//         const original = StreakResult(
//           currentStreak: 5,
//           bestStreak: 10,
//           streakType: StreakType.daily,
//         );

//         final copy = original.copyWith(currentStreak: 7);

//         expect(copy.currentStreak, equals(7));
//         expect(copy.bestStreak, equals(10));
//         expect(copy.streakType, equals(StreakType.daily));
//       });

//       test('toString works correctly', () {
//         const result = StreakResult(
//           currentStreak: 5,
//           bestStreak: 10,
//           streakType: StreakType.daily,
//         );

//         expect(
//           result.toString(),
//           equals('StreakResult(current: 5, best: 10, type: StreakType.daily)'),
//         );
//       });
//     });
//   });
// }
