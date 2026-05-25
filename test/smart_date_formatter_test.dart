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
}
