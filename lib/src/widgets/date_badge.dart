import 'package:flutter/material.dart';
import '../extensions.dart';
import '../localization.dart';

/// Style options for [DateBadge].
enum DateBadgeStyle {
  /// Filled chip with background color
  chip,

  /// Outlined chip with border
  outlined,

  /// Plain text with color only
  flat,
}

/// A badge widget that displays a [DateTime] as a smart label.
///
/// Shows contextual labels like "TODAY", "TOMORROW", "YESTERDAY",
/// weekday names, or formatted dates.
///
/// ```dart
/// DateBadge(date: DateTime.now())
/// // Shows: "TODAY" in green
///
/// DateBadge(
///   date: DateTime.now().add(Duration(days: 1)),
///   style: DateBadgeStyle.outlined,
/// )
/// // Shows: "TOMORROW" outlined in blue
/// ```
class DateBadge extends StatelessWidget {
  /// The date to display as a badge
  final DateTime date;

  /// Visual style of the badge
  final DateBadgeStyle style;

  /// Locale for label text
  final SdfLocale locale;

  /// Override automatic label with custom text
  final String? label;

  /// Font size — defaults to 11
  final double fontSize;

  /// Whether to show uppercase text
  final bool uppercase;

  /// Creates a [DateBadge] for the given [date].
  const DateBadge({
    super.key,
    required this.date,
    this.style = DateBadgeStyle.chip,
    this.locale = SdfLocale.en,
    this.label,
    this.fontSize = 11,
    this.uppercase = true,
  });

  // ✅ Naya — direct simple strings
  String _buildLabel() {
    if (label != null) return uppercase ? label!.toUpperCase() : label!;

    String text;

    if (date.isToday) {
      text = 'Today';
    } else if (date.isYesterday) {
      text = 'Yesterday';
    } else if (date.isTomorrow) {
      text = 'Tomorrow';
    } else if (date.isFuture && date.difference(DateTime.now()).inDays < 7) {
      text = _weekdayShort(date.weekday);
    } else if (date.isPast && DateTime.now().difference(date).inDays < 7) {
      text = _weekdayShort(date.weekday);
    } else {
      text = '${date.day} ${_monthShort(date.month)}';
    }

    return uppercase ? text.toUpperCase() : text;
  }

  Color _buildColor() {
    if (date.isToday) return Colors.green;
    if (date.isTomorrow) return Colors.blue;
    if (date.isYesterday) return Colors.orange;
    if (date.isPast) return Colors.grey;
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    final text = _buildLabel();
    final color = _buildColor();

    switch (style) {
      case DateBadgeStyle.chip:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: uppercase ? 0.5 : 0,
            ),
          ),
        );

      case DateBadgeStyle.outlined:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: uppercase ? 0.5 : 0,
            ),
          ),
        );

      case DateBadgeStyle.flat:
        return Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: uppercase ? 0.5 : 0,
          ),
        );
    }
  }

  String _weekdayShort(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }

  String _monthShort(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }
}
