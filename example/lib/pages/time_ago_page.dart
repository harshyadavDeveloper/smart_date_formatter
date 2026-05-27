import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/demo_tile.dart';
import '../widgets/demo_section.dart';
import '../widgets/demo_code_box.dart';

/// Demonstrates timeAgo, calendar, shortTimestamp.
class TimeAgoPage extends StatelessWidget {
  const TimeAgoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Just now', DateTime.now().subtract(const Duration(seconds: 3))),
      ('30 secs ago', DateTime.now().subtract(const Duration(seconds: 30))),
      ('1 min ago', DateTime.now().subtract(const Duration(minutes: 1))),
      ('25 mins ago', DateTime.now().subtract(const Duration(minutes: 25))),
      ('1 hour ago', DateTime.now().subtract(const Duration(hours: 1))),
      ('5 hours ago', DateTime.now().subtract(const Duration(hours: 5))),
      ('Yesterday', DateTime.now().subtract(const Duration(days: 1))),
      ('3 days ago', DateTime.now().subtract(const Duration(days: 3))),
      ('Last week', DateTime.now().subtract(const Duration(days: 9))),
      ('Last month', DateTime.now().subtract(const Duration(days: 35))),
      ('Last year', DateTime.now().subtract(const Duration(days: 400))),
      ('In 5 mins', DateTime.now().add(const Duration(minutes: 5))),
      ('Tomorrow', DateTime.now().add(const Duration(days: 1))),
      ('Next week', DateTime.now().add(const Duration(days: 8))),
      ('In 2 months', DateTime.now().add(const Duration(days: 65))),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const DemoSection('timeAgo — Relative Time',
            subtitle: 'Past and future relative strings'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          "date.timeAgo           // '2 hours ago'\n"
          "date.calendar          // 'Today'\n"
          "date.shortTimestamp    // '2:30 PM'",
        ),
        const SizedBox(height: 12),
        ...items.map((item) => DemoTile(
              label: item.$1,
              value: item.$2.timeAgo,
            )),
      ],
    );
  }
}
