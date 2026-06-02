import 'package:flutter/material.dart';
import '../calendar_event.dart';

/// Displays event markers (dots or chips) for a calendar date.
class EventMarker extends StatelessWidget {
  /// Events to display
  final List<CalendarEvent> events;

  /// Marker display style
  final EventMarkerStyle style;

  /// Max dots/chips to show
  final int maxMarkers;

  /// Creates an [EventMarker] widget.
  const EventMarker({
    super.key,
    required this.events,
    this.style = EventMarkerStyle.dot,
    this.maxMarkers = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    switch (style) {
      case EventMarkerStyle.dot:
        return _buildDots();
      case EventMarkerStyle.chip:
        return _buildChips();
      case EventMarkerStyle.both:
        return _buildDots();
    }
  }

  Widget _buildDots() {
    final visible = events.take(maxMarkers).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: visible
          .map((e) => Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: e.color,
                  shape: BoxShape.circle,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildChips() {
    final visible = events.take(maxMarkers).toList();
    return Column(
      children: visible
          .map((e) => Container(
                margin: const EdgeInsets.only(bottom: 1),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: e.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  e.title,
                  style: TextStyle(
                    fontSize: 8,
                    color: e.color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
    );
  }
}
