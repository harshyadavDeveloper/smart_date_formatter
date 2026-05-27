import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/demo_section.dart';
import '../widgets/demo_code_box.dart';

/// Demonstrates TimeAgoText, CountdownText,
/// DateBadge, SmartDateText, RelativeDateBuilder.
class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── TimeAgoText ────────────────────────────────────
        const DemoSection('TimeAgoText — Auto Refreshing'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'TimeAgoText(\n'
          '  date: message.sentAt,\n'
          '  locale: SdfLocale.hi,\n'
          '  refreshRate: Duration(seconds: 30),\n'
          ')',
        ),
        const SizedBox(height: 12),
        ...[
          (
            now.subtract(const Duration(seconds: 5)),
            SdfLocale.en,
            '🇬🇧 English',
            Colors.indigo
          ),
          (
            now.subtract(const Duration(minutes: 2)),
            SdfLocale.hi,
            '🇮🇳 Hindi',
            Colors.orange
          ),
          (
            now.subtract(const Duration(hours: 3)),
            SdfLocale.mr,
            '🇮🇳 Marathi',
            Colors.teal
          ),
          (
            now.subtract(const Duration(days: 1)),
            SdfLocale.de,
            '🇩🇪 German',
            Colors.purple
          ),
          (
            now.subtract(const Duration(days: 8)),
            SdfLocale.ja,
            '🇯🇵 Japanese',
            Colors.red
          ),
        ].map((item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(Icons.access_time, color: item.$4),
                title: Text(item.$3,
                    style:
                        TextStyle(color: item.$4, fontWeight: FontWeight.w600)),
                trailing: TimeAgoText(
                  date: item.$1,
                  locale: item.$2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            )),

        const SizedBox(height: 20),

        // ── CountdownText ──────────────────────────────────
        const DemoSection('CountdownText — Live Countdown'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'CountdownText(\n'
          '  target: event.startsAt,\n'
          "  format: '{d}d {h}h {m}m {s}s',\n"
          "  finishedText: 'Done!',\n"
          ')',
        ),
        const SizedBox(height: 12),
        ...[
          (
            '⚡ Flash Sale',
            now.add(const Duration(hours: 2)),
            '{hh}:{mm}:{ss}',
            Colors.red
          ),
          ('📅 End of Month', now.endOfMonth, '{d}d {h}h {m}m', Colors.teal),
          (
            '🎉 New Year',
            DateTime(now.year, 12, 31, 23, 59, 59),
            '{d}d {h}h {m}m {s}s',
            Colors.indigo
          ),
          (
            '📞 Meeting',
            now.add(const Duration(minutes: 45)),
            '{mm}m {ss}s',
            Colors.orange
          ),
        ].map((item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: item.$4)),
                        Text('format: "${item.$3}"',
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontFamily: 'monospace')),
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
                        color: item.$4),
                  ),
                ]),
              ),
            )),

        const SizedBox(height: 20),

        // ── DateBadge ──────────────────────────────────────
        const DemoSection('DateBadge — Smart Date Chips'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'DateBadge(date: DateTime.now())\n'
          'DateBadge(date: date, style: DateBadgeStyle.outlined)\n'
          'DateBadge(date: date, style: DateBadgeStyle.flat)',
        ),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _badgeRow('chip', [
                  DateBadge(date: now),
                  DateBadge(date: now.subtract(const Duration(days: 1))),
                  DateBadge(date: now.add(const Duration(days: 1))),
                  DateBadge(date: now.add(const Duration(days: 3))),
                  DateBadge(date: now.subtract(const Duration(days: 30))),
                ]),
                const SizedBox(height: 10),
                _badgeRow('outlined', [
                  DateBadge(date: now, style: DateBadgeStyle.outlined),
                  DateBadge(
                      date: now.subtract(const Duration(days: 1)),
                      style: DateBadgeStyle.outlined),
                  DateBadge(
                      date: now.add(const Duration(days: 1)),
                      style: DateBadgeStyle.outlined),
                ]),
                const SizedBox(height: 10),
                _badgeRow('flat', [
                  DateBadge(date: now, style: DateBadgeStyle.flat),
                  DateBadge(
                      date: now.subtract(const Duration(days: 1)),
                      style: DateBadgeStyle.flat),
                  DateBadge(
                      date: now.add(const Duration(days: 1)),
                      style: DateBadgeStyle.flat),
                ]),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── SmartDateText ──────────────────────────────────
        const DemoSection('SmartDateText — All-in-One Widget'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'SmartDateText(date: date, mode: SmartDateMode.auto)\n'
          'SmartDateText(date: date, mode: SmartDateMode.calendar)\n'
          "SmartDateText(date: date, mode: SmartDateMode.custom, pattern: 'dd-MM-yyyy')",
        ),
        const SizedBox(height: 12),
        ...SmartDateMode.values.map((mode) => Card(
              margin: const EdgeInsets.only(bottom: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                dense: true,
                title: Text(
                  mode.name,
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600),
                ),
                trailing: SmartDateText(
                  date: now.subtract(const Duration(hours: 2)),
                  mode: mode,
                  pattern: 'dd MMM yyyy',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )),

        const SizedBox(height: 20),

        // ── RelativeDateBuilder ────────────────────────────
        const DemoSection('RelativeDateBuilder — Custom UI'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'RelativeDateBuilder(\n'
          '  date: post.createdAt,\n'
          '  builder: (ctx, timeAgo, calendar, timestamp, date) {\n'
          '    return Row(children: [\n'
          '      Icon(Icons.access_time, size: 12),\n'
          '      Text(timeAgo),\n'
          "      if (date.isToday) Badge(label: Text('NEW')),\n"
          '    ]);\n'
          '  },\n'
          ')',
        ),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: RelativeDateBuilder(
              date: now.subtract(const Duration(hours: 2)),
              builder: (ctx, timeAgo, calendar, timestamp, date) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(timeAgo,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.indigo)),
                    const SizedBox(width: 8),
                    if (date.isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('TODAY',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ),
                  ]),
                  const SizedBox(height: 4),
                  Text('calendar: $calendar',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('timestamp: $timestamp',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _badgeRow(String label, List<Widget> badges) => Row(
        children: [
          Text('$label: ',
              style: const TextStyle(
                  fontSize: 11, color: Colors.grey, fontFamily: 'monospace')),
          Wrap(
            spacing: 6,
            children: badges,
          ),
        ],
      );
}
