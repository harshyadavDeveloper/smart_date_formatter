import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDateFormatter Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('smart_date_formatter',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('v1.1.0 — Full Example',
                  style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: '⏱ timeAgo'),
              Tab(text: '📅 Calendar'),
              Tab(text: '🎨 Format'),
              Tab(text: '🧮 Calculate'),
              Tab(text: '🌍 Locale'),
              Tab(text: '🔍 Parser'),
              Tab(text: '⏳ Widgets'),
              Tab(text: '🗄 Ranges'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TimeAgoTab(),
            _CalendarTab(),
            _FormatTab(),
            _CalculateTab(),
            _LocaleTab(),
            _ParserTab(),
            _WidgetsTab(),
            _RangesTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 1: timeAgo ───────────────────────────────────────────────────────
class _TimeAgoTab extends StatelessWidget {
  const _TimeAgoTab();

  @override
  Widget build(BuildContext context) {
    final items = [
      // Past
      ('Just now', DateTime.now().subtract(const Duration(seconds: 3))),
      ('30 seconds ago', DateTime.now().subtract(const Duration(seconds: 30))),
      ('1 minute ago', DateTime.now().subtract(const Duration(minutes: 1))),
      ('25 minutes ago', DateTime.now().subtract(const Duration(minutes: 25))),
      ('1 hour ago', DateTime.now().subtract(const Duration(hours: 1))),
      ('5 hours ago', DateTime.now().subtract(const Duration(hours: 5))),
      ('Yesterday', DateTime.now().subtract(const Duration(days: 1))),
      ('3 days ago', DateTime.now().subtract(const Duration(days: 3))),
      ('Last week', DateTime.now().subtract(const Duration(days: 9))),
      ('2 weeks ago', DateTime.now().subtract(const Duration(days: 15))),
      ('Last month', DateTime.now().subtract(const Duration(days: 35))),
      ('3 months ago', DateTime.now().subtract(const Duration(days: 90))),
      ('Last year', DateTime.now().subtract(const Duration(days: 400))),
      ('2 years ago', DateTime.now().subtract(const Duration(days: 800))),
      // Future
      ('In 30 seconds', DateTime.now().add(const Duration(seconds: 30))),
      ('In 5 minutes', DateTime.now().add(const Duration(minutes: 5))),
      ('Tomorrow', DateTime.now().add(const Duration(days: 1))),
      ('In 3 days', DateTime.now().add(const Duration(days: 3))),
      ('Next week', DateTime.now().add(const Duration(days: 8))),
      ('In 2 months', DateTime.now().add(const Duration(days: 65))),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('date.timeAgo — Relative Time Strings'),
        const SizedBox(height: 8),
        _codeBox(
            'DateTime.now().subtract(Duration(hours: 2)).timeAgo\n// "2 hours ago"'),
        const SizedBox(height: 12),
        ...items.map((item) => _tile(item.$1, item.$2.timeAgo)),
      ],
    );
  }
}

// ─── Tab 2: Calendar ──────────────────────────────────────────────────────
class _CalendarTab extends StatelessWidget {
  const _CalendarTab();

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Today', DateTime.now()),
      ('Yesterday', DateTime.now().subtract(const Duration(days: 1))),
      ('Tomorrow', DateTime.now().add(const Duration(days: 1))),
      ('In 2 days', DateTime.now().add(const Duration(days: 2))),
      ('In 5 days', DateTime.now().add(const Duration(days: 5))),
      ('Last week', DateTime.now().subtract(const Duration(days: 4))),
      ('2 weeks ago', DateTime.now().subtract(const Duration(days: 10))),
      ('Old date', DateTime(2023, 3, 7)),
      ('Christmas 2023', DateTime(2023, 12, 25)),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('date.calendar — Smart Calendar Strings'),
        const SizedBox(height: 8),
        _codeBox('DateTime.now().calendar           // "Today"\n'
            'DateTime.now().shortTimestamp     // "2:30 PM"'),
        const SizedBox(height: 12),
        ...items.map((item) => _tile(
              item.$1,
              '${item.$2.calendar}  •  ${item.$2.shortTimestamp}',
            )),
      ],
    );
  }
}

// ─── Tab 3: Format ────────────────────────────────────────────────────────
class _FormatTab extends StatelessWidget {
  const _FormatTab();

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formats = [
      ("format('dd-MM-yyyy')", date.format('dd-MM-yyyy')),
      ("format('MM/dd/yyyy')", date.format('MM/dd/yyyy')),
      ("format('MMM dd, yyyy')", date.format('MMM dd, yyyy')),
      ("format('MMMM dd, yyyy')", date.format('MMMM dd, yyyy')),
      ("format('EEEE')", date.format('EEEE')),
      ("format('EEE, dd MMM yy')", date.format('EEE, dd MMM yy')),
      ("format('hh:mm a')", date.format('hh:mm a')),
      ("format('HH:mm:ss')", date.format('HH:mm:ss')),
      ("format('EEEE, dd MMMM yyyy')", date.format('EEEE, dd MMMM yyyy')),
      ('toReadable', date.toReadable),
      ('toISO', date.toISO),
      ('toTimeString', date.toTimeString),
      ('to12Hour', date.to12Hour),
      ('to24Hour', date.to24Hour),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('date.format(pattern) — Custom Patterns'),
        const SizedBox(height: 8),
        _codeBox("DateTime.now().format('dd-MM-yyyy') // '15-06-2024'\n"
            "DateTime.now().toReadable           // 'Saturday, 15 June 2024'"),
        const SizedBox(height: 12),
        ...formats.map((f) => _monoTile(f.$1, f.$2)),
      ],
    );
  }
}

