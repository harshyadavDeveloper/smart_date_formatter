import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates SmartCalendar widget with all views.
class CalendarWidgetTab extends StatefulWidget {
  const CalendarWidgetTab({super.key});

  @override
  State<CalendarWidgetTab> createState() => _CalendarWidgetTabState();
}

class _CalendarWidgetTabState extends State<CalendarWidgetTab> {
  final _controller = SmartCalendarController();
  DateTime? _selectedDate;
  List<CalendarEvent> _selectedEvents = [];
  EventMarkerStyle _markerStyle = EventMarkerStyle.dot;
  final CalendarView _currentView = CalendarView.month;

  final List<CalendarEvent> _events = [
    // Single day events
    CalendarEvent(
      date: DateTime.now(),
      title: 'Team Standup',
      color: Colors.blue,
      description: 'Daily sync',
      allDay: false,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    ),
    CalendarEvent(
      date: DateTime.now(),
      title: 'Code Review',
      color: Colors.orange,
      allDay: false,
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 0),
    ),
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 1)),
      title: 'Product Demo',
      color: Colors.green,
      description: 'Demo to stakeholders',
    ),
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 2)),
      title: 'Sprint Planning',
      color: Colors.purple,
      allDay: false,
      startTime: const TimeOfDay(hour: 9, minute: 0),
    ),
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 5)),
      title: 'Release Day 🚀',
      color: Colors.indigo,
      description: 'v2.1.0 goes live!',
    ),

    // Multi-day events 🆕
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 6)),
      title: 'Company Retreat 🏕️',
      color: Colors.teal,
      description: 'Annual team retreat',
    ),
    CalendarEvent(
      date: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      title: 'Design Sprint',
      color: Colors.pink,
      description: 'UX design sprint',
    ),
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 12)),
      title: 'Flutter Conference 🎯',
      color: Colors.blue,
      description: 'FlutterConf 2024',
    ),

    // Holidays
    CalendarEvent(
      date: DateTime(DateTime.now().year, 12, 25),
      title: '🎄 Christmas',
      color: Colors.red,
      description: 'Public Holiday',
    ),
    CalendarEvent(
      date: DateTime(DateTime.now().year, 1, 26),
      title: '🇮🇳 Republic Day',
      color: Colors.orange,
      description: 'National Holiday',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('SmartCalendar v2.1.0 — All Views'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartCalendar(\n'
          '  events: events,\n'
          '  initialView: CalendarView.agenda, // month/week/day/agenda\n'
          '  markerStyle: EventMarkerStyle.both,\n'
          '  onDateSelected: (date, events) {},\n'
          '  // Swipe left/right to navigate!\n'
          ')',
        ),
        const SizedBox(height: 12),

        // Controls row
        _controlsRow(),
        const SizedBox(height: 12),

        // Calendar
        SmartCalendar(
          controller: _controller,
          events: _events,
          markerStyle: _markerStyle,
          initialView: _currentView,
          selectedColor: Colors.indigo,
          todayColor: Colors.blue,
          showViewSwitcher: true,
          showTodayButton: true,
          agendaDaysAhead: 60,
          agendaDaysBehind: 14,
          onDateSelected: (date, events) {
            setState(() {
              _selectedDate = date;
              _selectedEvents = events;
            });
          },
          onEventTap: (event) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('📌 ${event.title}'
                    '${event.isMultiDay ? " (${event.spanDays} days)" : ""}'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Swipe hint
        _swipeHintCard(),
        const SizedBox(height: 16),

        // Selected date
        if (_selectedDate != null) _selectedDateCard(),
        const SizedBox(height: 16),

        // Multi-day events section
        _multiDaySection(),
        const SizedBox(height: 16),

        // Controller demo
        _controllerDemo(),
        const SizedBox(height: 16),

        // Event properties
        _eventPropertiesCard(),
      ],
    );
  }

  // ── Controls ──────────────────────────────────────────────────
  Widget _controlsRow() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Marker style
              const Text('EventMarkerStyle:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                children: EventMarkerStyle.values.map((style) {
                  final isSelected = _markerStyle == style;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _markerStyle = style),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.indigo : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          style.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );

  // ── Swipe Hint ────────────────────────────────────────────────
  Widget _swipeHintCard() => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.indigo.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('👈', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Swipe left/right to navigate between months',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(width: 8),
            Text('👉', style: TextStyle(fontSize: 16)),
          ],
        ),
      );

  // ── Selected Date ─────────────────────────────────────────────
  Widget _selectedDateCard() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.event, color: Colors.indigo, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedDate!.format('EEEE, dd MMMM yyyy'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              Text(_selectedDate!.timeAgo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (_selectedEvents.isEmpty) ...[
                const SizedBox(height: 8),
                const Text('No events',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ] else ...[
                const Divider(height: 16),
                Text(
                  '${_selectedEvents.length} event(s):',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                ..._selectedEvents.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: e.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border(left: BorderSide(color: e.color, width: 3)),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(e.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                if (e.isMultiDay) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: e.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${e.spanDays}d',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: e.color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ]),
                              if (e.description != null)
                                Text(e.description!,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              if (e.isMultiDay)
                                Text(e.dateRangeString,
                                    style: TextStyle(
                                        fontSize: 10, color: e.color)),
                            ],
                          ),
                        ),
                        Text(e.timeString,
                            style: TextStyle(
                                fontSize: 11,
                                color: e.color,
                                fontWeight: FontWeight.w600)),
                      ]),
                    )),
              ],
            ],
          ),
        ),
      );

  // ── Multi-day Events ──────────────────────────────────────────
  Widget _multiDaySection() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🆕 Multi-Day Events',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              const CodeBox(
                'CalendarEvent(\n'
                '  date: DateTime(2024, 6, 15),\n'
                '  endDate: DateTime(2024, 6, 17), // 👈 multi-day\n'
                "  title: 'Company Retreat',\n"
                '  color: Colors.teal,\n'
                ')\n'
                '\n'
                'event.isMultiDay       // true\n'
                'event.spanDays         // 3\n'
                'event.dateRangeString  // "15/6/2024 – 17/6/2024"\n'
                'event.isOnDate(date)   // true for any day in range',
              ),
              const SizedBox(height: 12),
              ..._events.where((e) => e.isMultiDay).map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: e.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border(left: BorderSide(color: e.color, width: 4)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(e.dateRangeString,
                                style: TextStyle(fontSize: 11, color: e.color)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: e.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${e.spanDays} days',
                          style: TextStyle(
                              fontSize: 11,
                              color: e.color,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                  )),
            ],
          ),
        ),
      );

  // ── Controller Demo ───────────────────────────────────────────
  Widget _controllerDemo() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SmartCalendarController',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              const CodeBox(
                'final controller = SmartCalendarController();\n'
                'controller.nextMonth();\n'
                'controller.previousWeek();\n'
                'controller.jumpToDate(DateTime(2024, 12, 25));\n'
                'controller.goToToday();',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ctrlBtn('⬅️ Prev Month', _controller.previousMonth),
                  _ctrlBtn('➡️ Next Month', _controller.nextMonth),
                  _ctrlBtn('📅 Today', _controller.goToToday),
                  _ctrlBtn('🎄 Christmas', () {
                    _controller
                        .jumpToDate(DateTime(DateTime.now().year, 12, 25));
                  }),
                  _ctrlBtn('🇮🇳 Republic Day', () {
                    _controller
                        .jumpToDate(DateTime(DateTime.now().year, 1, 26));
                  }),
                  _ctrlBtn('⬅️ Prev Week', _controller.previousWeek),
                  _ctrlBtn('➡️ Next Week', _controller.nextWeek),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _ctrlBtn(String label, VoidCallback onTap) => ElevatedButton(
        onPressed: () {
          onTap();
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade50,
          foregroundColor: Colors.indigo,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 11),
        ),
        child: Text(label),
      );

  // ── Event Properties ──────────────────────────────────────────
  Widget _eventPropertiesCard() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Events',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              ..._events.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: e.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(e.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              if (e.isMultiDay) ...[
                                const SizedBox(width: 4),
                                Text('(${e.spanDays}d)',
                                    style: TextStyle(
                                        fontSize: 10, color: e.color)),
                              ],
                            ]),
                            Text(
                              e.isMultiDay
                                  ? e.dateRangeString
                                  : e.date.calendar,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(e.timeString,
                          style: TextStyle(fontSize: 10, color: e.color)),
                    ]),
                  )),
            ],
          ),
        ),
      );
}
