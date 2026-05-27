import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/demo_section.dart';
import '../widgets/demo_code_box.dart';

/// Demonstrates calendar and shortTimestamp extensions.
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dates = [
      DateTime.now(),
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 5)),
      DateTime.now().subtract(const Duration(days: 4)),
      DateTime.now().subtract(const Duration(days: 10)),
      DateTime(2023, 3, 7),
      DateTime(2023, 12, 25),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const DemoSection('calendar + shortTimestamp'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          "date.calendar       // 'Today', 'Yesterday', 'Monday'\n"
          "date.shortTimestamp // '2:30 PM', 'Mon 4:15 PM', '5 Mar'",
        ),
        const SizedBox(height: 12),
        ...dates.map((date) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('${date.day}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ),
                ),
                title: Text(date.calendar,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(date.shortTimestamp,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            )),
      ],
    );
  }
}
