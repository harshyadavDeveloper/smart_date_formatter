import 'package:flutter_test/flutter_test.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

void main() {
  late SmartDateFormatter formatter;
  late DateTime now;

  setUp(() {
    formatter = const SmartDateFormatter();
    now = DateTime(
        2024, 6, 15, 14, 30, 0); // Fixed reference: Sat 15 Jun 2024, 2:30 PM
  });

  group('SmartDateFormatter.format()', () {
    test('returns Just now for < 10 seconds', () {
      final date = now.subtract(const Duration(seconds: 5));
      expect(formatter.format(date, now: now), 'Just now');
    });

    test('returns seconds ago for < 60 seconds', () {
      final date = now.subtract(const Duration(seconds: 45));
      expect(formatter.format(date, now: now), '45 seconds ago');
    });

    test('returns 1 minute ago', () {
      final date = now.subtract(const Duration(minutes: 1));
      expect(formatter.format(date, now: now), '1 minute ago');
    });

    test('returns X minutes ago', () {
      final date = now.subtract(const Duration(minutes: 25));
      expect(formatter.format(date, now: now), '25 minutes ago');
    });

    test('returns 1 hour ago', () {
      final date = now.subtract(const Duration(hours: 1));
      expect(formatter.format(date, now: now), '1 hour ago');
    });

    test('returns X hours ago', () {
      final date = now.subtract(const Duration(hours: 5));
      expect(formatter.format(date, now: now), '5 hours ago');
    });

    test('returns Yesterday', () {
      final date = now.subtract(const Duration(days: 1));
      expect(formatter.format(date, now: now), 'Yesterday');
    });

    test('returns Tomorrow for future 1 day', () {
      final date = now.add(const Duration(days: 1));
      expect(formatter.format(date, now: now), 'Tomorrow');
    });

    test('returns X days ago', () {
      final date = now.subtract(const Duration(days: 4));
      expect(formatter.format(date, now: now), '4 days ago');
    });

    test('returns Last week', () {
      final date = now.subtract(const Duration(days: 8));
      expect(formatter.format(date, now: now), 'Last week');
    });

    test('returns Last month', () {
      final date = now.subtract(const Duration(days: 35));
      expect(formatter.format(date, now: now), 'Last month');
    });

    test('returns X months ago', () {
      final date = now.subtract(const Duration(days: 90));
      expect(formatter.format(date, now: now), '3 months ago');
    });

    test('returns Last year', () {
      final date = now.subtract(const Duration(days: 400));
      expect(formatter.format(date, now: now), 'Last year');
    });

    test('returns X years ago', () {
      final date = now.subtract(const Duration(days: 800));
      expect(formatter.format(date, now: now), '2 years ago');
    });
  });

  group('SmartDateFormatter.calendar()', () {
    test('returns Today', () {
      expect(formatter.calendar(now, now: now), 'Today');
    });

    test('returns Yesterday', () {
      final date = now.subtract(const Duration(days: 1));
      expect(formatter.calendar(date, now: now), 'Yesterday');
    });

    test('returns Tomorrow', () {
      final date = now.add(const Duration(days: 1));
      expect(formatter.calendar(date, now: now), 'Tomorrow');
    });

    test('returns weekday name for within this week', () {
      final date = now.add(const Duration(days: 2));
      expect(formatter.calendar(date, now: now), 'Monday');
    });

    test('returns Last Weekday for last week', () {
      final date = now.subtract(const Duration(days: 3));
      expect(formatter.calendar(date, now: now), 'Last Wednesday');
    });

    test('returns full date for older dates', () {
      final date = DateTime(2023, 1, 5);
      expect(formatter.calendar(date, now: now), '5 January 2023');
    });
  });

  group('SmartDateFormatter.shortTimestamp()', () {
    test('returns time for today', () {
      final date = DateTime(2024, 6, 15, 9, 5);
      expect(formatter.shortTimestamp(date, now: now), '9:05 AM');
    });

    test('returns day + time for this week', () {
      final date = DateTime(2024, 6, 13, 14, 30);
      expect(formatter.shortTimestamp(date, now: now), contains('Thu'));
    });

    test('returns short date for older', () {
      final date = DateTime(2024, 1, 3);
      expect(formatter.shortTimestamp(date, now: now), '3 Jan');
    });
  });

  group('DateTime extensions', () {
    test('isToday works', () {
      expect(DateTime.now().isToday, true);
    });

    test('isPast works', () {
      expect(DateTime(2000, 1, 1).isPast, true);
    });

    test('isFuture works', () {
      expect(DateTime(2099, 1, 1).isFuture, true);
    });

    test('startOfDay has midnight time', () {
      final d = DateTime.now().startOfDay;
      expect(d.hour, 0);
      expect(d.minute, 0);
    });

    test('endOfDay has 23:59:59', () {
      final d = DateTime.now().endOfDay;
      expect(d.hour, 23);
      expect(d.minute, 59);
    });
  });

  group('DateFormatHelper & format() extension v0.1.0', () {
    final date = DateTime(2024, 6, 15, 14, 30, 45);
    final midnight = DateTime(2024, 6, 15, 0, 0, 0);

    test('dd-MM-yyyy', () {
      expect(date.format('dd-MM-yyyy'), '15-06-2024');
    });

    test('MM/dd/yyyy', () {
      expect(date.format('MM/dd/yyyy'), '06/15/2024');
    });

    test('MMM dd, yyyy', () {
      expect(date.format('MMM dd, yyyy'), 'Jun 15, 2024');
    });

    test('MMMM', () {
      expect(date.format('MMMM'), 'June');
    });

    test('EEEE', () {
      expect(date.format('EEEE'), 'Saturday');
    });

    test('EEE', () {
      expect(date.format('EEE'), 'Sat');
    });

    test('yy', () {
      expect(date.format('yy'), '24');
    });

    test('HH:mm:ss — 24 hour', () {
      expect(date.format('HH:mm:ss'), '14:30:45');
    });

    test('hh:mm a — 12 hour PM', () {
      expect(date.format('hh:mm a'), '02:30 PM');
    });

    test('hh:mm a — 12 hour midnight', () {
      expect(midnight.format('hh:mm a'), '12:00 AM');
    });

    test('toReadable', () {
      expect(date.toReadable, 'Saturday, 15 June 2024');
    });

    test('toISO', () {
      expect(date.toISO, '2024-06-15T14:30:45');
    });

    test('toTimeString', () {
      expect(date.toTimeString, '14:30:45');
    });

    test('to12Hour', () {
      expect(date.to12Hour, '02:30 PM');
    });

    test('to24Hour', () {
      expect(date.to24Hour, '14:30');
    });
  });

  group('Date Calculations & Range v0.5.0', () {
    final june15 = DateTime(2024, 6, 15); // Saturday

    test('daysUntil — future', () {
      final future = june15.add(const Duration(days: 10));
      expect(june15.daysUntil(future), 10);
    });

    test('daysUntil — past', () {
      final past = june15.subtract(const Duration(days: 5));
      expect(june15.daysUntil(past), -5);
    });

    test('daysSince', () {
      final past = june15.subtract(const Duration(days: 7));
      expect(june15.daysSince(past), 7);
    });

    test('isBetween — inside range', () {
      final start = june15.subtract(const Duration(days: 3));
      final end = june15.add(const Duration(days: 3));
      expect(june15.isBetween(start, end), true);
    });

    test('isBetween — outside range', () {
      final start = june15.add(const Duration(days: 1));
      final end = june15.add(const Duration(days: 5));
      expect(june15.isBetween(start, end), false);
    });

    test('isBetween — on boundary', () {
      expect(june15.isBetween(june15, june15), true);
    });

    test('addWorkingDays — skips weekend', () {
      // Friday June 14 + 1 working day = Monday June 17
      final friday = DateTime(2024, 6, 14);
      final result = friday.addWorkingDays(1);
      expect(result.weekday, DateTime.monday);
    });

    test('addWorkingDays — 5 days', () {
      // Friday June 14 + 5 working days = Friday June 21
      final friday = DateTime(2024, 6, 14);
      final result = friday.addWorkingDays(5);
      expect(result, DateTime(2024, 6, 21));
    });

    test('isWeekend — Saturday', () {
      expect(DateTime(2024, 6, 22).isWeekend, true); // actual Saturday
    });

    test('isWeekday — Wednesday', () {
      final actualWednesday = DateTime(2024, 6, 12); // real Wednesday
      expect(actualWednesday.isWeekday, true);
    });

    test('age calculation', () {
      final birthDate = DateTime(
          DateTime.now().year - 25, DateTime.now().month, DateTime.now().day);
      expect(birthDate.age, 25);
    });

    test('startOfWeek — Monday', () {
      // Saturday June 15 → Monday June 10
      expect(june15.startOfWeek, DateTime(2024, 6, 10));
    });

    test('endOfWeek — Sunday', () {
      expect(june15.endOfWeek.weekday, DateTime.sunday);
    });

    test('startOfMonth', () {
      expect(june15.startOfMonth, DateTime(2024, 6, 1));
    });

    test('endOfMonth — June has 30 days', () {
      expect(june15.endOfMonth.day, 30);
    });

    test('startOfYear', () {
      expect(june15.startOfYear, DateTime(2024, 1, 1));
    });

    test('endOfYear', () {
      expect(june15.endOfYear.month, 12);
      expect(june15.endOfYear.day, 31);
    });

    test('workingDaysUntil', () {
      final monday = DateTime(2024, 6, 10);
      final friday = DateTime(2024, 6, 14);
      expect(monday.workingDaysUntil(friday), 4);
    });
  });
}
