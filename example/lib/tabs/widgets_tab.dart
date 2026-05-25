import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates [TimeAgoText] and [CountdownText] widgets.
class WidgetsTab extends StatelessWidget {
  const WidgetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // TimeAgoText
        const SectionHeader('TimeAgoText — Auto Refreshing Widget'),
        const SizedBox(height: 8),
        const CodeBox(
          'TimeAgoText(\n'
          '  date: message.sentAt,\n'
          '  locale: SdfLocale.hi,\n'
          '  refreshRate: Duration(seconds: 30),\n'
          '  prefix: "Sent ",\n'
          ')',
        ),
        const SizedBox(height: 12),
        ...[
          (
            now.subtract(const Duration(seconds: 5)),
            SdfLocale.en,
            '🇬🇧 English',
            Colors.indigo,
          ),
          (
            now.subtract(const Duration(minutes: 2)),
            SdfLocale.hi,
            '🇮🇳 Hindi',
            Colors.orange,
          ),
          (
            now.subtract(const Duration(hours: 3)),
            SdfLocale.mr,
            '🇮🇳 Marathi',
            Colors.teal,
          ),
          (
            now.subtract(const Duration(days: 1)),
            SdfLocale.ja,
            '🇯🇵 Japanese',
            Colors.red,
          ),
          (
            now.subtract(const Duration(days: 8)),
            SdfLocale.de,
            '🇩🇪 German',
            Colors.purple,
          ),
        ].map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.access_time, color: item.$4),
              title: Text(
                item.$3,
                style: TextStyle(color: item.$4, fontWeight: FontWeight.w600),
              ),
              trailing: TimeAgoText(
                date: item.$1,
                locale: item.$2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // CountdownText
        const SectionHeader('CountdownText — Live Countdown Widget'),
        const SizedBox(height: 8),
        const CodeBox(
          'CountdownText(\n'
          '  target: event.startsAt,\n'
          "  format: '{d}d {h}h {m}m {s}s',\n"
          "  finishedText: 'Done!',\n"
          '  onFinished: () => print("Finished!"),\n'
          ')',
        ),
        const SizedBox(height: 12),
        ...[
          (
            '⚡ Flash Sale',
            now.add(const Duration(hours: 2)),
            '{hh}:{mm}:{ss}',
            Colors.red,
          ),
          ('📅 End of Month', now.endOfMonth, '{d}d {h}h {m}m', Colors.teal),
          (
            '🎉 New Year',
            DateTime(now.year, 12, 31, 23, 59, 59),
            '{d}d {h}h {m}m {s}s',
            Colors.indigo,
          ),
          (
            '📞 Meeting',
            now.add(const Duration(minutes: 45)),
            '{mm}m {ss}s',
            Colors.orange,
          ),
        ].map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.$4,
                          ),
                        ),
                        Text(
                          'format: "${item.$3}"',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  CountdownText(
                    target: item.$2,
                    format: item.$3,
                    finishedText: '🎉 Done!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: item.$4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
