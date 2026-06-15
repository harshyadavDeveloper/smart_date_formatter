import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

/// Agenda (list) view for [SmartCalendar].
///
/// Shows events in a chronological list grouped by date.
class AgendaView extends StatelessWidget {
  /// Controller
  final SmartCalendarController controller;

  /// All events
  final List<CalendarEvent> events;

  /// Called when a date is selected
  final void Function(DateTime date, List<CalendarEvent> events)?
      onDateSelected;

  /// Called when event is tapped
  final void Function(CalendarEvent event)? onEventTap;

  /// Header color
  final Color headerColor;

  /// Selected color
  final Color selectedColor;

  /// Number of days to show ahead
  final int daysAhead;

  /// Number of days to show behind
  final int daysBehind;

  /// Creates an [AgendaView].
  const AgendaView({
    super.key,
    required this.controller,
    required this.events,
    this.onDateSelected,
    this.onEventTap,
    this.headerColor = Colors.black87,
    this.selectedColor = Colors.indigo,
    this.daysAhead = 30,
    this.daysBehind = 7,
  });

  List<CalendarEvent> _eventsForDate(DateTime date) =>
      events.where((e) => e.isOnDate(date)).toList()
        ..sort((a, b) {
          if (a.allDay && !b.allDay) return -1;
          if (!a.allDay && b.allDay) return 1;
          if (a.startTime != null && b.startTime != null) {
            final aMin = a.startTime!.hour * 60 + a.startTime!.minute;
            final bMin = b.startTime!.hour * 60 + b.startTime!.minute;
            return aMin.compareTo(bMin);
          }
          return 0;
        });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final now = controller.focusedDate;
        final startDate = now.subtract(Duration(days: daysBehind));

        // Build list of days
        final totalDays = daysBehind + daysAhead + 1;
        final days = List.generate(
          totalDays,
          (i) => startDate.add(Duration(days: i)),
        );

        // Filter days that have events
        final daysWithEvents =
            days.where((d) => _eventsForDate(d).isNotEmpty).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    controller.jumpToMonth(DateTime(controller.focusedDate.year,
                        controller.focusedDate.month - 1));
                  },
                  icon: const Icon(Icons.chevron_left),
                  visualDensity: VisualDensity.compact,
                ),
                GestureDetector(
                  onTap: controller.goToToday,
                  child: Text(
                    DateFormatHelper.format(
                        controller.focusedDate, 'MMMM yyyy'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: headerColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.jumpToMonth(DateTime(controller.focusedDate.year,
                        controller.focusedDate.month + 1));
                  },
                  icon: const Icon(Icons.chevron_right),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 8),

            if (daysWithEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.event_busy,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No events in this period',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...daysWithEvents.map((date) {
                final dayEvents = _eventsForDate(date);
                final isSelected = date.isSameDay(controller.selectedDate);
                final isToday = date.isToday;

                return _buildDaySection(
                  date: date,
                  events: dayEvents,
                  isSelected: isSelected,
                  isToday: isToday,
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildDaySection({
    required DateTime date,
    required List<CalendarEvent> events,
    required bool isSelected,
    required bool isToday,
  }) =>
      GestureDetector(
        onTap: () {
          controller.selectDate(date);
          onDateSelected?.call(date, events);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date column
              SizedBox(
                width: 56,
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor
                            : isToday
                                ? selectedColor.withValues(alpha: 0.12)
                                : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: isToday && !isSelected
                            ? Border.all(color: selectedColor, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormatHelper.format(date, 'EEE')
                                .substring(0, 3),
                            style: TextStyle(
                              fontSize: 9,
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? selectedColor
                                      : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Vertical line
                    if (events.length > 1)
                      Container(
                        width: 1,
                        height: (events.length - 1) * 60.0,
                        color: Colors.grey.shade200,
                        margin: const EdgeInsets.only(top: 4),
                      ),
                  ],
                ),
              ),

              // Events column
              Expanded(
                child: Column(
                  children:
                      events.map((event) => _buildEventCard(event)).toList(),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildEventCard(CalendarEvent event) => GestureDetector(
        onTap: () => onEventTap?.call(event),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(color: event.color, width: 4),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (event.isMultiDay)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: event.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${event.spanDays}d',
                            style: TextStyle(
                              fontSize: 10,
                              color: event.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ]),
                    if (event.description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        event.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (event.isMultiDay) ...[
                      const SizedBox(height: 3),
                      Text(
                        event.dateRangeString,
                        style: TextStyle(
                          fontSize: 11,
                          color: event.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                event.timeString,
                style: TextStyle(
                  fontSize: 11,
                  color: event.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
