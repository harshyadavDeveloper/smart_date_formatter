import 'package:flutter/material.dart';
import '../../date_format_helper.dart';

/// Header widget showing month/year with navigation arrows.
class CalendarHeader extends StatelessWidget {
  /// Currently focused date
  final DateTime focusedDate;

  /// Called when previous button tapped
  final VoidCallback onPrevious;

  /// Called when next button tapped
  final VoidCallback onNext;

  /// Called when title tapped (jump to today)
  final VoidCallback? onTitleTap;

  /// Header text color
  final Color color;

  /// Creates a [CalendarHeader].
  const CalendarHeader({
    super.key,
    required this.focusedDate,
    required this.onPrevious,
    required this.onNext,
    this.onTitleTap,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: Icon(Icons.chevron_left, color: color),
          visualDensity: VisualDensity.compact,
        ),
        GestureDetector(
          onTap: onTitleTap,
          child: Text(
            DateFormatHelper.format(focusedDate, 'MMMM yyyy'),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.chevron_right, color: color),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
