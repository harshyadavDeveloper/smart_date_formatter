import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates [DateRangeHelper] ranges.
class RangesTab extends StatelessWidget {
  const RangesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final ranges = [
      ('today()', DateRangeHelper.today()),
      ('yesterday()', DateRangeHelper.yesterday()),
      ('tomorrow()', DateRangeHelper.tomorrow()),
      ('thisWeek()', DateRangeHelper.thisWeek()),
      ('lastWeek()', DateRangeHelper.lastWeek()),
      ('nextWeek()', DateRangeHelper.nextWeek()),
      ('thisMonth()', DateRangeHelper.thisMonth()),
      ('lastMonth()', DateRangeHelper.lastMonth()),
      ('nextMonth()', DateRangeHelper.nextMonth()),
      ('thisYear()', DateRangeHelper.thisYear()),
      ('lastYear()', DateRangeHelper.lastYear()),
      ('lastNDays(7)', DateRangeHelper.lastNDays(7)),
      ('lastNDays(30)', DateRangeHelper.lastNDays(30)),
      ('nextNDays(14)', DateRangeHelper.nextNDays(14)),
      ('quarter(1)', DateRangeHelper.quarter(1)),
      ('quarter(2)', DateRangeHelper.quarter(2)),
      ('quarter(3)', DateRangeHelper.quarter(3)),
      ('quarter(4)', DateRangeHelper.quarter(4)),
      ('currentQuarter()', DateRangeHelper.currentQuarter()),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('DateRangeHelper — DB Query Ranges'),
        const SizedBox(height: 8),
        const CodeBox(
          'final range = DateRangeHelper.thisMonth();\n'
          'await db.query(\n'
          '  where: "created_at BETWEEN ? AND ?",\n'
          '  whereArgs: [\n'
          '    range.start.toIso8601String(),\n'
          '    range.end.toIso8601String(),\n'
          '  ],\n'
          ');\n'
          'range.contains(DateTime.now()); // true\n'
          'range.days;                      // 30',
        ),
        const SizedBox(height: 12),
        ...ranges.map((r) {
          final range = r.$2;
          final containsToday = range.contains(now);
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DateRangeHelper.${r.$1}',
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                      if (containsToday)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Text('today ✓',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${range.start.format('dd MMM yyyy')} → '
                    '${range.end.format('dd MMM yyyy')}  •  '
                    '${range.days} days',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
