import 'package:streak_calculator/src/enum/streak_type.dart';
import 'package:streak_calculator/src/model/streak_result.dart';
import 'package:test/test.dart';

void main() {
  group('StreakResult', () {
    test('constructor assigns values correctly', () {
      const result = StreakResult(
        currentStreak: 5,
        bestStreak: 10,
        streakType: StreakType.daily,
        streakTarget: 1,
      );

      expect(result.currentStreak, 5);
      expect(result.bestStreak, 10);
      expect(result.streakType, StreakType.daily);
      expect(result.streakTarget, 1);
    });

    test('supports value equality', () {
      const result1 = StreakResult(
        currentStreak: 5,
        bestStreak: 10,
        streakType: StreakType.daily,
      );
      const result2 = StreakResult(
        currentStreak: 5,
        bestStreak: 10,
        streakType: StreakType.daily,
      );
      const result3 = StreakResult(
        currentStreak: 6,
        bestStreak: 10,
        streakType: StreakType.daily,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
      expect(result1.hashCode, equals(result2.hashCode));
    });

    test('toString returns correct format', () {
      const result = StreakResult(
        currentStreak: 5,
        bestStreak: 10,
        streakType: StreakType.daily,
        streakTarget: 1,
      );

      expect(
        result.toString(),
        'StreakResult(current: 5, best: 10, type: StreakType.daily, target: 1)',
      );

      const resultNoTarget = StreakResult(
        currentStreak: 5,
        bestStreak: 10,
        streakType: StreakType.daily,
      );

      expect(
        resultNoTarget.toString(),
        'StreakResult(current: 5, best: 10, type: StreakType.daily)',
      );
    });

    test('copyWith creates new instance with updated values', () {
      const result = StreakResult(
        currentStreak: 5,
        bestStreak: 10,
        streakType: StreakType.daily,
      );

      final updated = result.copyWith(
        currentStreak: 6,
        bestStreak: 12,
        streakType: StreakType.weekly,
        streakTarget: 3,
      );

      expect(updated.currentStreak, 6);
      expect(updated.bestStreak, 12);
      expect(updated.streakType, StreakType.weekly);
      expect(updated.streakTarget, 3);

      // Original should be unchanged
      expect(result.currentStreak, 5);
    });

    test('copyWith preserves values when arguments are null', () {
      const result = StreakResult(
          currentStreak: 5,
          bestStreak: 10,
          streakType: StreakType.daily,
          streakTarget: 1);

      final updated = result.copyWith();

      expect(updated, equals(result));
      expect(updated.currentStreak, 5);
      expect(updated.bestStreak, 10);
      expect(updated.streakType, StreakType.daily);
      expect(updated.streakTarget, 1);
    });
  });
}
