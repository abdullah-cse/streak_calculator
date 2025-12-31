import 'package:streak_calculator/src/utilities/date_normalizer.dart';
import 'package:test/test.dart';

void main() {
  group('DateNormalizer', () {
    const normalizer = DateNormalizer();

    group('normalizeDates', () {
      test('removes time components', () {
        final dates = [
          DateTime(2025, 1, 1, 10, 30),
          DateTime(2025, 1, 2, 23, 59),
        ];
        final normalized = normalizer.normalizeDates(dates);

        expect(normalized, hasLength(2));
        expect(normalized.contains(DateTime(2025, 1, 1)), isTrue);
        expect(normalized.contains(DateTime(2025, 1, 2)), isTrue);
      });

      test('removes duplicates', () {
        final dates = [
          DateTime(2025, 1, 1, 10, 30),
          DateTime(2025, 1, 1, 15, 0), // Same day, different time
          DateTime(2025, 1, 1), // Same day, no time
        ];
        final normalized = normalizer.normalizeDates(dates);

        expect(normalized, hasLength(1));
        expect(normalized.first, DateTime(2025, 1, 1));
      });

      test('handles empty list', () {
        final normalized = normalizer.normalizeDates([]);
        expect(normalized, isEmpty);
      });
    });

    group('getTodayNormalized', () {
      test('returns today with no time component', () {
        final today = normalizer.getTodayNormalized();
        final now = DateTime.now();

        expect(today.year, now.year);
        expect(today.month, now.month);
        expect(today.day, now.day);
        expect(today.hour, 0);
        expect(today.minute, 0);
        expect(today.second, 0);
        expect(today.millisecond, 0);
        expect(today.microsecond, 0);
      });
    });

    group('getYesterdayNormalized', () {
      test('returns yesterday with no time component', () {
        final yesterday = normalizer.getYesterdayNormalized();
        final today = normalizer.getTodayNormalized();

        // Check time components
        expect(yesterday.hour, 0);
        expect(yesterday.minute, 0);
        expect(yesterday.second, 0);
        expect(yesterday.millisecond, 0);
        expect(yesterday.microsecond, 0);

        // Check relationship with today
        expect(today.difference(yesterday).inDays, 1);
      });
    });
  });
}
