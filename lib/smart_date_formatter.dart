/// Smart Date Formatter — converts DateTime to human-readable strings.
///
/// ## Quick Start
/// ```dart
/// import 'package:smart_date_formatter/smart_date_formatter.dart';
///
/// // Relative time
/// DateTime.now().subtract(Duration(hours: 2)).timeAgo;  // "2 hours ago"
///
/// // Custom format
/// DateTime.now().format('dd-MM-yyyy');                   // "15-06-2024"
///
/// // Localization
/// SmartDateFormatter(locale: SdfLocale.hi).format(date); // "2 घंटे पहले"
///
/// // Natural language parsing
/// SmartParser.parse("next monday");                       // DateTime
///
/// // Auto-refreshing widget
/// TimeAgoText(date: message.sentAt)
///
/// // Countdown widget
/// CountdownText(target: event.startsAt, format: '{d}d {h}h {m}m {s}s')
///
/// // Date ranges
/// DateRangeHelper.thisMonth()  // DateRange(start, end)
/// ```
library smart_date_formatter;

export 'src/formatter.dart';
export 'src/extensions.dart';
export 'src/date_format_helper.dart';
export 'src/date_calculations.dart';
export 'src/localization.dart';
export 'src/smart_parser.dart';
export 'src/date_range_helper.dart';
export 'src/widgets/time_ago_text.dart';
export 'src/widgets/countdown_text.dart';
export 'src/widgets/date_badge.dart';
export 'src/widgets/smart_date_text.dart';
export 'src/widgets/relative_date_builder.dart';
export 'src/holiday_helper.dart';
export 'src/recurrence_helper.dart';
export 'src/streak_calculator.dart';
export 'src/date_grouper.dart';
export 'src/calendar/calendar_event.dart';
export 'src/calendar/calendar_controller.dart';
export 'src/calendar/smart_calendar.dart';
export 'src/widgets/smart_date_field.dart';
export 'src/widgets/smart_date_range_picker.dart';
