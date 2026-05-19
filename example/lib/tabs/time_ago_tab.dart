import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/example_tile.dart';
import '../widgets/section_header.dart';

/// Demonstrates [DateTime.timeAgo] extension.
class TimeAgoTab extends StatelessWidget {
  const TimeAgoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Just now', DateTime.now().subtract(const Duration(seconds: 3))),
      ('30 seconds ago', DateTime.now().subtract(const Duration(seconds: 30))),
      ('1 minute ago', DateTime.now().subtract(const Duration(minutes: 1))),
      ('25 minutes ago', DateTime.now().subtract(const Duration(minutes: 25))),
      ('1 hour ago', DateTime.now().subtract(const Duration(hours: 1))),
      ('5 hours ago', DateTime.now().subtract(const Duration(hours: 5))),
      ('Yesterday', DateTime.now().subtract(const Duration(days: 1))),
      ('3 days ago', DateTime.now().subtract(const Duration(days: 3))),
      ('Last week', DateTime.now().subtract(const Duration(days: 9))),
      ('Last month', DateTime.now().subtract(const Duration(days: 35))),
      ('Last year', DateTime.now().subtract(const Duration(days: 400))),
      ('In 5 minutes', DateTime.now().add(const Duration(minutes: 5))),
      ('Tomorrow', DateTime.now().add(const Duration(days: 1))),
      ('Next week', DateTime.now().add(const Duration(days: 8))),
      ('In 2 months', DateTime.now().add(const Duration(days: 65))),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('date.timeAgo — Relative Time Strings'),
        const SizedBox(height: 8),
        const CodeBox(
          'DateTime.now().subtract(Duration(hours: 2)).timeAgo\n'
          "// '2 hours ago'\n"
          'DateTime.now().add(Duration(days: 1)).timeAgo\n'
          "// 'Tomorrow'",
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => ExampleTile(label: item.$1, value: item.$2.timeAgo),
        ),
      ],
    );
  }
}
