import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates SmartCalendar widget.
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

  final List<CalendarEvent> _events = [
    CalendarEvent(
      date: DateTime.now(),
      title: 'Team Standup',
      color: Colors.blue,
      description: 'Daily sync with team',
      allDay: false,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    ),
    CalendarEvent(
      date: DateTime.now(),
      title: 'Code Review',
      color: Colors.orange,
      description: 'Review PRs',
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
      description: 'v2.0.0 goes live!',
    ),
    CalendarEvent(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Design Review',
      color: Colors.pink,
    ),
    CalendarEvent(
      date: DateTime.now().subtract(const Duration(days: 5)),
      title: 'Client Meeting',
      color: Colors.teal,
      description: 'Q3 review call',
    ),
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 10)),
      title: 'Team Outing 🎉',
      color: Colors.amber,
      description: 'Annual team event',
    ),
    CalendarEvent(
      date: DateTime.now().add(const Duration(days: 15)),
      title: 'Performance Review',
      color: Colors.red,
    ),
    CalendarEvent(
      date: DateTime(DateTime.now().year, 12, 25),
      title: '🎄 Christmas',
      color: Colors.red,
      description: 'Public Holiday',
    ),
    CalendarEvent(
      date: DateTime(DateTime.now().year, 1, 1),
      title: '🎉 New Year',
      color: Colors.indigo,
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
        const SectionHeader('SmartCalendar — Full Featured Calendar Widget'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartCalendar(\n'
          '  events: [\n'
          '    CalendarEvent(\n'
          '      date: DateTime(2024, 6, 15),\n'
          "      title: 'Team Meeting',\n"
          '      color: Colors.blue,\n'
          '    ),\n'
          '  ],\n'
          '  onDateSelected: (date, events) => print(date),\n'
          '  markerStyle: EventMarkerStyle.dot,\n'
          '  initialView: CalendarView.month,\n'
          ')',
        ),
        const SizedBox(height: 12),

        // Marker style selector
        _markerStyleSelector(),
        const SizedBox(height: 12),

        // Calendar
        SmartCalendar(
          controller: _controller,
          events: _events,
          markerStyle: _markerStyle,
          selectedColor: Colors.indigo,
          todayColor: Colors.blue,
          showViewSwitcher: true,
          showTodayButton: true,
          onDateSelected: (date, events) {
            setState(() {
              _selectedDate = date;
              _selectedEvents = events;
            });
          },
          onEventTap: (event) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped: ${event.title}'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Selected date info
        if (_selectedDate != null) _selectedDateCard(),

        const SizedBox(height: 16),

        // Controller demo
        _controllerDemo(),

        const SizedBox(height: 16),

        // CalendarEvent properties
        _eventPropertiesDemo(),
      ],
    );
  }

  Widget _markerStyleSelector() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('EventMarkerStyle:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: EventMarkerStyle.values.map((style) {
                  final isSelected = _markerStyle == style;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _markerStyle = style),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                Text(
                  _selectedDate!.format('EEEE, dd MMMM yyyy'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 14,
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              Text(
                _selectedDate!.timeAgo,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (_selectedEvents.isEmpty) ...[
                const SizedBox(height: 8),
                const Text('No events on this day',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ] else ...[
                const Divider(height: 16),
                Text('${_selectedEvents.length} event(s):',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                ..._selectedEvents.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: e.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(color: e.color, width: 3),
                        ),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              if (e.description != null)
                                Text(e.description!,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
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
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ctrlBtn('⬅️ Prev Month', _controller.previousMonth),
                  _ctrlBtn('➡️ Next Month', _controller.nextMonth),
                  _ctrlBtn('📅 Today', _controller.goToToday),
                  _ctrlBtn('🎄 Christmas', () {
                    _controller.jumpToDate(
                      DateTime(DateTime.now().year, 12, 25),
                    );
                  }),
                  _ctrlBtn('🎉 New Year', () {
                    _controller.jumpToDate(
                      DateTime(DateTime.now().year + 1, 1, 1),
                    );
                  }),
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
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: Text(label),
      );

  Widget _eventPropertiesDemo() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CalendarEvent Properties',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              const CodeBox(
                'CalendarEvent(\n'
                '  date: DateTime(2024, 6, 15),\n'
                "  title: 'Meeting',\n"
                '  color: Colors.blue,\n'
                "  description: 'Optional description',\n"
                '  allDay: false,\n'
                '  startTime: TimeOfDay(hour: 10, minute: 0),\n'
                '  endTime: TimeOfDay(hour: 11, minute: 0),\n'
                ')\n'
                '\n'
                '// Check if on date\n'
                "event.isOnDate(DateTime.now()) // true\n"
                "event.timeString              // '10:00 AM – 11:00 AM'",
              ),
              const SizedBox(height: 12),
              ..._events.take(5).map((e) => Padding(
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
                        child: Text(e.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                      Text(e.date.calendar,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 8),
                      Text(e.timeString,
                          style: TextStyle(fontSize: 11, color: e.color)),
                    ]),
                  )),
            ],
          ),
        ),
      );
}
