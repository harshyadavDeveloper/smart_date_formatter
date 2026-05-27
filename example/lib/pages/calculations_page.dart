import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/demo_tile.dart';
import '../widgets/demo_section.dart';
import '../widgets/demo_code_box.dart';

/// Demonstrates all calculation and boolean extensions.
class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final birth = DateTime(1999, 5, 20);
    final deadline = now.add(const Duration(days: 15));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const DemoSection('Boolean Extensions'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'date.isToday    // true\n'
          'date.isWeekend  // false\n'
          'date.isMorning  // true\n'
          'date.isPast     // false',
        ),
        const SizedBox(height: 12),
        DemoTile(label: 'isToday', value: '${now.isToday}'),
        DemoTile(label: 'isYesterday', value: '${now.subtract(const Duration(days: 1)).isYesterday}'),
        DemoTile(label: 'isTomorrow', value: '${now.add(const Duration(days: 1)).isTomorrow}'),
        DemoTile(label: 'isPast (1999)', value: '${birth.isPast}'),
        DemoTile(label: 'isFuture (deadline)', value: '${deadline.isFuture}'),
        DemoTile(label: 'isWeekend', value: '${now.isWeekend}'),
        DemoTile(label: 'isWeekday', value: '${now.isWeekday}'),
        DemoTile(label: 'isMorning', value: '${now.isMorning}'),
        DemoTile(label: 'isAfternoon', value: '${now.isAfternoon}'),
        DemoTile(label: 'isEvening', value: '${now.isEvening}'),
        DemoTile(label: 'isNight', value: '${now.isNight}'),

        const SizedBox(height: 16),
        const DemoSection('Quarter & Year'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'date.quarter    // 2\n'
          'date.isQ2       // true\n'
          'date.weekOfYear // 24\n'
          'date.isLeapYear // true',
        ),
        const SizedBox(height: 12),
        DemoTile(label: 'quarter', value: '${now.quarter}'),
        DemoTile(label: 'isQ1/Q2/Q3/Q4', value: '${now.isQ1}/${now.isQ2}/${now.isQ3}/${now.isQ4}'),
        DemoTile(label: 'weekOfYear', value: '${now.weekOfYear}'),
        DemoTile(label: 'dayOfYear', value: '${now.dayOfYear}'),
        DemoTile(label: 'isLeapYear', value: '${now.isLeapYear}'),

        const SizedBox(height: 16),
        const DemoSection('Date Calculations'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'DateTime(1999,5,20).age          // 25\n'
          'date.addWorkingDays(5)           // skip weekends\n'
          'date.daysUntil(deadline)         // 15\n'
          'date.isBetween(start, end)       // true',
        ),
        const SizedBox(height: 12),
        DemoTile(label: 'age (born 1999)', value: '${birth.age} years'),
        DemoTile(label: 'daysUntil deadline', value: '${now.daysUntil(deadline)} days'),
        DemoTile(label: 'daysSince birth', value: '${now.daysSince(birth)} days'),
        DemoTile(label: 'addWorkingDays(5)', value: now.addWorkingDays(5).format('EEE dd MMM')),
        DemoTile(label: 'workingDaysUntil', value: '${now.workingDaysUntil(deadline)} days'),
        DemoTile(label: 'isBetween', value: '${now.isBetween(birth, deadline)}'),

        const SizedBox(height: 16),
        const DemoSection('Boundaries'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'date.startOfWeek   // Monday 00:00\n'
          'date.endOfMonth    // last day 23:59\n'
          'date.nextFriday    // next Friday date',
        ),
        const SizedBox(height: 12),
        DemoTile(label: 'startOfDay', value: now.startOfDay.toISO),
        DemoTile(label: 'endOfDay', value: now.endOfDay.toISO),
        DemoTile(label: 'startOfWeek', value: now.startOfWeek.format('EEE dd MMM')),
        DemoTile(label: 'endOfWeek', value: now.endOfWeek.format('EEE dd MMM')),
        DemoTile(label: 'startOfMonth', value: now.startOfMonth.format('dd MMM yyyy')),
        DemoTile(label: 'endOfMonth', value: now.endOfMonth.format('dd MMM yyyy')),
        DemoTile(label: 'nextMonday', value: now.nextMonday.format('EEE dd MMM')),
        DemoTile(label: 'nextFriday', value: now.nextFriday.format('EEE dd MMM')),
        DemoTile(label: 'previousMonday', value: now.previousMonday.format('EEE dd MMM')),
        DemoTile(label: 'isSameDay(now)', value: '${now.isSameDay(DateTime.now())}'),
        DemoTile(label: 'isSameWeek(now)', value: '${now.isSameWeek(DateTime.now())}'),
        DemoTile(label: 'copyWith(hour:0)', value: now.copyWith(hour: 0, minute: 0).toISO),
      ],
    );
  }
}