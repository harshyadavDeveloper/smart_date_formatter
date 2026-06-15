import 'package:flutter/material.dart';
import 'package:smart_date_formatter/src/calendar/views/agenda_view.dart';
import 'calendar_event.dart';
import 'calendar_controller.dart';
import 'views/month_view.dart';
import 'views/week_view.dart';
import 'views/day_view.dart';

/// View modes for [SmartCalendar].
enum CalendarView {
  /// Full month grid view
  month,

  /// Week strip with events
  week,

  /// Single day detail view
  day,

  /// Agenda list view
  agenda,
}

/// A full-featured calendar widget with month, week, and day views.
///
/// ```dart
/// SmartCalendar(
///   events: [
///     CalendarEvent(
///       date: DateTime(2024, 6, 15),
///       title: 'Team Meeting',
///       color: Colors.blue,
///     ),
///   ],
///   onDateSelected: (date, events) {
///     print('Selected: $date with ${events.length} events');
///   },
/// )
/// ```
class SmartCalendar extends StatefulWidget {
  /// List of events to display
  final List<CalendarEvent> events;

  /// Called when a date is selected
  final void Function(DateTime date, List<CalendarEvent> events)?
      onDateSelected;

  /// Called when an event is tapped
  final void Function(CalendarEvent event)? onEventTap;

  /// External controller — if null, creates internal one
  final SmartCalendarController? controller;

  /// Initial view mode
  final CalendarView initialView;

  /// Whether to show view switcher tabs
  final bool showViewSwitcher;

  /// Marker style for events
  final EventMarkerStyle markerStyle;

  /// Color for selected date
  final Color selectedColor;

  /// Color for today
  final Color todayColor;

  /// Header text color
  final Color headerColor;

  /// Background color
  final Color? backgroundColor;

  /// Border radius of the calendar container
  final double borderRadius;

  /// Elevation of the calendar card
  final double elevation;

  /// Whether to show today button
  final bool showTodayButton;

  /// First day of week (1=Monday, 7=Sunday)
  final int firstDayOfWeek;

  /// Days to show ahead in agenda view
  final int agendaDaysAhead;

  /// Days to show behind in agenda view
  final int agendaDaysBehind;

  /// Creates a [SmartCalendar] widget.
  ///
  /// ```dart
  /// SmartCalendar(
  ///   events: myEvents,
  ///   initialView: CalendarView.month,
  ///   markerStyle: EventMarkerStyle.both,
  ///   selectedColor: Colors.indigo,
  ///   onDateSelected: (date, events) => print(date),
  /// )
  /// ```
  const SmartCalendar({
    super.key,
    this.events = const [],
    this.onDateSelected,
    this.onEventTap,
    this.controller,
    this.initialView = CalendarView.month,
    this.showViewSwitcher = true,
    this.markerStyle = EventMarkerStyle.dot,
    this.selectedColor = Colors.indigo,
    this.todayColor = Colors.blue,
    this.headerColor = Colors.black87,
    this.backgroundColor,
    this.borderRadius = 16,
    this.elevation = 2,
    this.showTodayButton = true,
    this.firstDayOfWeek = 1,
    this.agendaDaysAhead = 30,
    this.agendaDaysBehind = 7,
  });

  @override
  State<SmartCalendar> createState() => _SmartCalendarState();
}

class _SmartCalendarState extends State<SmartCalendar> {
  late SmartCalendarController _controller;
  late CalendarView _currentView;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = SmartCalendarController();
      _ownsController = true;
    }
    _currentView = widget.initialView;
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      color: widget.backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // View switcher + Today button
              if (widget.showViewSwitcher || widget.showTodayButton)
                Row(
                  children: [
                    if (widget.showViewSwitcher)
                      Expanded(child: _buildViewSwitcher()),
                    if (widget.showTodayButton)
                      TextButton(
                        onPressed: () {
                          _controller.goToToday();
                          setState(() {});
                        },
                        child: const Text('Today'),
                      ),
                  ],
                ),

              // Calendar view
              _buildCurrentView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewSwitcher() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CalendarView.values.map((view) {
          final isActive = _currentView == view;
          return GestureDetector(
            onTap: () => setState(() => _currentView = view),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? widget.selectedColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                view.name[0].toUpperCase() + view.name.substring(1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentView() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe left → next
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -300) {
          _navigateForward();
        }
        // Swipe right → previous
        else if (details.primaryVelocity != null &&
            details.primaryVelocity! > 300) {
          _navigateBackward();
        }
      },
      child: _buildView(),
    );
  }

  void _navigateForward() {
    switch (_currentView) {
      case CalendarView.month:
        _controller.nextMonth();
      case CalendarView.week:
        _controller.nextWeek();
      case CalendarView.day:
        _controller.nextDay();
      case CalendarView.agenda:
        _controller.nextMonth();
    }
  }

  void _navigateBackward() {
    switch (_currentView) {
      case CalendarView.month:
        _controller.previousMonth();
      case CalendarView.week:
        _controller.previousWeek();
      case CalendarView.day:
        _controller.previousDay();
      case CalendarView.agenda:
        _controller.previousMonth();
    }
  }

  Widget _buildView() {
    switch (_currentView) {
      case CalendarView.month:
        return MonthView(
          controller: _controller,
          events: widget.events,
          onDateSelected: widget.onDateSelected,
          onEventTap: widget.onEventTap,
          markerStyle: widget.markerStyle,
          selectedColor: widget.selectedColor,
          todayColor: widget.todayColor,
          headerColor: widget.headerColor,
          firstDayOfWeek: widget.firstDayOfWeek,
        );
      case CalendarView.week:
        return WeekView(
          controller: _controller,
          events: widget.events,
          onDateSelected: widget.onDateSelected,
          markerStyle: widget.markerStyle,
          selectedColor: widget.selectedColor,
          todayColor: widget.todayColor,
          headerColor: widget.headerColor,
        );
      case CalendarView.day:
        return SizedBox(
          height: 400,
          child: DayView(
            controller: _controller,
            events: widget.events,
            onEventTap: widget.onEventTap,
            headerColor: widget.headerColor,
            selectedColor: widget.selectedColor,
          ),
        );
      case CalendarView.agenda:
        return AgendaView(
          controller: _controller,
          events: widget.events,
          onDateSelected: widget.onDateSelected,
          onEventTap: widget.onEventTap,
          headerColor: widget.headerColor,
          selectedColor: widget.selectedColor,
          daysAhead: widget.agendaDaysAhead,
          daysBehind: widget.agendaDaysBehind,
        );
    }
  }
}
