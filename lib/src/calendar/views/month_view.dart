import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/calendar_header.dart';
import '../widgets/day_cell.dart';

/// Displays a full month grid calendar view.
///
/// Used internally by [SmartCalendar].
///
/// ```dart
/// MonthView(
///   controller: controller,
///   events: events,
///   onDateSelected: (date, events) => print(date),
/// )
/// ```
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

  /// Show week numbers on left side
  final bool showWeekNumbers;

  /// Whether dark theme is active
  final bool isDark;

  /// Range selection start date
  final DateTime? rangeStart;

  /// Range selection end date
  final DateTime? rangeEnd;

  /// Custom cell builder for month view dates.
  ///
  /// ```dart
  /// SmartCalendar(
  ///   cellBuilder: (date, events, isSelected, isToday) {
  ///     return Container(
  ///       decoration: BoxDecoration(
  ///         color: isSelected ? Colors.indigo : null,
  ///         borderRadius: BorderRadius.circular(8),
  ///       ),
  ///       child: Column(children: [
  ///         Text('${date.day}'),
  ///         if (events.isNotEmpty)
  ///           Icon(Icons.circle, size: 6, color: events.first.color),
  ///       ]),
  ///     );
  ///   },
  /// )
  /// ```
  final Widget Function(
    DateTime date,
    List<CalendarEvent> events,
    bool isSelected,
    bool isToday,
  )? cellBuilder;

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
    this.showWeekNumbers = false,
    this.isDark = false,
    this.cellBuilder,
    this.rangeStart,
    this.rangeEnd,
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
                children: [
                  // Week number empty header
                  if (showWeekNumbers)
                    SizedBox(
                      width: 28,
                      child: Text(
                        'W',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ...weekdays.map((day) => Expanded(
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      )),
                ],
              ),
            const SizedBox(height: 4),
            _buildCalendarGrid(days),
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

  Widget _buildCalendarGrid(List<DateTime> days) {
    // Group days into weeks (7 days each)
    final weeks = <List<DateTime>>[];
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return Column(
      children: weeks.map((week) {
        return Row(
          children: [
            // ── Week number ────────────────────────────
            if (showWeekNumbers)
              SizedBox(
                width: 28,
                child: Text(
                  '${_weekNumber(week.first)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ),
                ),
              ),

            // ── 7 day cells ────────────────────────────
            ...week.map((date) {
              final dayEvents = _eventsForDate(date);
              final isCurrentMonth = date.month == controller.focusedDate.month;
              final isSelected = date.isSameDay(controller.selectedDate);
              final isToday = date.isToday;
              final isWeekend = date.isWeekend;

              return Expanded(
                child: cellBuilder != null
                    ? GestureDetector(
                        onTap: () {
                          controller.selectDate(date);
                          onDateSelected?.call(date, dayEvents);
                        },
                        child: cellBuilder!(
                          date,
                          dayEvents,
                          isSelected,
                          isToday,
                        ),
                      )
                    : _buildRangeCell(date, dayEvents, isSelected, isToday,
                        isCurrentMonth, isWeekend),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear + firstDayOfYear.weekday - 2) / 7).ceil().clamp(1, 53);
  }

  bool _isInSelectedRange(DateTime date) {
    if (rangeStart == null || rangeEnd == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(rangeStart!.year, rangeStart!.month, rangeStart!.day);
    final e = DateTime(rangeEnd!.year, rangeEnd!.month, rangeEnd!.day);
    return d.isAfter(s) && d.isBefore(e);
  }

  bool _isRangeStart(DateTime date) =>
      rangeStart != null && date.isSameDay(rangeStart!);

  bool _isRangeEnd(DateTime date) =>
      rangeEnd != null && date.isSameDay(rangeEnd!);

  Widget _buildRangeCell(
    DateTime date,
    List<CalendarEvent> events,
    bool isSelected,
    bool isToday,
    bool isCurrentMonth,
    bool isWeekend,
  ) {
    final inRange = _isInSelectedRange(date);
    final isStart = _isRangeStart(date);
    final isEnd = _isRangeEnd(date);

    return GestureDetector(
      onTap: () {
        controller.selectDate(date);
        onDateSelected?.call(date, events);
      },
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isStart || isEnd
              ? selectedColor
              : inRange
                  ? selectedColor.withOpacity(0.12)
                  : Colors.transparent,
          borderRadius: isStart
              ? const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              : isEnd
                  ? const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )
                  : inRange
                      ? BorderRadius.zero
                      : BorderRadius.circular(8),
        ),
        child: DayCell(
          date: date,
          events: events,
          isSelected: isSelected || isStart || isEnd,
          isToday: isToday,
          isCurrentMonth: isCurrentMonth,
          isWeekend: isWeekend,
          markerStyle: markerStyle,
          selectedColor: selectedColor,
          todayColor: todayColor,
          isDark: isDark,
        ),
      ),
    );
  }
}
