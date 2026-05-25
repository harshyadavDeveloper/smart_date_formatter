import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates [StreakCalculator], [DateGrouper],
/// [HolidayHelper] and [RecurrenceHelper].
class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  // Sample habit tracker dates
  static final _habitDates = [
    DateTime(2024, 6, 1),
    DateTime(2024, 6, 2),
    DateTime(2024, 6, 3),
    DateTime(2024, 6, 5),
    DateTime(2024, 6, 6),
    DateTime(2024, 6, 7),
    DateTime(2024, 6, 8),
    DateTime(2024, 6, 10),
    DateTime(2024, 6, 11),
    DateTime(2024, 6, 13),
    DateTime(2024, 6, 14),
    DateTime(2024, 6, 15),
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now(),
  ];

  // Sample activity dates for grouping
  static final _activityDates = [
    DateTime(2024, 6, 1, 9, 0),
    DateTime(2024, 6, 1, 9, 30),
    DateTime(2024, 6, 1, 14, 0),
    DateTime(2024, 6, 3, 9, 0),
    DateTime(2024, 6, 3, 11, 0),
    DateTime(2024, 6, 5, 9, 0),
    DateTime(2024, 6, 8, 14, 0),
    DateTime(2024, 6, 8, 14, 30),
    DateTime(2024, 6, 10, 9, 0),
    DateTime(2024, 6, 15, 16, 0),
    DateTime(2024, 7, 1, 9, 0),
    DateTime(2024, 7, 2, 9, 0),
  ];

  static final _holidays = HolidayHelper.indianHolidays(2024);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Streak Calculator ────────────────────────────
        const SectionHeader('StreakCalculator — Habit Tracking'),
        const SizedBox(height: 8),
        const CodeBox(
          'StreakCalculator.currentStreak(dates)   // 3\n'
          'StreakCalculator.longestStreak(dates)   // 4\n'
          'StreakCalculator.isTodayCompleted(dates) // true\n'
          'StreakCalculator.completionRate(dates, start, end)',
        ),
        const SizedBox(height: 12),
        _streakCard(),

        const SizedBox(height: 20),

        // ── Date Grouper ─────────────────────────────────
        const SectionHeader('DateGrouper — Group by Time Period'),
        const SizedBox(height: 8),
        const CodeBox(
          'DateGrouper.byDay(dates)\n'
          'DateGrouper.byMonth(dates)\n'
          'DateGrouper.mostActiveDay(dates)\n'
          'DateGrouper.mostActiveWeekday(dates)\n'
          'DateGrouper.averageGap(dates)',
        ),
        const SizedBox(height: 12),
        _grouperCard(),

        const SizedBox(height: 20),

        // ── Holiday Helper ───────────────────────────────
        const SectionHeader('HolidayHelper — Holiday Awareness'),
        const SizedBox(height: 8),
        const CodeBox(
          'HolidayHelper.isHoliday(date, holidays: list)\n'
          'HolidayHelper.isWorkingDay(date, holidays: list)\n'
          'HolidayHelper.addWorkingDays(date, 5, holidays: list)\n'
          'HolidayHelper.indianHolidays(2024)',
        ),
        const SizedBox(height: 12),
        _holidayCard(),

        const SizedBox(height: 20),

        // ── Recurrence Helper ────────────────────────────
        const SectionHeader('RecurrenceHelper — Recurring Dates'),
        const SizedBox(height: 8),
        const CodeBox(
          'RecurrenceHelper.daily(start: date, count: 7)\n'
          'RecurrenceHelper.weekly(start: date, count: 4)\n'
          'RecurrenceHelper.monthly(start: date, count: 3)\n'
          'RecurrenceHelper.yearly(start: date, count: 3)',
        ),
        const SizedBox(height: 12),
        _recurrenceCard(),
      ],
    );
  }

  // ── Streak Card ─────────────────────────────────────────────
  Widget _streakCard() {
    final current = StreakCalculator.currentStreak(_habitDates);
    final longest = StreakCalculator.longestStreak(_habitDates);
    final total = StreakCalculator.totalCompleted(_habitDates);
    final todayDone = StreakCalculator.isTodayCompleted(_habitDates);
    final allStreaks = StreakCalculator.allStreaks(_habitDates);
    final last = StreakCalculator.lastCompletedDate(_habitDates);
    final rate = StreakCalculator.completionRate(
      _habitDates,
      start: DateTime(2024, 6, 1),
      end: DateTime(2024, 6, 15),
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak stats row
            Row(
              children: [
                _statBox('🔥', '$current', 'Current\nStreak', Colors.orange),
                const SizedBox(width: 10),
                _statBox('🏆', '$longest', 'Longest\nStreak', Colors.indigo),
                const SizedBox(width: 10),
                _statBox('✅', '$total', 'Total\nDays', Colors.green),
                const SizedBox(width: 10),
                _statBox(
                  todayDone ? '⭐' : '❌',
                  todayDone ? 'Yes' : 'No',
                  'Today\nDone',
                  todayDone ? Colors.green : Colors.red,
                ),
              ],
            ),
            const Divider(height: 20),

            // Completion rate bar
            Row(
              children: [
                const Text(
                  'Completion Rate (Jun 1–15):',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  '${(rate * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rate,
                minHeight: 8,
                backgroundColor: Colors.indigo.shade50,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            ),
            const SizedBox(height: 12),

            // Last completed
            if (last != null)
              _row('Last completed', last.format('EEE, dd MMM yyyy')),

            // All streaks
            _row('Total streaks', '${allStreaks.length} runs'),
            ...allStreaks
                .take(3)
                .map(
                  (s) => _row(
                    '  ${s.first.format('dd MMM')} → ${s.last.format('dd MMM')}',
                    '${s.length} days',
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // ── Grouper Card ────────────────────────────────────────────
  Widget _grouperCard() {
    final byMonth = DateGrouper.countByMonth(_activityDates);
    final byWeekday = DateGrouper.countByWeekday(_activityDates);
    final byHour = DateGrouper.byHour(
      _activityDates,
    ).map((k, v) => MapEntry(k, v.length));
    final mostDay = DateGrouper.mostActiveDay(_activityDates);
    final mostWeekday = DateGrouper.mostActiveWeekday(_activityDates);
    final mostHour = DateGrouper.mostActiveHour(_activityDates);
    final avgGap = DateGrouper.averageGap(_activityDates);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // By Month
            const Text(
              'By Month:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 6),
            ...byMonth.entries.map(
              (e) => _barRow(
                e.key,
                e.value,
                byMonth.values.reduce((a, b) => a > b ? a : b),
                Colors.indigo,
              ),
            ),

            const Divider(height: 16),

            // By Weekday
            const Text(
              'By Weekday:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 6),
            ...byWeekday.entries.map(
              (e) => _barRow(
                e.key.substring(0, 3),
                e.value,
                byWeekday.values.reduce((a, b) => a > b ? a : b),
                Colors.teal,
              ),
            ),

            const Divider(height: 16),

            // By Hour
            const Text(
              'By Hour:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 6),
            ...byHour.entries.map(
              (e) => _barRow(
                '${e.key}:00',
                e.value,
                byHour.values.reduce((a, b) => a > b ? a : b),
                Colors.orange,
              ),
            ),

            const Divider(height: 16),

            // Insights
            const Text(
              'Insights:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            _row('Most active day', mostDay ?? '-'),
            _row('Most active weekday', mostWeekday ?? '-'),
            _row('Most active hour', mostHour != null ? '$mostHour:00' : '-'),
            _row('Average gap', avgGap != null ? '${avgGap.inDays} days' : '-'),
          ],
        ),
      ),
    );
  }

  // ── Holiday Card ────────────────────────────────────────────
  Widget _holidayCard() {
    final now = DateTime.now();
    final testDates = [
      DateTime(2024, 1, 26), // Republic Day
      DateTime(2024, 8, 15), // Independence Day
      DateTime(2024, 10, 2), // Gandhi Jayanti
      DateTime(2024, 12, 25), // Christmas
      DateTime(2024, 6, 17), // Normal Monday
      DateTime(2024, 6, 22), // Saturday
    ];

    final dec23 = DateTime(2024, 12, 23);
    final next3 = HolidayHelper.addWorkingDays(dec23, 3, holidays: _holidays);
    final nextWorkDay = HolidayHelper.nextWorkingDay(
      DateTime(2024, 12, 24),
      holidays: _holidays,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date checks
            const Text(
              'Date Checks (Indian Holidays):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            ...testDates.map((d) {
              final isHol = d.isHoliday(holidays: _holidays);
              d.isWorkingDay(holidays: _holidays);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text(
                      d.format('dd MMM yyyy'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    if (isHol)
                      _pill('Holiday', Colors.red)
                    else if (d.isWeekend)
                      _pill('Weekend', Colors.orange)
                    else
                      _pill('Working', Colors.green),
                  ],
                ),
              );
            }),

            const Divider(height: 16),

            // Working days calc
            const Text(
              'Working Days Calculation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            _row('Dec 23 + 3 working days', next3.format('EEE dd MMM')),
            _row(
              'Next working day after Dec 24',
              nextWorkDay.format('EEE dd MMM'),
            ),
            _row(
              'Indian holidays 2024',
              '${HolidayHelper.indianHolidays(2024).length} days',
            ),
            _row(
              'Today is holiday?',
              now.isHoliday(holidays: _holidays) ? '✅ Yes' : '❌ No',
            ),
            _row(
              'Today is working day?',
              now.isWorkingDay(holidays: _holidays) ? '✅ Yes' : '❌ No',
            ),
          ],
        ),
      ),
    );
  }

  // ── Recurrence Card ─────────────────────────────────────────
  Widget _recurrenceCard() {
    final start = DateTime(2024, 6, 3); // Monday

    final daily = RecurrenceHelper.daily(start: start, count: 5);
    final dailyNoWeekend = RecurrenceHelper.daily(
      start: start,
      count: 5,
      skipWeekends: true,
    );
    final weekly = RecurrenceHelper.weekly(start: start, count: 4);
    final monthly = RecurrenceHelper.monthly(
      start: DateTime(2024, 1, 15),
      count: 4,
    );
    final yearly = RecurrenceHelper.yearly(start: start, count: 3);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _recurrenceSection('Daily (count: 5)', daily, Colors.indigo),
            const SizedBox(height: 12),
            _recurrenceSection(
              'Daily skip weekends (count: 5)',
              dailyNoWeekend,
              Colors.teal,
            ),
            const SizedBox(height: 12),
            _recurrenceSection('Weekly (count: 4)', weekly, Colors.orange),
            const SizedBox(height: 12),
            _recurrenceSection(
              'Monthly from Jan 15 (count: 4)',
              monthly,
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _recurrenceSection('Yearly (count: 3)', yearly, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _recurrenceSection(String title, List<DateTime> dates, Color color) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: dates
                .map(
                  (d) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      d.format('EEE dd MMM'),
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );

  // ── Shared helpers ───────────────────────────────────────────

  Widget _statBox(String emoji, String value, String label, Color color) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
        ),
      );

  Widget _barRow(String label, int value, int max, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: max > 0 ? value / max : 0,
              minHeight: 10,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  Widget _pill(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
    ),
  );
}
