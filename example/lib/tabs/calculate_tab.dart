import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/example_tile.dart';
import '../widgets/section_header.dart';

/// Demonstrates all calculation and boolean extensions.
class CalculateTab extends StatelessWidget {
  const CalculateTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final birth = DateTime(1999, 5, 20);
    final deadline = now.add(const Duration(days: 15));

    final items = [
      ('isToday', '${now.isToday}'),
      ('isYesterday', '${now.subtract(const Duration(days: 1)).isYesterday}'),
      ('isTomorrow', '${now.add(const Duration(days: 1)).isTomorrow}'),
      ('isPast', '${birth.isPast}'),
      ('isFuture', '${deadline.isFuture}'),
      ('isWeekend', '${now.isWeekend}'),
      ('isWeekday', '${now.isWeekday}'),
      ('isMorning', '${now.isMorning}'),
      ('isAfternoon', '${now.isAfternoon}'),
      ('isEvening', '${now.isEvening}'),
      ('isNight', '${now.isNight}'),
      ('quarter', '${now.quarter}'),
      ('isQ1/Q2/Q3/Q4', '${now.isQ1}/${now.isQ2}/${now.isQ3}/${now.isQ4}'),
      ('weekOfYear', '${now.weekOfYear}'),
      ('dayOfYear', '${now.dayOfYear}'),
      ('isLeapYear', '${now.isLeapYear}'),
      ('age (born 1999)', '${birth.age} years'),
      ('daysUntil deadline', '${now.daysUntil(deadline)} days'),
      ('daysSince birth', '${now.daysSince(birth)} days'),
      ('addWorkingDays(5)', now.addWorkingDays(5).format('EEE dd MMM')),
      ('workingDaysUntil', '${now.workingDaysUntil(deadline)} days'),
      ('isBetween', '${now.isBetween(birth, deadline)}'),
      ('isSameDay(now)', '${now.isSameDay(DateTime.now())}'),
      ('isSameWeek(now)', '${now.isSameWeek(DateTime.now())}'),
      ('isSameMonth(now)', '${now.isSameMonth(DateTime.now())}'),
      ('isSameYear(now)', '${now.isSameYear(DateTime.now())}'),
      ('startOfDay', now.startOfDay.toISO),
      ('endOfDay', now.endOfDay.toISO),
      ('startOfWeek', now.startOfWeek.format('EEE dd MMM')),
      ('endOfWeek', now.endOfWeek.format('EEE dd MMM')),
      ('startOfMonth', now.startOfMonth.format('dd MMM yyyy')),
      ('endOfMonth', now.endOfMonth.format('dd MMM yyyy')),
      ('nextMonday', now.nextMonday.format('EEE dd MMM')),
      ('nextFriday', now.nextFriday.format('EEE dd MMM')),
      ('previousMonday', now.previousMonday.format('EEE dd MMM')),
      ('copyWith(hour:0)', now.copyWith(hour: 0, minute: 0).toISO),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('All Calculation & Boolean Extensions'),
        const SizedBox(height: 8),
        const CodeBox(
          'DateTime(1999,5,20).age          // 25\n'
          'DateTime.now().addWorkingDays(5) // skip weekends\n'
          'DateTime.now().nextFriday        // next Friday\n'
          'DateTime.now().quarter           // 2',
        ),
        const SizedBox(height: 12),
        ...items.map((item) => ExampleTile(label: item.$1, value: item.$2)),
      ],
    );
  }
}
