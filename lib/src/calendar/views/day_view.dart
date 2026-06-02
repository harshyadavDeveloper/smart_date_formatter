import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

/// Day view for [SmartCalendar].
class DayView extends StatelessWidget {
  /// Controller
  final SmartCalendarController controller;

  /// All events
  final List<CalendarEvent> events;

  /// Called when event is tapped
  final void Function(CalendarEvent event)? onEventTap;

  /// Header color
  final Color headerColor;

  /// Selected color
  final Color selectedColor;

  /// Creates a [DayView].
  const DayView({
    super.key,
    required this.controller,
    required this.events,
    this.onEventTap,
    this.headerColor = Colors.black87,
    this.selectedColor = Colors.indigo,
  });

  List<CalendarEvent> _eventsForDate(DateTime date) =>
      events.where((e) => e.isOnDate(date)).toList();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final date = controller.selectedDate;
        final dayEvents = _eventsForDate(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousDay,
                  icon: const Icon(Icons.chevron_left),
                  visualDensity: VisualDensity.compact,
                ),
                GestureDetector(
                  onTap: controller.goToToday,
                  child: Column(
                    children: [
                      Text(
                        DateFormatHelper.format(date, 'EEEE'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                        ),
                      ),
                      Text(
                        DateFormatHelper.format(date, 'dd MMMM yyyy'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.nextDay,
                  icon: const Icon(Icons.chevron_right),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const Divider(),

            // Events
            if (dayEvents.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No events today',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: dayEvents.length,
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    return GestureDetector(
                      onTap: () => onEventTap?.call(event),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: event.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(color: event.color, width: 4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: event.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                event.timeString,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: event.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                            if (event.description != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                event.description!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
