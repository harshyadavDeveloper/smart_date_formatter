import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/example_tile.dart';
import '../widgets/section_header.dart';

/// Demonstrates calendar and shortTimestamp extensions.
class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Today', DateTime.now()),
      ('Yesterday', DateTime.now().subtract(const Duration(days: 1))),
      ('Tomorrow', DateTime.now().add(const Duration(days: 1))),
      ('In 2 days', DateTime.now().add(const Duration(days: 2))),
      ('In 5 days', DateTime.now().add(const Duration(days: 5))),
      ('4 days ago', DateTime.now().subtract(const Duration(days: 4))),
      ('10 days ago', DateTime.now().subtract(const Duration(days: 10))),
      ('Old date', DateTime(2023, 3, 7)),
      ('Christmas 2023', DateTime(2023, 12, 25)),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('date.calendar + date.shortTimestamp'),
        const SizedBox(height: 8),
        const CodeBox(
          "DateTime.now().calendar       // 'Today'\n"
          "DateTime.now().shortTimestamp // '2:30 PM'",
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => ExampleTile(
            label: item.$1,
            value: '${item.$2.calendar}  •  ${item.$2.shortTimestamp}',
          ),
        ),
      ],
    );
  }
}
