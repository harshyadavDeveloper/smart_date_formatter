import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/calendar_header.dart';
import '../widgets/day_cell.dart';

/// Month view for [SmartCalendar].
class MonthView extends StatelessWidget {
  /// Controller
  final SmartCalendarController controller;

  /// All events
  final List<CalendarEvent> events;

  /// Called when a date is selected
  final void Function(DateTime date, List<CalendarEvent> events)?
      onDateSelected;

  /// Called when event is tapped
  final void Function(CalendarEvent event)? onEventTap;

  /// Marker style
  final EventMarkerStyle markerStyle;

  /// Selected date color
  final Color selectedColor;

  /// Today color
  final Color todayColor;

  /// Header color
  final Color headerColor;

  /// Show weekday headers
  final bool showWeekdayHeaders;

  /// First day of week (1=Monday, 7=Sunday)
  final int firstDayOfWeek;

  /// Creates a [MonthView].
  const MonthView({
    super.key,
    required this.controller,
    required this.events,
    this.onDateSelected,
    this.onEventTap,
    this.markerStyle = EventMarkerStyle.dot,
    this.selectedColor = Colors.indigo,
    this.todayColor = Colors.blue,
    this.headerColor = Colors.black87,
    this.showWeekdayHeaders = true,
    this.firstDayOfWeek = 1,
  });

  List<DateTime> _daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // Days from previous month to fill first week
    int startWeekday = firstDay.weekday - firstDayOfWeek;
    if (startWeekday < 0) startWeekday += 7;

    final days = <DateTime>[];

    // Previous month days
    for (int i = startWeekday - 1; i >= 0; i--) {
      days.add(firstDay.subtract(Duration(days: i + 1)));
    }

    // Current month days
    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    // Next month days to complete grid
    final int remaining = 42 - days.length;
    for (int i = 1; i <= remaining; i++) {
      days.add(lastDay.add(Duration(days: i)));
    }

    return days;
  }

  List<CalendarEvent> _eventsForDate(DateTime date) =>
      events.where((e) => e.isOnDate(date)).toList();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final days = _daysInMonth(controller.focusedDate);
        final weekdays = _weekdayHeaders();

        return Column(
          children: [
            CalendarHeader(
              focusedDate: controller.focusedDate,
              onPrevious: controller.previousMonth,
              onNext: controller.nextMonth,
              onTitleTap: controller.goToToday,
              color: headerColor,
            ),
            const SizedBox(height: 8),
            if (showWeekdayHeaders)
              Row(
                children: weekdays
                    .map((day) => Expanded(
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 4),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final dayEvents = _eventsForDate(date);
                final isCurrentMonth =
                    date.month == controller.focusedDate.month;
                final isSelected = date.isSameDay(controller.selectedDate);
                final isToday = date.isToday;
                final isWeekend = date.isWeekend;

                return DayCell(
                  date: date,
                  events: dayEvents,
                  isSelected: isSelected,
                  isToday: isToday,
                  isCurrentMonth: isCurrentMonth,
                  isWeekend: isWeekend,
                  markerStyle: markerStyle,
                  selectedColor: selectedColor,
                  todayColor: todayColor,
                  onTap: () {
                    controller.selectDate(date);
                    onDateSelected?.call(date, dayEvents);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<String> _weekdayHeaders() {
    const allDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final offset = firstDayOfWeek - 1;
    return [
      ...allDays.sublist(offset),
      ...allDays.sublist(0, offset),
    ];
  }
}
