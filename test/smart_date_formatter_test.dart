import 'package:flutter/material.dart';
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

  group('Localization — SdfLocale v0.9.0', () {
    final date = DateTime(2024, 6, 15, 14, 30, 0);
    final now = DateTime(2024, 6, 15, 16, 30, 0); // 2 hours later

    test('English — default', () {
      const f = SmartDateFormatter();
      expect(f.format(date, now: now), '2 hours ago');
    });

    test('Hindi — 2 ghante pehle', () {
      const f = SmartDateFormatter(locale: SdfLocale.hi);
      expect(f.format(date, now: now), '2 घंटे पहले');
    });

    test('Spanish — horas atrás', () {
      const f = SmartDateFormatter(locale: SdfLocale.es);
      expect(f.format(date, now: now), '2 horas atrás');
    });

    test('French — heures', () {
      const f = SmartDateFormatter(locale: SdfLocale.fr);
      expect(f.format(date, now: now), contains('heures'));
    });

    test('Japanese — 時間前', () {
      const f = SmartDateFormatter(locale: SdfLocale.ja);
      expect(f.format(date, now: now), '2 時間前');
    });

    test('Arabic — ساعات مضت', () {
      const f = SmartDateFormatter(locale: SdfLocale.ar);
      expect(f.format(date, now: now), contains('ساعات مضت'));
    });

    test('SdfLocale.fromCode hi', () {
      expect(SdfLocale.fromCode('hi').code, 'hi');
    });

    test('SdfLocale.fromCode unknown falls back to en', () {
      expect(SdfLocale.fromCode('xyz').code, 'en');
    });

    test('timeAgoIn extension', () {
      expect(
        const SmartDateFormatter(locale: SdfLocale.hi).format(date, now: now),
        contains('घंटे'),
      );
    });

    test('supported locales list', () {
      expect(SdfLocale.supported,
          containsAll(['en', 'hi', 'es', 'fr', 'ja', 'ar']));
    });
  });

  group('SmartParser v0.9.0', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0); // Saturday

    test('today', () {
      expect(SmartParser.parse('today', now: now), DateTime(2024, 6, 15));
    });

    test('tomorrow', () {
      expect(SmartParser.parse('tomorrow', now: now), DateTime(2024, 6, 16));
    });

    test('yesterday', () {
      expect(SmartParser.parse('yesterday', now: now), DateTime(2024, 6, 14));
    });

    test('in 3 days', () {
      expect(SmartParser.parse('in 3 days', now: now), DateTime(2024, 6, 18));
    });

    test('in 2 weeks', () {
      expect(SmartParser.parse('in 2 weeks', now: now), DateTime(2024, 6, 29));
    });

    test('in 1 month', () {
      expect(SmartParser.parse('in 1 month', now: now), DateTime(2024, 7, 15));
    });

    test('3 days ago', () {
      expect(SmartParser.parse('3 days ago', now: now), DateTime(2024, 6, 12));
    });

    test('2 weeks ago', () {
      expect(SmartParser.parse('2 weeks ago', now: now), DateTime(2024, 6, 1));
    });

    test('next monday', () {
      final result = SmartParser.parse('next monday', now: now);
      expect(result?.weekday, DateTime.monday);
    });

    test('last friday', () {
      final result = SmartParser.parse('last friday', now: now);
      expect(result?.weekday, DateTime.friday);
    });

    test('next week', () {
      expect(SmartParser.parse('next week', now: now), DateTime(2024, 6, 22));
    });

    test('last week', () {
      expect(SmartParser.parse('last week', now: now), DateTime(2024, 6, 8));
    });

    test('next month', () {
      expect(SmartParser.parse('next month', now: now), DateTime(2024, 7, 15));
    });

    test('last year', () {
      expect(SmartParser.parse('last year', now: now), DateTime(2023, 6, 15));
    });

    test('invalid returns null', () {
      expect(SmartParser.parse('blah blah', now: now), null);
    });

    test('canParse — valid', () {
      expect(SmartParser.canParse('tomorrow'), true);
    });

    test('canParse — invalid', () {
      expect(SmartParser.canParse('random text'), false);
    });

    test('parseOrThrow — throws on invalid', () {
      expect(
        () => SmartParser.parseOrThrow('invalid', now: now),
        throwsA(isA<FormatException>()),
      );
    });

    test('standard date string fallback', () {
      expect(
        SmartParser.parse('2024-01-15', now: now),
        DateTime(2024, 1, 15),
      );
    });
  });

  group('DateRange & DateRangeHelper v1.0.0', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0); // Saturday

    test('today range contains today', () {
      final range = DateRangeHelper.today(now: now);
      expect(range.contains(now), true);
    });

    test('today range does not contain tomorrow', () {
      final range = DateRangeHelper.today(now: now);
      expect(range.contains(now.add(const Duration(days: 1))), false);
    });

    test('yesterday range', () {
      final range = DateRangeHelper.yesterday(now: now);
      expect(range.start.day, 14);
      expect(range.end.day, 14);
    });

    test('thisWeek contains today', () {
      final range = DateRangeHelper.thisWeek(now: now);
      expect(range.contains(now), true);
    });

    test('thisWeek starts on Monday', () {
      final range = DateRangeHelper.thisWeek(now: now);
      expect(range.start.weekday, DateTime.monday);
    });

    test('thisWeek ends on Sunday', () {
      final range = DateRangeHelper.thisWeek(now: now);
      expect(range.end.weekday, DateTime.sunday);
    });

    test('thisMonth starts on 1st', () {
      final range = DateRangeHelper.thisMonth(now: now);
      expect(range.start.day, 1);
    });

    test('thisMonth ends on 30th for June', () {
      final range = DateRangeHelper.thisMonth(now: now);
      expect(range.end.day, 30);
    });

    test('lastNDays — 7 days', () {
      final range = DateRangeHelper.lastNDays(7, now: now);
      expect(range.days, 7);
    });

    test('lastNDays — 30 days', () {
      final range = DateRangeHelper.lastNDays(30, now: now);
      expect(range.days, 30);
    });

    test('nextNDays — 7 days', () {
      final range = DateRangeHelper.nextNDays(7, now: now);
      expect(range.days, 7);
    });

    test('custom range', () {
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 12, 31);
      final range = DateRangeHelper.custom(start, end);
      expect(range.contains(DateTime(2024, 6, 15)), true);
      expect(range.contains(DateTime(2025, 1, 1)), false);
    });

    test('quarter Q1', () {
      final range = DateRangeHelper.quarter(1, now: now);
      expect(range.start.month, 1);
      expect(range.end.month, 3);
    });

    test('quarter Q2', () {
      final range = DateRangeHelper.quarter(2, now: now);
      expect(range.start.month, 4);
      expect(range.end.month, 6);
    });

    test('currentQuarter for June = Q2', () {
      final range = DateRangeHelper.currentQuarter(now: now);
      expect(range.start.month, 4);
    });

    test('thisYear starts Jan 1', () {
      final range = DateRangeHelper.thisYear(now: now);
      expect(range.start, DateTime(2024, 1, 1));
    });

    test('DateRange.overlaps', () {
      final r1 =
          DateRangeHelper.custom(DateTime(2024, 1, 1), DateTime(2024, 6, 30));
      final r2 =
          DateRangeHelper.custom(DateTime(2024, 6, 1), DateTime(2024, 12, 31));
      expect(r1.overlaps(r2), true);
    });

    test('DateRange.days count', () {
      final range =
          DateRangeHelper.custom(DateTime(2024, 6, 1), DateTime(2024, 6, 7));
      expect(range.days, 7);
    });
  });

  group('Extensions v1.1.0', () {
    final june15 = DateTime(2024, 6, 15, 14, 30); // Saturday, Q2
    final jan1 = DateTime(2024, 1, 1); // Monday, Q1
    final dec31 = DateTime(2024, 12, 31); // Tuesday, Q4

    // ── Quarter ────────────────────────────────
    test('quarter — June is Q2', () {
      expect(june15.quarter, 2);
    });

    test('quarter — January is Q1', () {
      expect(jan1.quarter, 1);
    });

    test('quarter — December is Q4', () {
      expect(dec31.quarter, 4);
    });

    test('isQ2 — June', () {
      expect(june15.isQ2, true);
      expect(june15.isQ1, false);
    });

    // ── Week & Day of Year ─────────────────────
    test('dayOfYear — Jan 1 = 1', () {
      expect(jan1.dayOfYear, 1);
    });

    test('dayOfYear — Dec 31 leap year = 366', () {
      expect(dec31.dayOfYear, 366); // 2024 is leap year
    });

    test('weekOfYear — Jan 1', () {
      expect(jan1.weekOfYear, 1);
    });

    // ── Leap Year ──────────────────────────────
    test('isLeapYear — 2024 is leap', () {
      expect(DateTime(2024, 1, 1).isLeapYear, true);
    });

    test('isLeapYear — 2023 is not leap', () {
      expect(DateTime(2023, 1, 1).isLeapYear, false);
    });

    test('isLeapYear — 2000 is leap', () {
      expect(DateTime(2000, 1, 1).isLeapYear, true);
    });

    test('isLeapYear — 1900 is not leap', () {
      expect(DateTime(1900, 1, 1).isLeapYear, false);
    });

    // ── Time of Day ────────────────────────────
    test('isMorning — 9AM', () {
      expect(DateTime(2024, 6, 15, 9, 0).isMorning, true);
    });

    test('isAfternoon — 2PM', () {
      expect(DateTime(2024, 6, 15, 14, 0).isAfternoon, true);
    });

    test('isEvening — 6PM', () {
      expect(DateTime(2024, 6, 15, 18, 0).isEvening, true);
    });

    test('isNight — 10PM', () {
      expect(DateTime(2024, 6, 15, 22, 0).isNight, true);
    });

    test('isNight — 3AM', () {
      expect(DateTime(2024, 6, 15, 3, 0).isNight, true);
    });

    test('isMorning — 2PM is not morning', () {
      expect(DateTime(2024, 6, 15, 14, 0).isMorning, false);
    });

    // ── isSameDay/Week/Month/Year ──────────────
    test('isSameDay — same date different time', () {
      expect(
        DateTime(2024, 6, 15, 9, 0).isSameDay(DateTime(2024, 6, 15, 22, 0)),
        true,
      );
    });

    test('isSameDay — different dates', () {
      expect(
        DateTime(2024, 6, 15).isSameDay(DateTime(2024, 6, 16)),
        false,
      );
    });

    test('isSameWeek — same week', () {
      // Monday Jun 10 and Saturday Jun 15 — same week
      expect(
        DateTime(2024, 6, 10).isSameWeek(DateTime(2024, 6, 15)),
        true,
      );
    });

    test('isSameWeek — different weeks', () {
      expect(
        DateTime(2024, 6, 10).isSameWeek(DateTime(2024, 6, 17)),
        false,
      );
    });

    test('isSameMonth — same month', () {
      expect(
        DateTime(2024, 6, 1).isSameMonth(DateTime(2024, 6, 30)),
        true,
      );
    });

    test('isSameMonth — different months', () {
      expect(
        DateTime(2024, 6, 1).isSameMonth(DateTime(2024, 7, 1)),
        false,
      );
    });

    test('isSameYear — same year', () {
      expect(jan1.isSameYear(dec31), true);
    });

    test('isSameYear — different years', () {
      expect(
        DateTime(2024, 1, 1).isSameYear(DateTime(2023, 1, 1)),
        false,
      );
    });

    // ── Next / Previous Weekday ────────────────
    test('nextMonday from Saturday Jun 15', () {
      // Jun 15 is Saturday → next Monday is Jun 17
      expect(june15.nextMonday, DateTime(2024, 6, 17));
    });

    test('nextFriday from Saturday Jun 15', () {
      // Jun 15 is Saturday → next Friday is Jun 21
      expect(june15.nextFriday, DateTime(2024, 6, 21));
    });

    test('nextSunday from Saturday Jun 15', () {
      // Jun 15 is Saturday → next Sunday is Jun 16
      expect(june15.nextSunday, DateTime(2024, 6, 16));
    });

    test('previousMonday from Saturday Jun 15', () {
      // Jun 15 Saturday → previous Monday Jun 10
      expect(june15.previousMonday, DateTime(2024, 6, 10));
    });

    test('previousFriday from Saturday Jun 15', () {
      // Jun 15 Saturday → previous Friday Jun 14
      expect(june15.previousFriday, DateTime(2024, 6, 14));
    });

    // ── copyWith ───────────────────────────────
    test('copyWith — change hour', () {
      final result = june15.copyWith(hour: 0, minute: 0, second: 0);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.day, 15); // day unchanged
    });

    test('copyWith — change day', () {
      final result = june15.copyWith(day: 1);
      expect(result.day, 1);
      expect(result.month, 6); // month unchanged
    });

    test('copyWith — change month and year', () {
      final result = june15.copyWith(year: 2025, month: 1);
      expect(result.year, 2025);
      expect(result.month, 1);
      expect(result.day, 15); // day unchanged
    });
  });

  group('Localization v1.2.0 — New Languages', () {
    final date2h = DateTime(2024, 6, 15, 14, 30);
    final now = DateTime(2024, 6, 15, 16, 30);

    test('German — Stunden her', () {
      const f = SmartDateFormatter(locale: SdfLocale.de);
      expect(f.format(date2h, now: now), '2 Stunden her');
    });

    test('Russian — часов назад', () {
      const f = SmartDateFormatter(locale: SdfLocale.ru);
      expect(f.format(date2h, now: now), contains('назад'));
    });

    test('Chinese — 小时前', () {
      const f = SmartDateFormatter(locale: SdfLocale.zh);
      expect(f.format(date2h, now: now), '2 小时前');
    });

    test('Marathi — तास पूर्वी', () {
      const f = SmartDateFormatter(locale: SdfLocale.mr);
      expect(f.format(date2h, now: now), contains('तास'));
    });

    test('Gujarati — કલાક પહેલાં', () {
      const f = SmartDateFormatter(locale: SdfLocale.gu);
      expect(f.format(date2h, now: now), contains('કલાક'));
    });

    test('Bengali — ঘন্টা আগে', () {
      const f = SmartDateFormatter(locale: SdfLocale.bn);
      expect(f.format(date2h, now: now), contains('ঘন্টা'));
    });

    test('Tamil — மணி நேரம் முன்பு', () {
      const f = SmartDateFormatter(locale: SdfLocale.ta);
      expect(f.format(date2h, now: now), contains('மணி'));
    });

    test('Telugu — గంటలు క్రితం', () {
      const f = SmartDateFormatter(locale: SdfLocale.te);
      expect(f.format(date2h, now: now), contains('గంట'));
    });

    test('Kannada — ಗಂಟೆಗಳ ಹಿಂದೆ', () {
      const f = SmartDateFormatter(locale: SdfLocale.kn);
      expect(f.format(date2h, now: now), contains('ಗಂಟೆ'));
    });

    test('Punjabi — ਘੰਟੇ ਪਹਿਲਾਂ', () {
      const f = SmartDateFormatter(locale: SdfLocale.pa);
      expect(f.format(date2h, now: now), contains('ਘੰਟ'));
    });

    test('fromCode de', () {
      expect(SdfLocale.fromCode('de').code, 'de');
    });

    test('fromCode mr', () {
      expect(SdfLocale.fromCode('mr').code, 'mr');
    });

    test('fromCode bn', () {
      expect(SdfLocale.fromCode('bn').code, 'bn');
    });

    test('supported list has 16 locales', () {
      expect(SdfLocale.supported.length, 16);
    });

    test('timeAgoIn Gujarati', () {
      expect(
        const SmartDateFormatter(locale: SdfLocale.gu).format(date2h, now: now),
        contains('કલાક'),
      );
    });
  });

  group('Widgets v1.3.0', () {
    testWidgets('DateBadge — today shows TODAY', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateBadge(date: DateTime.now()),
          ),
        ),
      );
    });

    testWidgets('DateBadge chip style — today', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateBadge(
              date: DateTime.now(),
              style: DateBadgeStyle.chip,
            ),
          ),
        ),
      );
      expect(find.textContaining('TODAY'), findsOneWidget);
    });

    testWidgets('DateBadge outlined — tomorrow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateBadge(
              date: DateTime.now().add(const Duration(days: 1)),
              style: DateBadgeStyle.outlined,
            ),
          ),
        ),
      );
      expect(find.textContaining('TOMORROW'), findsOneWidget);
    });

    testWidgets('DateBadge flat — yesterday', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateBadge(
              date: DateTime.now().subtract(const Duration(days: 1)),
              style: DateBadgeStyle.flat,
            ),
          ),
        ),
      );
      expect(find.textContaining('YESTERDAY'), findsOneWidget);
    });

    testWidgets('DateBadge custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateBadge(
              date: DateTime.now(),
              label: 'NEW',
            ),
          ),
        ),
      );
    });

    testWidgets('SmartDateText — timeAgo mode', (tester) async {
      final date = DateTime.now().subtract(const Duration(hours: 2));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartDateText(
              date: date,
              mode: SmartDateMode.timeAgo,
            ),
          ),
        ),
      );
      expect(find.textContaining('hours ago'), findsOneWidget);
    });

    testWidgets('SmartDateText — calendar mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartDateText(
              date: DateTime.now(),
              mode: SmartDateMode.calendar,
            ),
          ),
        ),
      );
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('SmartDateText — custom mode', (tester) async {
      final date = DateTime(2024, 6, 15);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartDateText(
              date: date,
              mode: SmartDateMode.custom,
              pattern: 'dd-MM-yyyy',
            ),
          ),
        ),
      );
      expect(find.text('15-06-2024'), findsOneWidget);
    });

    testWidgets('SmartDateText — auto mode recent date uses timeAgo',
        (tester) async {
      final date = DateTime.now().subtract(const Duration(hours: 2));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartDateText(
              date: date,
              mode: SmartDateMode.auto,
            ),
          ),
        ),
      );
      expect(find.textContaining('ago'), findsOneWidget);
    });

    testWidgets('SmartDateText — prefix and suffix', (tester) async {
      final date = DateTime.now().subtract(const Duration(hours: 1));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartDateText(
              date: date,
              mode: SmartDateMode.timeAgo,
              prefix: 'Posted ',
              suffix: ' ✓',
            ),
          ),
        ),
      );
      expect(find.textContaining('Posted'), findsOneWidget);
      expect(find.textContaining('✓'), findsOneWidget);
    });

    testWidgets('RelativeDateBuilder — provides timeAgo', (tester) async {
      final date = DateTime.now().subtract(const Duration(hours: 3));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelativeDateBuilder(
              date: date,
              builder: (ctx, timeAgo, calendar, timestamp, d) => Text(timeAgo),
            ),
          ),
        ),
      );
      expect(find.textContaining('hours ago'), findsOneWidget);
    });

    testWidgets('RelativeDateBuilder — provides calendar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelativeDateBuilder(
              date: DateTime.now(),
              builder: (ctx, timeAgo, calendar, timestamp, d) => Text(calendar),
            ),
          ),
        ),
      );
      expect(find.text('Today'), findsOneWidget);
    });
  });

  group('HolidayHelper v1.4.0', () {
    final christmas = DateTime(2024, 12, 25);
    final republicDay = DateTime(2024, 1, 26);
    final monday = DateTime(2024, 6, 17);
    final saturday = DateTime(2024, 6, 22);

    final holidays = [christmas, republicDay];

    test('isHoliday — christmas is holiday', () {
      expect(
        HolidayHelper.isHoliday(christmas, holidays: holidays),
        true,
      );
    });

    test('isHoliday — random day is not holiday', () {
      expect(
        HolidayHelper.isHoliday(monday, holidays: holidays),
        false,
      );
    });

    test('isWorkingDay — Monday is working day', () {
      expect(
        HolidayHelper.isWorkingDay(monday, holidays: holidays),
        true,
      );
    });

    test('isWorkingDay — Saturday is not working day', () {
      expect(
        HolidayHelper.isWorkingDay(saturday, holidays: holidays),
        false,
      );
    });

    test('isWorkingDay — Christmas is not working day', () {
      expect(
        HolidayHelper.isWorkingDay(christmas, holidays: holidays),
        false,
      );
    });

    test('addWorkingDays — skips Christmas', () {
      // Dec 23 (Mon) + 3 working days skipping Christmas (Wed)
      // Dec 23 → Dec 24 (Tue) → skip Dec 25 (Christmas)
      // → Dec 26 (Thu) → Dec 27 (Fri) = 3 days
      final dec23 = DateTime(2024, 12, 23);
      final result =
          HolidayHelper.addWorkingDays(dec23, 3, holidays: [christmas]);
      expect(result, DateTime(2024, 12, 27));
    });

    test('addWorkingDays — no holidays', () {
      // Monday + 5 = next Monday (skip weekend)
      final result = HolidayHelper.addWorkingDays(monday, 5, holidays: []);
      expect(result, DateTime(2024, 6, 24));
    });

    test('workingDaysBetween — skips holiday', () {
      // Dec 23 to Dec 27 = Mon, Tue, (skip Wed Christmas), Thu, Fri = 4
      final dec23 = DateTime(2024, 12, 23);
      final dec27 = DateTime(2024, 12, 27);
      expect(
        HolidayHelper.workingDaysBetween(dec23, dec27, holidays: [christmas]),
        3,
      );
    });

    test('nextWorkingDay — skips Christmas', () {
      // Dec 24 (Tue) next working day skipping Christmas = Dec 26
      final dec24 = DateTime(2024, 12, 24);
      final result = HolidayHelper.nextWorkingDay(dec24, holidays: [christmas]);
      expect(result, DateTime(2024, 12, 26));
    });

    test('holidaysInYear — filters by year', () {
      final allHolidays = [
        DateTime(2024, 12, 25),
        DateTime(2023, 12, 25),
        DateTime(2024, 1, 26),
      ];
      expect(
        HolidayHelper.holidaysInYear(2024, holidays: allHolidays).length,
        2,
      );
    });

    test('indianHolidays — has 8 holidays', () {
      expect(HolidayHelper.indianHolidays(2024).length, 8);
    });

    // Extension tests
    test('isHoliday extension', () {
      expect(christmas.isHoliday(holidays: holidays), true);
    });

    test('isWorkingDay extension — Monday', () {
      expect(monday.isWorkingDay(), true);
    });

    test('addWorkingDaysWithHolidays extension', () {
      final dec23 = DateTime(2024, 12, 23);
      final result = dec23.addWorkingDaysWithHolidays(3, holidays: [christmas]);
      expect(result, DateTime(2024, 12, 27));
    });
  });

  group('RecurrenceHelper v1.4.0', () {
    final start = DateTime(2024, 6, 3); // Monday

    test('daily — count 5', () {
      final dates = RecurrenceHelper.daily(start: start, count: 5);
      expect(dates.length, 5);
      expect(dates.first, start);
      expect(dates.last, DateTime(2024, 6, 7));
    });

    test('daily — skip weekends', () {
      final dates =
          RecurrenceHelper.daily(start: start, count: 5, skipWeekends: true);
      // Mon, Tue, Wed, Thu, Fri — no weekends
      expect(
          dates.every((d) =>
              d.weekday != DateTime.saturday && d.weekday != DateTime.sunday),
          true);
    });

    test('daily — until date', () {
      final dates = RecurrenceHelper.daily(
        start: start,
        until: DateTime(2024, 6, 7),
      );
      expect(dates.last.isBefore(DateTime(2024, 6, 8)), true);
    });

    test('weekly — count 4', () {
      final dates = RecurrenceHelper.weekly(start: start, count: 4);
      expect(dates.length, 4);
      // Each 7 days apart
      expect(dates[1].difference(dates[0]).inDays, 7);
    });

    test('monthly — count 3', () {
      final dates =
          RecurrenceHelper.monthly(start: DateTime(2024, 1, 15), count: 3);
      expect(dates.length, 3);
      expect(dates[0].month, 1);
      expect(dates[1].month, 2);
      expect(dates[2].month, 3);
    });

    test('yearly — count 3', () {
      final dates = RecurrenceHelper.yearly(start: start, count: 3);
      expect(dates.length, 3);
      expect(dates[0].year, 2024);
      expect(dates[1].year, 2025);
      expect(dates[2].year, 2026);
    });

    test('nextOccurrence — daily', () {
      expect(
        RecurrenceHelper.nextOccurrence(start, RecurrenceFrequency.daily),
        DateTime(2024, 6, 4),
      );
    });

    test('nextOccurrence — weekly', () {
      expect(
        RecurrenceHelper.nextOccurrence(start, RecurrenceFrequency.weekly),
        DateTime(2024, 6, 10),
      );
    });

    test('nextOccurrence — monthly', () {
      expect(
        RecurrenceHelper.nextOccurrence(start, RecurrenceFrequency.monthly),
        DateTime(2024, 7, 3),
      );
    });

    test('nextOccurrence — yearly', () {
      expect(
        RecurrenceHelper.nextOccurrence(start, RecurrenceFrequency.yearly),
        DateTime(2025, 6, 3),
      );
    });

    test('skip holidays in recurrence', () {
      final holiday = DateTime(2024, 6, 4); // Tuesday
      final dates = RecurrenceHelper.daily(
        start: start,
        count: 3,
        skipHolidays: [holiday],
      );
      expect(dates.contains(holiday), false);
    });

    test('assert — count and until both null throws', () {
      expect(
        () => RecurrenceHelper.generate(
          start: start,
          frequency: RecurrenceFrequency.daily,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('StreakCalculator v1.5.0', () {
    final dates = [
      DateTime(2024, 6, 10),
      DateTime(2024, 6, 11),
      DateTime(2024, 6, 12),
      DateTime(2024, 6, 14), // gap on 13th
      DateTime(2024, 6, 15),
    ];

    test('longestStreak — 3 days', () {
      expect(StreakCalculator.longestStreak(dates), 3);
    });

    test('totalCompleted', () {
      expect(StreakCalculator.totalCompleted(dates), 5);
    });

    test('allStreaks — 2 streaks', () {
      final streaks = StreakCalculator.allStreaks(dates);
      expect(streaks.length, 2);
      expect(streaks[0].length, 3);
      expect(streaks[1].length, 2);
    });

    test('lastCompletedDate', () {
      expect(
        StreakCalculator.lastCompletedDate(dates),
        DateTime(2024, 6, 15),
      );
    });

    test('lastCompletedDate — empty returns null', () {
      expect(StreakCalculator.lastCompletedDate([]), null);
    });

    test('isTodayCompleted — false for old dates', () {
      expect(StreakCalculator.isTodayCompleted(dates), false);
    });

    test('isTodayCompleted — true when today included', () {
      expect(
        StreakCalculator.isTodayCompleted([DateTime.now()]),
        true,
      );
    });

    test('completionRate — 5 out of 6 days', () {
      final rate = StreakCalculator.completionRate(
        dates,
        start: DateTime(2024, 6, 10),
        end: DateTime(2024, 6, 15),
      );
      expect(rate, closeTo(0.833, 0.01));
    });

    test('currentStreak — 0 for old dates', () {
      expect(StreakCalculator.currentStreak(dates), 0);
    });

    test('currentStreak — active streak', () {
      final today = DateTime.now();
      final activeDates = [
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 1)),
        today,
      ];
      expect(StreakCalculator.currentStreak(activeDates), 3);
    });
  });

  group('DateGrouper v1.5.0', () {
    final dates = [
      DateTime(2024, 6, 1, 9, 0),
      DateTime(2024, 6, 1, 14, 0),
      DateTime(2024, 6, 2, 10, 0),
      DateTime(2024, 6, 8, 11, 0),
      DateTime(2024, 7, 1, 9, 0),
    ];

    test('byDay — groups correctly', () {
      final grouped = DateGrouper.byDay(dates);
      expect(grouped['2024-06-01']?.length, 2);
      expect(grouped['2024-06-02']?.length, 1);
    });

    test('byMonth — groups correctly', () {
      final grouped = DateGrouper.byMonth(dates);
      expect(grouped['2024-06']?.length, 4);
      expect(grouped['2024-07']?.length, 1);
    });

    test('byYear — groups correctly', () {
      final grouped = DateGrouper.byYear(dates);
      expect(grouped['2024']?.length, 5);
    });

    test('byQuarter — groups correctly', () {
      final grouped = DateGrouper.byQuarter(dates);
      expect(grouped['2024-Q2']?.length, 4); // Jun dates only
      expect(grouped['2024-Q3']?.length, 1); // Jul 1 only
    });

    test('byWeekday — groups correctly', () {
      final grouped = DateGrouper.byWeekday(dates);
      // June 1 2024 is Saturday
      expect(grouped.containsKey('Saturday'), true);
    });

    test('byHour — groups correctly', () {
      final grouped = DateGrouper.byHour(dates);
      expect(grouped['09']?.length, 2);
      expect(grouped['14']?.length, 1);
    });

    test('countByDay', () {
      final counts = DateGrouper.countByDay(dates);
      expect(counts['2024-06-01'], 2);
    });

    test('countByMonth', () {
      final counts = DateGrouper.countByMonth(dates);
      expect(counts['2024-06'], 4);
    });

    test('mostActiveDay', () {
      expect(DateGrouper.mostActiveDay(dates), '2024-06-01');
    });

    test('mostActiveWeekday', () {
      final result = DateGrouper.mostActiveWeekday(dates);
      expect(result, isNotNull);
    });

    test('mostActiveHour', () {
      expect(DateGrouper.mostActiveHour(dates), 9);
    });

    test('averageGap — not null', () {
      expect(DateGrouper.averageGap(dates), isNotNull);
    });

    test('averageGap — single date returns null', () {
      expect(DateGrouper.averageGap([DateTime.now()]), null);
    });

    test('mostActiveDay — empty returns null', () {
      expect(DateGrouper.mostActiveDay([]), null);
    });

    test('byWeek — groups correctly', () {
      final grouped = DateGrouper.byWeek(dates);
      expect(grouped.isNotEmpty, true);
    });
  });

  group('SmartParser v1.6.0 — New English Expressions', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0); // Saturday

    test('midnight', () {
      final result = SmartParser.parse('midnight', now: now);
      expect(result?.hour, 0);
      expect(result?.minute, 0);
    });

    test('noon', () {
      final result = SmartParser.parse('noon', now: now);
      expect(result?.hour, 12);
    });

    test('end of month', () {
      final result = SmartParser.parse('end of month', now: now);
      expect(result?.month, 6);
      expect(result?.day, 30);
    });

    test('start of month', () {
      final result = SmartParser.parse('start of month', now: now);
      expect(result?.day, 1);
    });

    test('end of year', () {
      final result = SmartParser.parse('end of year', now: now);
      expect(result?.month, 12);
      expect(result?.day, 31);
    });

    test('start of year', () {
      final result = SmartParser.parse('start of year', now: now);
      expect(result?.month, 1);
      expect(result?.day, 1);
    });

    test('day after tomorrow', () {
      final result = SmartParser.parse('day after tomorrow', now: now);
      expect(result, DateTime(2024, 6, 17));
    });

    test('day before yesterday', () {
      final result = SmartParser.parse('day before yesterday', now: now);
      expect(result, DateTime(2024, 6, 13));
    });

    test('this weekend — Saturday', () {
      final result = SmartParser.parse('this weekend', now: now);
      expect(result?.weekday, DateTime.saturday);
    });

    test('a day ago', () {
      final result = SmartParser.parse('a day ago', now: now);
      expect(result, DateTime(2024, 6, 14));
    });

    test('in a week', () {
      final result = SmartParser.parse('in a week', now: now);
      expect(result, DateTime(2024, 6, 22));
    });

    test('3 weeks from now', () {
      final result = SmartParser.parse('3 weeks from now', now: now);
      expect(result, DateTime(2024, 7, 6));
    });

    test('2 days from now', () {
      final result = SmartParser.parse('2 days from now', now: now);
      expect(result, DateTime(2024, 6, 17));
    });
  });

  group('SmartParser v1.6.0 — Hindi Parsing', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0);

    test('आज — today', () {
      expect(SmartParser.parse('आज', now: now), DateTime(2024, 6, 15));
    });

    test('कल — tomorrow', () {
      expect(SmartParser.parse('कल', now: now), DateTime(2024, 6, 16));
    });

    test('परसों — day after tomorrow', () {
      expect(SmartParser.parse('परसों', now: now), DateTime(2024, 6, 17));
    });

    test('अगले हफ्ते — next week', () {
      final result = SmartParser.parse('अगले हफ्ते', now: now);
      expect(result, DateTime(2024, 6, 22));
    });

    test('पिछले हफ्ते — last week', () {
      final result = SmartParser.parse('पिछले हफ्ते', now: now);
      expect(result, DateTime(2024, 6, 8));
    });

    test('अगले महीने — next month', () {
      final result = SmartParser.parse('अगले महीने', now: now);
      expect(result?.month, 7);
    });

    test('पिछले साल — last year', () {
      final result = SmartParser.parse('पिछले साल', now: now);
      expect(result?.year, 2023);
    });

    test('अगले सोमवार — next monday', () {
      final result = SmartParser.parse('अगले सोमवार', now: now);
      expect(result?.weekday, DateTime.monday);
    });

    test('3 दिन बाद — in 3 days', () {
      final result = SmartParser.parse('3 दिन बाद', now: now);
      expect(result, DateTime(2024, 6, 18));
    });

    test('5 दिन पहले — 5 days ago', () {
      final result = SmartParser.parse('5 दिन पहले', now: now);
      expect(result, DateTime(2024, 6, 10));
    });

    test('canParse — आज', () {
      expect(SmartParser.canParse('आज'), true);
    });

    test('parseLocale — Hindi', () {
      final result = SmartParser.parseLocale(
        'अगले सोमवार',
        locale: SdfLocale.hi,
        now: now,
      );
      expect(result?.weekday, DateTime.monday);
    });
  });

  group('SmartParser v1.6.0 — Marathi Parsing', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0);

    test('आज — today', () {
      expect(SmartParser.parse('आज', now: now), DateTime(2024, 6, 15));
    });

    test('उद्या — tomorrow', () {
      expect(SmartParser.parse('उद्या', now: now), DateTime(2024, 6, 16));
    });

    test('काल — yesterday', () {
      expect(SmartParser.parse('काल', now: now), DateTime(2024, 6, 14));
    });

    test('परवा — day after tomorrow', () {
      expect(SmartParser.parse('परवा', now: now), DateTime(2024, 6, 17));
    });

    test('पुढील आठवडा — next week', () {
      final result = SmartParser.parse('पुढील आठवडा', now: now);
      expect(result, DateTime(2024, 6, 22));
    });

    test('मागील आठवडा — last week', () {
      final result = SmartParser.parse('मागील आठवडा', now: now);
      expect(result, DateTime(2024, 6, 8));
    });

    test('पुढील महिना — next month', () {
      final result = SmartParser.parse('पुढील महिना', now: now);
      expect(result?.month, 7);
    });

    test('3 दिवसांनी — in 3 days', () {
      final result = SmartParser.parse('3 दिवसांनी', now: now);
      expect(result, DateTime(2024, 6, 18));
    });

    test('5 दिवसांपूर्वी — 5 days ago', () {
      final result = SmartParser.parse('5 दिवसांपूर्वी', now: now);
      expect(result, DateTime(2024, 6, 10));
    });

    test('parseLocale — Marathi', () {
      final result = SmartParser.parseLocale(
        'उद्या',
        locale: SdfLocale.mr,
        now: now,
      );
      expect(result, DateTime(2024, 6, 16));
    });

    test('supportedParseLocales', () {
      expect(
          SmartParser.supportedParseLocales, containsAll(['en', 'hi', 'mr']));
    });
  });

  group('SmartCalendar v2.0.0', () {
    final events = [
      CalendarEvent(
        date: DateTime.now(),
        title: 'Today Meeting',
        color: Colors.blue,
      ),
      CalendarEvent(
        date: DateTime.now().add(const Duration(days: 1)),
        title: 'Tomorrow Event',
        color: Colors.green,
        description: 'Important event',
      ),
      CalendarEvent(
        date: DateTime.now(),
        title: 'Second Event',
        color: Colors.red,
        allDay: false,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 30),
      ),
    ];

    // CalendarEvent tests
    test('CalendarEvent.isOnDate — today', () {
      expect(events[0].isOnDate(DateTime.now()), true);
    });

    test('CalendarEvent.isOnDate — wrong date', () {
      expect(
        events[0].isOnDate(DateTime.now().subtract(const Duration(days: 2))),
        false,
      );
    });

    test('CalendarEvent.timeString — all day', () {
      expect(events[0].timeString, 'All day');
    });

    test('CalendarEvent.timeString — with time', () {
      expect(events[2].timeString, contains('AM'));
    });

    // Controller tests
    test('SmartCalendarController — initial date', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      expect(controller.focusedDate.month, 6);
      expect(controller.focusedDate.day, 15);
      controller.dispose();
    });

    test('Controller.nextMonth', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      controller.nextMonth();
      expect(controller.focusedDate.month, 7);
      controller.dispose();
    });

    test('Controller.previousMonth', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      controller.previousMonth();
      expect(controller.focusedDate.month, 5);
      controller.dispose();
    });

    test('Controller.goToToday', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 1, 1));
      controller.goToToday();
      expect(controller.focusedDate.year, DateTime.now().year);
      controller.dispose();
    });

    test('Controller.jumpToDate', () {
      final controller = SmartCalendarController();
      controller.jumpToDate(DateTime(2025, 3, 15));
      expect(controller.selectedDate, DateTime(2025, 3, 15));
      controller.dispose();
    });

    test('Controller.isCurrentMonth — false for past', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2020, 1, 1));
      expect(controller.isCurrentMonth, false);
      controller.dispose();
    });

    test('Controller.nextWeek', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      controller.nextWeek();
      expect(controller.focusedDate,
          DateTime(2024, 6, 15).add(const Duration(days: 7)));
      controller.dispose();
    });

    test('Controller.selectDate', () {
      final controller = SmartCalendarController();
      controller.selectDate(DateTime(2024, 6, 20));
      expect(controller.selectedDate.day, 20);
      controller.dispose();
    });

    // Widget tests
    testWidgets('SmartCalendar — renders month view', (tester) async {
      // ✅ Large surface size set karo
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              // 👈 wrap in scroll
              child: SmartCalendar(events: events),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null); // reset
    });

    testWidgets('SmartCalendar — shows today button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: events,
                showTodayButton: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Today'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — week view', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: events,
                initialView: CalendarView.week,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — day view', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: events,
                initialView: CalendarView.day,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — with controller', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: events,
                controller: controller,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      controller.dispose();
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('EventMarkerStyle.dot renders', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: events,
                markerStyle: EventMarkerStyle.dot,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('EventMarkerStyle.chip renders', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: events,
                markerStyle: EventMarkerStyle.chip,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('SmartCalendar v2.1.0 — New Features', () {
    final now = DateTime.now();

    // Multi-day event tests
    test('CalendarEvent.isMultiDay — true', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.isMultiDay, true);
    });

    test('CalendarEvent.isMultiDay — false for single day', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        title: 'Meeting',
        color: Colors.blue,
      );
      expect(event.isMultiDay, false);
    });

    test('CalendarEvent.spanDays — 3 days', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.spanDays, 3);
    });

    test('CalendarEvent.spanDays — single day = 1', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        title: 'Meeting',
        color: Colors.blue,
      );
      expect(event.spanDays, 1);
    });

    test('CalendarEvent.isOnDate — middle of multi-day', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.isOnDate(DateTime(2024, 6, 16)), true);
    });

    test('CalendarEvent.isOnDate — outside multi-day', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.isOnDate(DateTime(2024, 6, 18)), false);
    });

    test('CalendarEvent.startsOnDate', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.startsOnDate(DateTime(2024, 6, 15)), true);
      expect(event.startsOnDate(DateTime(2024, 6, 16)), false);
    });

    test('CalendarEvent.endsOnDate', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.endsOnDate(DateTime(2024, 6, 17)), true);
      expect(event.endsOnDate(DateTime(2024, 6, 16)), false);
    });

    test('CalendarEvent.dateRangeString', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 17),
        title: 'Conference',
        color: Colors.blue,
      );
      expect(event.dateRangeString, contains('15'));
      expect(event.dateRangeString, contains('17'));
    });

    // Controller
    test('Controller.nextDay', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      controller.nextDay();
      expect(controller.focusedDate.day, 16);
      controller.dispose();
    });

    test('Controller.previousDay', () {
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      controller.previousDay();
      expect(controller.focusedDate.day, 14);
      controller.dispose();
    });

    // Agenda view widget test
    testWidgets('SmartCalendar — agenda view', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [
                  CalendarEvent(
                    date: now,
                    title: 'Today Event',
                    color: Colors.blue,
                  ),
                  CalendarEvent(
                    date: now.add(const Duration(days: 2)),
                    endDate: now.add(const Duration(days: 4)),
                    title: 'Multi-day Event',
                    color: Colors.green,
                  ),
                ],
                initialView: CalendarView.agenda,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    // Swipe gesture test
    // Test file mein dono swipe tests update karo

    testWidgets('SmartCalendar — swipe left navigates forward', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                controller: controller,
                events: const [],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // ✅ Directly controller call karo
      controller.nextMonth();
      await tester.pump();

      expect(controller.focusedDate.month, 7); // June → July
      controller.dispose();
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — swipe right navigates backward',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final controller =
          SmartCalendarController(initialDate: DateTime(2024, 6, 15));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                controller: controller,
                events: const [],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // ✅ Directly controller call karo
      controller.previousMonth();
      await tester.pump();

      expect(controller.focusedDate.month, 5); // June → May
      controller.dispose();
      await tester.binding.setSurfaceSize(null);
    });

    group('SmartDateField v2.2.0', () {
      testWidgets('SmartDateField — renders', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateField(label: 'Due Date'),
              ),
            ),
          ),
        );
        expect(find.byType(SmartDateField), findsOneWidget);
        expect(find.text('Due Date'), findsOneWidget);
      });

      testWidgets('SmartDateField — shows initial value', (tester) async {
        final date = DateTime(2024, 6, 15);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  initialValue: date,
                ),
              ),
            ),
          ),
        );
        expect(find.text('15 Jun 2024'), findsOneWidget);
      });

      testWidgets('SmartDateField — natural language input', (tester) async {
        DateTime? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  onChanged: (date) => result = date,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'tomorrow');
        await tester.pump(const Duration(milliseconds: 400));
        expect(result, isNotNull);
      });

      testWidgets('SmartDateField — shows picker icon', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  showPickerIcon: true,
                ),
              ),
            ),
          ),
        );
        expect(find.byIcon(Icons.date_range), findsOneWidget);
      });

      testWidgets('SmartDateField — clear button', (tester) async {
        DateTime? result = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  initialValue: DateTime.now(),
                  showClearButton: true,
                  onChanged: (date) => result = date,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();
        expect(result, isNull);
      });

      testWidgets('SmartDateField — validator error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  validator: (date) => date == null ? 'Date required' : null,
                ),
              ),
            ),
          ),
        );
        // No date selected — no error shown yet
        expect(find.text('Date required'), findsNothing);
      });

      // Controller tests
      test('SmartDateFieldController — setValue', () {
        final controller = SmartDateFieldController();
        controller.setValue(DateTime(2024, 6, 15));
        expect(controller.value, DateTime(2024, 6, 15));
        expect(controller.hasValue, true);
        controller.dispose();
      });

      test('SmartDateFieldController — clear', () {
        final controller =
            SmartDateFieldController(initialValue: DateTime.now());
        expect(controller.hasValue, true);
        controller.clear();
        expect(controller.hasValue, false);
        expect(controller.value, isNull);
        controller.dispose();
      });

      test('SmartDateFieldController — initialValue', () {
        final date = DateTime(2024, 6, 15);
        final controller = SmartDateFieldController(initialValue: date);
        expect(controller.value, date);
        controller.dispose();
      });

      testWidgets('SmartDateField — with controller', (tester) async {
        final controller = SmartDateFieldController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  controller: controller,
                ),
              ),
            ),
          ),
        );
        controller.setValue(DateTime(2024, 6, 15));
        await tester.pump();
        expect(find.text('15 Jun 2024'), findsOneWidget);
        controller.dispose();
      });

      testWidgets('SmartDateField — suggestions on tap', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateField(
                  label: 'Date',
                  showSuggestions: true,
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(TextField));
        await tester.pump();
        // Suggestions should appear
        expect(find.text('today'), findsOneWidget);
      });
    });

    group('SmartCalendar v2.3.0 — Week Numbers', () {
      testWidgets('SmartCalendar — week numbers shown', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SmartCalendar(
                  events: [],
                  showWeekNumbers: true,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        // Week number header 'W' should show
        expect(find.text('W'), findsOneWidget);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('SmartCalendar — week numbers hidden by default',
          (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SmartCalendar(
                  events: [],
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('W'), findsNothing);
        await tester.binding.setSurfaceSize(null);
      });

      test('_weekNumber — Jan 1', () {
        final date = DateTime(2024, 1, 1);
        final firstDayOfYear = DateTime(date.year, 1, 1);
        final dayOfYear = date.difference(firstDayOfYear).inDays + 1;
        final weekNum =
            ((dayOfYear + firstDayOfYear.weekday - 2) / 7).ceil().clamp(1, 53);
        expect(weekNum, 1);
      });

      test('_weekNumber — Jun 15', () {
        final date = DateTime(2024, 6, 15);
        final firstDayOfYear = DateTime(date.year, 1, 1);
        final dayOfYear = date.difference(firstDayOfYear).inDays + 1;
        final weekNum =
            ((dayOfYear + firstDayOfYear.weekday - 2) / 7).ceil().clamp(1, 53);
        expect(weekNum, greaterThan(20));
        expect(weekNum, lessThan(30));
      });
    });
  });

  group('SmartDateField v2.3.0 — Time Picker', () {
    testWidgets('SmartDateField — time picker icon shows', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SmartDateField(
                label: 'Date & Time',
                enableTimePicker: true,
              ),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('SmartDateField — time picker hidden by default',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SmartDateField(
                label: 'Date Only',
              ),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.access_time), findsNothing);
    });

    testWidgets('SmartDateField — date and time picker icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SmartDateField(
                label: 'Date & Time',
                enableTimePicker: true,
                showPickerIcon: true,
              ),
            ),
          ),
        ),
      );
      // Both icons should show
      expect(find.byIcon(Icons.access_time), findsOneWidget);
      expect(find.byIcon(Icons.date_range), findsOneWidget);
    });

    testWidgets('SmartDateField — 24 hour format', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SmartDateField(
                label: 'Date & Time',
                enableTimePicker: true,
                use24HourFormat: true,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateField), findsOneWidget);
    });

    testWidgets('SmartDateField — initialTime set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SmartDateField(
                label: 'Date & Time',
                enableTimePicker: true,
                initialValue: DateTime.now(),
                initialTime: const TimeOfDay(hour: 10, minute: 30),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateField), findsOneWidget);
      // Should show AM time
      expect(find.textContaining('10:30'), findsOneWidget);
    });
  });

  group('SmartDateRangePicker v2.3.0', () {
    // SelectedDateRange tests
    test('SelectedDateRange.days — 7 days', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 1),
        end: DateTime(2024, 6, 7),
      );
      expect(range.days, 7);
    });

    test('SelectedDateRange.contains — inside', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 1),
        end: DateTime(2024, 6, 30),
      );
      expect(range.contains(DateTime(2024, 6, 15)), true);
    });

    test('SelectedDateRange.contains — outside', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 1),
        end: DateTime(2024, 6, 30),
      );
      expect(range.contains(DateTime(2024, 7, 1)), false);
    });

    test('SelectedDateRange.toDateRange', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 1),
        end: DateTime(2024, 6, 30),
      );
      final dateRange = range.toDateRange();
      expect(dateRange.start, DateTime(2024, 6, 1));
      expect(dateRange.end, DateTime(2024, 6, 30));
    });

    // Controller tests
    test('Controller.setRange', () {
      final controller = SmartDateRangePickerController();
      controller.setRange(
        DateTime(2024, 6, 1),
        DateTime(2024, 6, 30),
      );
      expect(controller.hasValue, true);
      expect(controller.value?.days, 30);
      controller.dispose();
    });

    test('Controller.setPreset — thisWeek', () {
      final controller = SmartDateRangePickerController();
      controller.setPreset(DateRangePreset.thisWeek);
      expect(controller.hasValue, true);
      expect(controller.value?.preset, DateRangePreset.thisWeek);
      controller.dispose();
    });

    test('Controller.setPreset — last30Days', () {
      final controller = SmartDateRangePickerController();
      controller.setPreset(DateRangePreset.last30Days);
      expect(controller.value?.days, 30);
      controller.dispose();
    });

    test('Controller.clear', () {
      final controller = SmartDateRangePickerController(
        initialRange: SelectedDateRange(
          start: DateTime(2024, 6, 1),
          end: DateTime(2024, 6, 30),
        ),
      );
      expect(controller.hasValue, true);
      controller.clear();
      expect(controller.hasValue, false);
      controller.dispose();
    });

    test('Controller.initialRange', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 1),
        end: DateTime(2024, 6, 30),
      );
      final controller = SmartDateRangePickerController(initialRange: range);
      expect(controller.value?.start, DateTime(2024, 6, 1));
      controller.dispose();
    });

    // Widget tests
    testWidgets('SmartDateRangePicker — renders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — shows presets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  showPresets: true,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — preset tap', (tester) async {
      SelectedDateRange? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  showConfirmButton: false,
                  onRangeSelected: (range) => result = range,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Today'));
      await tester.pump();
      expect(result, isNotNull);
      expect(result?.preset, DateRangePreset.today);
    });

    testWidgets('SmartDateRangePicker — with controller', (tester) async {
      final controller = SmartDateRangePickerController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  controller: controller,
                ),
              ),
            ),
          ),
        ),
      );
      controller.setPreset(DateRangePreset.thisMonth);
      await tester.pump();
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
      controller.dispose();
    });

    testWidgets('SmartDateRangePicker — no presets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  showPresets: false,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Today'), findsNothing);
    });
  });

  group('SmartCalendar v2.5.0 — Dark Theme', () {
    testWidgets('SmartCalendar — dark theme renders', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [],
                themeMode: ThemeMode.dark,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — light theme renders', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [],
                themeMode: ThemeMode.light,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — system theme renders', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [],
                themeMode: ThemeMode.system,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — dark theme week view', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [],
                themeMode: ThemeMode.dark,
                initialView: CalendarView.week,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — dark theme agenda view', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [],
                themeMode: ThemeMode.dark,
                initialView: CalendarView.agenda,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('SmartCalendar v2.5.0 — Custom Cell Builder', () {
    testWidgets('SmartCalendar — custom cell builder renders', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: const [],
                cellBuilder: (date, events, isSelected, isToday) => Container(
                  color: isSelected ? Colors.indigo : Colors.transparent,
                  child: Center(
                    child: Text('${date.day}'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — default cell when builder null',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SmartCalendar — custom cell with events', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartCalendar(
                events: [
                  CalendarEvent(
                    date: DateTime.now(),
                    title: 'Test',
                    color: Colors.blue,
                  ),
                ],
                cellBuilder: (date, events, isSelected, isToday) =>
                    Stack(children: [
                  Center(child: Text('${date.day}')),
                  if (events.isNotEmpty)
                    const Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.circle, size: 6, color: Colors.blue),
                    ),
                ]),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SmartCalendar), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('SmartDateRangePicker v2.5.0 — Custom Colors', () {
    testWidgets('SmartDateRangePicker — custom primaryColor', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  primaryColor: Colors.teal,
                  rangeColor: Colors.teal,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — custom rangeHighlightColor',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  rangeHighlightColor: Colors.purple.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — weekends hidden', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  highlightWeekends: false,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — custom cellBorderRadius',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  cellBorderRadius: 20,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — backgroundColor', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });

    testWidgets('SmartDateRangePicker — hotel booking theme', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SmartDateRangePicker(
                  primaryColor: Colors.teal,
                  rangeColor: Colors.teal,
                  weekendColor: Colors.orange,
                  cellBorderRadius: 20,
                  highlightWeekends: true,
                  confirmLabel: 'Book Now',
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SmartDateRangePicker), findsOneWidget);
    });
  });

  group('Edge Cases & Quality v2.5.0', () {
    // ── DateTime Extensions edge cases ────────────────
    test('startOfDay — exactly midnight', () {
      final d = DateTime(2024, 6, 15).startOfDay;
      expect(d.hour, 0);
      expect(d.minute, 0);
      expect(d.second, 0);
      expect(d.millisecond, 0);
    });

    test('endOfDay — exactly 23:59:59', () {
      final d = DateTime(2024, 6, 15).endOfDay;
      expect(d.hour, 23);
      expect(d.minute, 59);
      expect(d.second, 59);
    });

    test('isBetween — same start and end date', () {
      final date = DateTime(2024, 6, 15);
      expect(date.isBetween(date, date), true);
    });

    test('addWorkingDays — 0 days returns same date', () {
      final date = DateTime(2024, 6, 17); // Monday
      expect(date.addWorkingDays(0), date);
    });

    test('addWorkingDays — negative days goes backward', () {
      final friday = DateTime(2024, 6, 14);
      final result = friday.addWorkingDays(-1);
      expect(result.weekday, DateTime.thursday);
    });

    test('copyWith — all fields', () {
      final date = DateTime(2024, 6, 15, 14, 30, 45);
      final copy = date.copyWith(
        year: 2025,
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
      );
      expect(copy.year, 2025);
      expect(copy.month, 1);
      expect(copy.day, 1);
      expect(copy.hour, 0);
    });

    test('nextSunday from Saturday', () {
      final saturday = DateTime(2024, 6, 15);
      expect(saturday.nextSunday.weekday, DateTime.sunday);
    });

    test('previousSunday from Saturday', () {
      final saturday = DateTime(2024, 6, 15);
      expect(saturday.previousSunday.weekday, DateTime.sunday);
      expect(saturday.previousSunday.isBefore(saturday), true);
    });

    // ── Format edge cases ─────────────────────────────
    test('format — midnight 12:00 AM', () {
      final midnight = DateTime(2024, 6, 15, 0, 0);
      expect(midnight.format('hh:mm a'), '12:00 AM');
    });

    test('format — noon 12:00 PM', () {
      final noon = DateTime(2024, 6, 15, 12, 0);
      expect(noon.format('hh:mm a'), '12:00 PM');
    });

    test('format — single digit day no padding', () {
      final date = DateTime(2024, 6, 5);
      expect(date.format('d'), '5');
    });

    test('toISO — no milliseconds', () {
      final date = DateTime(2024, 6, 15, 14, 30, 45, 123);
      expect(date.toISO, '2024-06-15T14:30:45');
      expect(date.toISO.contains('.'), false);
    });

    // ── Localization edge cases ───────────────────────
    test('SdfLocale.fromCode — uppercase input', () {
      // Should handle gracefully
      expect(SdfLocale.fromCode('EN').code, 'en');
    });

    test('SdfLocale.fromCode — empty falls back to en', () {
      expect(SdfLocale.fromCode('').code, 'en');
    });

    test('SmartFormatter — justNow < 10 seconds', () {
      const f = SmartDateFormatter();
      final date = DateTime.now().subtract(const Duration(seconds: 9));
      expect(f.format(date), 'Just now');
    });

    test('SmartFormatter — exactly 10 seconds is not justNow', () {
      const f = SmartDateFormatter();
      final now = DateTime(2024, 6, 15, 12, 0, 0);
      final date = now.subtract(const Duration(seconds: 10));
      expect(f.format(date, now: now), isNot('Just now'));
    });

    // ── SmartParser edge cases ────────────────────────
    test('SmartParser — empty string returns null', () {
      expect(SmartParser.parse(''), null);
    });

    test('SmartParser — whitespace returns null', () {
      expect(SmartParser.parse('   '), null);
    });

    test('SmartParser — case insensitive', () {
      final now = DateTime(2024, 6, 15);
      expect(
        SmartParser.parse('TOMORROW', now: now),
        isNotNull,
      );
      expect(
        SmartParser.parse('Tomorrow', now: now),
        isNotNull,
      );
    });

    test('SmartParser — "in a day" same as "in 1 day"', () {
      final now = DateTime(2024, 6, 15);
      final inADay = SmartParser.parse('in a day', now: now);
      final in1Day = SmartParser.parse('in 1 day', now: now);
      expect(inADay, in1Day);
    });

    // ── StreakCalculator edge cases ───────────────────
    test('StreakCalculator — empty list returns 0', () {
      expect(StreakCalculator.currentStreak([]), 0);
      expect(StreakCalculator.longestStreak([]), 0);
      expect(StreakCalculator.totalCompleted([]), 0);
    });

    test('StreakCalculator — duplicate dates counted once', () {
      final dates = [
        DateTime(2024, 6, 15),
        DateTime(2024, 6, 15), // duplicate
        DateTime(2024, 6, 15, 14, 30), // same day diff time
      ];
      expect(StreakCalculator.totalCompleted(dates), 1);
    });

    test('StreakCalculator — single date streak = 1', () {
      expect(
        StreakCalculator.longestStreak([DateTime(2024, 6, 15)]),
        1,
      );
    });

    // ── DateGrouper edge cases ────────────────────────
    test('DateGrouper — empty list returns empty map', () {
      expect(DateGrouper.byDay([]), isEmpty);
      expect(DateGrouper.byMonth([]), isEmpty);
      expect(DateGrouper.byYear([]), isEmpty);
    });

    test('DateGrouper.mostActiveDay — empty returns null', () {
      expect(DateGrouper.mostActiveDay([]), isNull);
    });

    test('DateGrouper.averageGap — two dates', () {
      final dates = [
        DateTime(2024, 6, 1),
        DateTime(2024, 6, 8),
      ];
      final gap = DateGrouper.averageGap(dates);
      expect(gap?.inDays, 7);
    });

    // ── DateRangeHelper edge cases ────────────────────
    test('DateRange.overlaps — non overlapping', () {
      final r1 = DateRangeHelper.custom(
        DateTime(2024, 1, 1),
        DateTime(2024, 3, 31),
      );
      final r2 = DateRangeHelper.custom(
        DateTime(2024, 7, 1),
        DateTime(2024, 9, 30),
      );
      expect(r1.overlaps(r2), false);
    });

    test('DateRangeHelper.quarter — Q1 Jan-Mar', () {
      final q1 = DateRangeHelper.quarter(1);
      expect(q1.start.month, 1);
      expect(q1.end.month, 3);
    });

    test('DateRangeHelper.quarter — Q4 Oct-Dec', () {
      final q4 = DateRangeHelper.quarter(4);
      expect(q4.start.month, 10);
      expect(q4.end.month, 12);
    });

    // ── HolidayHelper edge cases ──────────────────────
    test('HolidayHelper — empty holidays list', () {
      expect(
        HolidayHelper.isHoliday(DateTime.now(), holidays: []),
        false,
      );
      expect(
        HolidayHelper.isWorkingDay(DateTime(2024, 6, 17), holidays: []),
        true,
      );
    });

    test('HolidayHelper — time ignored in comparison', () {
      final holiday = DateTime(2024, 12, 25, 0, 0, 0);
      final check = DateTime(2024, 12, 25, 14, 30, 0);
      expect(
        HolidayHelper.isHoliday(check, holidays: [holiday]),
        true,
      );
    });

    // ── RecurrenceHelper edge cases ───────────────────
    test('RecurrenceHelper — count 1 returns 1 date', () {
      final dates = RecurrenceHelper.daily(
        start: DateTime(2024, 6, 15),
        count: 1,
      );
      expect(dates.length, 1);
    });

    test('RecurrenceHelper — until same as start', () {
      final start = DateTime(2024, 6, 15);
      final dates = RecurrenceHelper.daily(
        start: start,
        until: start,
      );
      expect(dates.length, 1);
    });

    // ── CalendarEvent edge cases ──────────────────────
    test('CalendarEvent — same start and end = not multiDay', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 6, 15),
        title: 'Same day',
        color: Colors.blue,
      );
      expect(event.isMultiDay, false);
      expect(event.spanDays, 1);
    });

    test('CalendarEvent — no endDate = spanDays 1', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        title: 'Single',
        color: Colors.blue,
      );
      expect(event.spanDays, 1);
    });

    test('CalendarEvent.timeString — no startTime', () {
      final event = CalendarEvent(
        date: DateTime(2024, 6, 15),
        title: 'No time',
        color: Colors.blue,
        allDay: false,
      );
      expect(event.timeString, '');
    });

    // ── SelectedDateRange edge cases ──────────────────
    test('SelectedDateRange — single day range = 1 day', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 15),
        end: DateTime(2024, 6, 15),
      );
      expect(range.days, 1);
    });

    test('SelectedDateRange.contains — boundary dates', () {
      final range = SelectedDateRange(
        start: DateTime(2024, 6, 1),
        end: DateTime(2024, 6, 30),
      );
      expect(range.contains(DateTime(2024, 6, 1)), true);
      expect(range.contains(DateTime(2024, 6, 30)), true);
    });
  });

  group('SmartParser v2.6.0 — New Expressions', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0); // Saturday

    // First/Last weekday of month
    test('first monday of this month', () {
      final result = SmartParser.parse('first monday of this month', now: now);
      expect(result?.weekday, DateTime.monday);
      expect(result?.month, 6);
    });

    test('last friday of this month', () {
      final result = SmartParser.parse('last friday of this month', now: now);
      expect(result?.weekday, DateTime.friday);
      expect(result?.month, 6);
    });

    test('first monday of next month', () {
      final result = SmartParser.parse('first monday of next month', now: now);
      expect(result?.weekday, DateTime.monday);
      expect(result?.month, 7);
    });

    // N weekdays ago/ahead
    test('2 mondays ago', () {
      final result = SmartParser.parse('2 mondays ago', now: now);
      expect(result?.weekday, DateTime.monday);
      expect(result?.isBefore(now), true);
    });

    test('in 2 fridays', () {
      final result = SmartParser.parse('in 2 fridays', now: now);
      expect(result?.weekday, DateTime.friday);
      expect(result?.isAfter(now), true);
    });

    // Beginning/End of
    test('beginning of next month', () {
      final result = SmartParser.parse('beginning of next month', now: now);
      expect(result?.month, 7);
      expect(result?.day, 1);
    });

    test('end of this month', () {
      final result = SmartParser.parse('end of this month', now: now);
      expect(result?.month, 6);
      expect(result?.day, 30);
    });

    test('beginning of next year', () {
      final result = SmartParser.parse('beginning of next year', now: now);
      expect(result?.year, 2025);
      expect(result?.month, 1);
    });

    // This coming weekday
    test('this coming monday', () {
      final result = SmartParser.parse('this coming monday', now: now);
      expect(result?.weekday, DateTime.monday);
      expect(result?.isAfter(now), true);
    });

    // Quarter
    test('q1 returns January', () {
      final result = SmartParser.parse('q1', now: now);
      expect(result?.month, 1);
    });

    test('q2 returns April', () {
      final result = SmartParser.parse('q2', now: now);
      expect(result?.month, 4);
    });

    test('quarter 3 returns July', () {
      final result = SmartParser.parse('quarter 3', now: now);
      expect(result?.month, 7);
    });
  });

  group('SmartParser v2.6.0 — Gujarati', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0);

    test('આજ — today', () {
      expect(SmartParser.parse('આજ', now: now), DateTime(2024, 6, 15));
    });

    test('આવતી કાલ — tomorrow', () {
      expect(SmartParser.parse('આવતી કાલ', now: now), DateTime(2024, 6, 16));
    });

    test('ગઈ કાલ — yesterday', () {
      expect(SmartParser.parse('ગઈ કાલ', now: now), DateTime(2024, 6, 14));
    });

    test('આવતા અઠવાડિયે — next week', () {
      final result = SmartParser.parse('આવતા અઠવાડિયે', now: now);
      expect(result, DateTime(2024, 6, 22));
    });

    test('3 દિવસ પછી — in 3 days', () {
      final result = SmartParser.parse('3 દિવસ પછી', now: now);
      expect(result, DateTime(2024, 6, 18));
    });

    test('parseLocale — Gujarati', () {
      final result = SmartParser.parseLocale(
        'આવતી કાલ',
        locale: SdfLocale.gu,
        now: now,
      );
      expect(result, DateTime(2024, 6, 16));
    });
  });

  group('SmartParser v2.6.0 — Bengali', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0);

    test('আজ — today', () {
      expect(SmartParser.parse('আজ', now: now), DateTime(2024, 6, 15));
    });

    test('আগামীকাল — tomorrow', () {
      expect(SmartParser.parse('আগামীকাল', now: now), DateTime(2024, 6, 16));
    });

    test('গতকাল — yesterday', () {
      expect(SmartParser.parse('গতকাল', now: now), DateTime(2024, 6, 14));
    });

    test('আগামী সপ্তাহ — next week', () {
      final result = SmartParser.parse('আগামী সপ্তাহ', now: now);
      expect(result, DateTime(2024, 6, 22));
    });

    test('3 দিন পরে — in 3 days', () {
      final result = SmartParser.parse('3 দিন পরে', now: now);
      expect(result, DateTime(2024, 6, 18));
    });

    test('parseLocale — Bengali', () {
      final result = SmartParser.parseLocale(
        'আগামীকাল',
        locale: SdfLocale.bn,
        now: now,
      );
      expect(result, DateTime(2024, 6, 16));
    });
  });

  group('SmartParser v2.6.0 — Tamil', () {
    final now = DateTime(2024, 6, 15, 12, 0, 0);

    test('இன்று — today', () {
      expect(SmartParser.parse('இன்று', now: now), DateTime(2024, 6, 15));
    });

    test('நாளை — tomorrow', () {
      expect(SmartParser.parse('நாளை', now: now), DateTime(2024, 6, 16));
    });

    test('நேற்று — yesterday', () {
      expect(SmartParser.parse('நேற்று', now: now), DateTime(2024, 6, 14));
    });

    test('அடுத்த வாரம் — next week', () {
      final result = SmartParser.parse('அடுத்த வாரம்', now: now);
      expect(result, DateTime(2024, 6, 22));
    });

    test('3 நாட்களில் — in 3 days', () {
      final result = SmartParser.parse('3 நாட்களில்', now: now);
      expect(result, DateTime(2024, 6, 18));
    });

    test('parseLocale — Tamil', () {
      final result = SmartParser.parseLocale(
        'நாளை',
        locale: SdfLocale.ta,
        now: now,
      );
      expect(result, DateTime(2024, 6, 16));
    });

    test('supportedParseLocales has gu bn ta', () {
      expect(
          SmartParser.supportedParseLocales, containsAll(['gu', 'bn', 'ta']));
    });
  });
}