// ─── Tab 4: Calculations ──────────────────────────────────────────────────
class _CalculateTab extends StatelessWidget {
  const _CalculateTab();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final birth = DateTime(1999, 5, 20);
    final deadline = now.add(const Duration(days: 15));

    final items = [
      // Boolean helpers
      ('isToday', '${now.isToday}'),
      ('isYesterday', '${now.subtract(const Duration(days: 1)).isYesterday}'),
      ('isTomorrow', '${now.add(const Duration(days: 1)).isTomorrow}'),
      ('isPast', '${birth.isPast}'),
      ('isFuture', '${deadline.isFuture}'),
      ('isWeekend', '${now.isWeekend}'),
      ('isWeekday', '${now.isWeekday}'),
      // Time of day
      ('isMorning', '${now.isMorning}'),
      ('isAfternoon', '${now.isAfternoon}'),
      ('isEvening', '${now.isEvening}'),
      ('isNight', '${now.isNight}'),
      // Quarter
      ('quarter', '${now.quarter}'),
      ('isQ1', '${now.isQ1}'),
      ('isQ2', '${now.isQ2}'),
      ('isQ3', '${now.isQ3}'),
      ('isQ4', '${now.isQ4}'),
      // Year
      ('weekOfYear', '${now.weekOfYear}'),
      ('dayOfYear', '${now.dayOfYear}'),
      ('isLeapYear', '${now.isLeapYear}'),
      // Calculations
      ('age (born 1999-05-20)', '${birth.age} years'),
      ('daysUntil deadline', '${now.daysUntil(deadline)} days'),
      ('daysSince birth', '${now.daysSince(birth)} days'),
      ('addWorkingDays(5)', now.addWorkingDays(5).format('EEE dd MMM')),
      ('workingDaysUntil deadline', '${now.workingDaysUntil(deadline)} days'),
      ('isBetween(birth, deadline)', '${now.isBetween(birth, deadline)}'),
      // Boundaries
      ('startOfDay', now.startOfDay.toISO),
      ('endOfDay', now.endOfDay.toISO),
      ('startOfWeek', now.startOfWeek.format('EEE dd MMM')),
      ('endOfWeek', now.endOfWeek.format('EEE dd MMM')),
      ('startOfMonth', now.startOfMonth.format('dd MMM yyyy')),
      ('endOfMonth', now.endOfMonth.format('dd MMM yyyy')),
      ('startOfYear', now.startOfYear.format('dd MMM yyyy')),
      ('endOfYear', now.endOfYear.format('dd MMM yyyy')),
      // isSame
      ('isSameDay(now)', '${now.isSameDay(DateTime.now())}'),
      ('isSameWeek(now)', '${now.isSameWeek(DateTime.now())}'),
      ('isSameMonth(now)', '${now.isSameMonth(DateTime.now())}'),
      ('isSameYear(now)', '${now.isSameYear(DateTime.now())}'),
      // Next/Previous weekday
      ('nextMonday', now.nextMonday.format('EEE dd MMM')),
      ('nextFriday', now.nextFriday.format('EEE dd MMM')),
      ('previousMonday', now.previousMonday.format('EEE dd MMM')),
      ('previousFriday', now.previousFriday.format('EEE dd MMM')),
      // copyWith
      ('copyWith(hour: 0)', now.copyWith(hour: 0, minute: 0, second: 0).toISO),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('All Calculation & Boolean Extensions'),
        const SizedBox(height: 8),
        _codeBox('DateTime(1999,5,20).age          // 25\n'
            'DateTime.now().addWorkingDays(5) // skips weekends\n'
            'DateTime.now().nextFriday        // next Friday date'),
        const SizedBox(height: 12),
        ...items.map((item) => _tile(item.$1, item.$2)),
      ],
    );
  }
}

// ─── Tab 5: Locale ────────────────────────────────────────────────────────
class _LocaleTab extends StatelessWidget {
  const _LocaleTab();

