import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/event_marker.dart';

/// Week view for [SmartCalendar].
class WeekView extends StatelessWidget {
  /// Controller
  final SmartCalendarController controller;

  /// All events
  final List<CalendarEvent> events;

  /// Called when a date is selected
  final void Function(DateTime date, List<CalendarEvent> events)?
      onDateSelected;

  /// Marker style
  final EventMarkerStyle markerStyle;

  /// Selected color
  final Color selectedColor;

  /// Today color
  final Color todayColor;

  /// Header color
  final Color headerColor;

  /// Creates a [WeekView].
  const WeekView({
    super.key,
    required this.controller,
    required this.events,
    this.onDateSelected,
    this.markerStyle = EventMarkerStyle.dot,
    this.selectedColor = Colors.indigo,
    this.todayColor = Colors.blue,
    this.headerColor = Colors.black87,
  });

  List<DateTime> _daysInWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  List<CalendarEvent> _eventsForDate(DateTime date) =>
      events.where((e) => e.isOnDate(date)).toList();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final days = _daysInWeek(controller.focusedDate);
        final weekStart = days.first;
        final weekEnd = days.last;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousWeek,
                  icon: const Icon(Icons.chevron_left),
                  visualDensity: VisualDensity.compact,
                ),
                GestureDetector(
                  onTap: controller.goToToday,
                  child: Text(
                    '${DateFormatHelper.format(weekStart, 'dd MMM')} '
                    '– ${DateFormatHelper.format(weekEnd, 'dd MMM yyyy')}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: headerColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: controller.nextWeek,
                  icon: const Icon(Icons.chevron_right),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Days row
            Row(
              children: days.map((date) {
                final dayEvents = _eventsForDate(date);
                final isSelected = date.isSameDay(controller.selectedDate);
                final isToday = date.isToday;
                final isWeekend = date.isWeekend;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.selectDate(date);
                      onDateSelected?.call(date, dayEvents);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor
                            : isToday
                                ? todayColor.withValues(alpha: 0.12)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isToday && !isSelected
                            ? Border.all(color: todayColor, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormatHelper.format(date, 'EEE')
                                .substring(0, 2),
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : isWeekend
                                      ? Colors.red.shade400
                                      : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (dayEvents.isNotEmpty)
                            EventMarker(
                              events: dayEvents,
                              style: EventMarkerStyle.dot,
                              maxMarkers: 3,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Events list for selected day
            _buildEventsList(),
          ],
        );
      },
    );
  }

  Widget _buildEventsList() {
    final dayEvents = _eventsForDate(controller.selectedDate);

    if (dayEvents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No events on ${DateFormatHelper.format(controller.selectedDate, 'EEE, dd MMM')}',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormatHelper.format(controller.selectedDate, 'EEE, dd MMMM'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...dayEvents.map((e) => _eventTile(e)),
      ],
    );
  }

  Widget _eventTile(CalendarEvent event) => Container(
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
                  Text(event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (event.description != null)
                    Text(event.description!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Text(event.timeString,
                style: TextStyle(fontSize: 11, color: event.color)),
          ],
        ),
      );
}