  @override
  Widget build(BuildContext context) {
    final date2h = DateTime.now().subtract(const Duration(hours: 2));
    final date1d = DateTime.now().subtract(const Duration(days: 1));
    final date1w = DateTime.now().subtract(const Duration(days: 8));
    final date1m = DateTime.now().subtract(const Duration(days: 35));

    final locales = [
      (SdfLocale.en, '🇬🇧', 'English'),
      (SdfLocale.hi, '🇮🇳', 'Hindi'),
      (SdfLocale.es, '🇪🇸', 'Spanish'),
      (SdfLocale.fr, '🇫🇷', 'French'),
      (SdfLocale.ja, '🇯🇵', 'Japanese'),
      (SdfLocale.ar, '🇸🇦', 'Arabic'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('Multi-Language Localization'),
        const SizedBox(height: 8),
        _codeBox('SmartDateFormatter(locale: SdfLocale.hi).format(date)\n'
            'date.timeAgoIn(SdfLocale.hi) // "2 घंटे पहले"'),
        const SizedBox(height: 12),
        ...locales.map((l) {
          final fmt = SmartDateFormatter(locale: l.$1);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(l.$2, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(l.$3,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.indigo)),
                    const Spacer(),
                    _badge('locale: ${l.$1.code}'),
                  ]),
                  const Divider(height: 14),
                  _localeRow('2h ago', fmt.format(date2h)),
                  _localeRow('Yesterday', fmt.format(date1d)),
                  _localeRow('Last week', fmt.format(date1w)),
                  _localeRow('Last month', fmt.format(date1m)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _localeRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

// ─── Tab 6: Parser ────────────────────────────────────────────────────────
class _ParserTab extends StatelessWidget {
  const _ParserTab();

  @override
  Widget build(BuildContext context) {
    final expressions = [
      'today',
      'tomorrow',
      'yesterday',
      'in 3 days',
      'in 2 weeks',
      'in 1 month',
      '3 days ago',
      '2 weeks ago',
      'next monday',
      'last friday',
      'next week',
      'last week',
      'next month',
      'last year',
      '2024-06-15',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('SmartParser — Natural Language → DateTime'),
        const SizedBox(height: 8),
        _codeBox('SmartParser.parse("tomorrow")    // DateTime\n'
            'SmartParser.parse("next monday") // DateTime\n'
            'SmartParser.canParse("in 3 days") // true'),
        const SizedBox(height: 12),
        ...expressions.map((expr) {
          final result = SmartParser.parse(expr);
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: result != null
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                child: Icon(
                  result != null ? Icons.check : Icons.close,
                  color: result != null ? Colors.green : Colors.red,
                  size: 14,
                ),
              ),
              title: Text('"$expr"',
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600)),
              trailing: result != null
                  ? Text(result.format('dd MMM yyyy'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12))
                  : const Text('null', style: TextStyle(color: Colors.red)),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Tab 7: Widgets ───────────────────────────────────────────────────────
class _WidgetsTab extends StatelessWidget {
  const _WidgetsTab();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // TimeAgoText
        _sectionHeader('TimeAgoText — Auto Refreshing Widget'),
        const SizedBox(height: 8),
        _codeBox('TimeAgoText(\n'
            '  date: message.sentAt,\n'
            '  locale: SdfLocale.hi,\n'
            '  refreshRate: Duration(seconds: 30),\n'
            ')'),
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
            SdfLocale.es,
            '🇪🇸 Spanish',
            Colors.purple
          ),
          (
            now.subtract(const Duration(days: 1)),
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

        const SizedBox(height: 24),

        // CountdownText
        _sectionHeader('CountdownText — Live Countdown Widget'),
        const SizedBox(height: 8),
        _codeBox('CountdownText(\n'
            '  target: event.startsAt,\n'
            '  format: \'{d}d {h}h {m}m {s}s\',\n'
            '  onFinished: () => print("Done!"),\n'
            ')'),
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
      ],
    );
  }
}

// ─── Tab 8: Ranges ────────────────────────────────────────────────────────
class _RangesTab extends StatelessWidget {
  const _RangesTab();

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
        _sectionHeader('DateRangeHelper — Ready-made DB Query Ranges'),
        const SizedBox(height: 8),
        _codeBox('final range = DateRangeHelper.thisMonth();\n'
            'await db.query(\n'
            '  where: "created_at BETWEEN ? AND ?",\n'
            '  whereArgs: [range.start.toISO, range.end.toISO],\n'
            ');\n'
            'range.contains(DateTime.now()); // true\n'
            'range.days;                      // 30'),
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
                      Text('DateRangeHelper.${r.$1}',
                          style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                      if (containsToday) _badge('today ✓'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${range.start.format('dd MMM yyyy')} → '
                    '${range.end.format('dd MMM yyyy')}  •  ${range.days} days',
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

// ─── Shared Helpers ───────────────────────────────────────────────────────

Widget _tile(String label, String value) => Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        title: Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        trailing: Text(value,
            style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ),
    );

Widget _monoTile(String label, String value) => Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        title: Text(label,
            style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.indigo,
                fontWeight: FontWeight.w600)),
        trailing: Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );

Widget _sectionHeader(String title) => Text(title,
    style: const TextStyle(
        fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600));

Widget _codeBox(String code) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(code,
            style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFFCDD6F4))),
      ),
    );

Widget _badge(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
    );
