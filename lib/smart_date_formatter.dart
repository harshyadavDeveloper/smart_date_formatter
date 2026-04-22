/// Smart Date Formatter — converts DateTime to human-readable strings.
///
/// ## Quick Start
/// ```dart
/// import 'package:smart_date_formatter/smart_date_formatter.dart';
///
/// // Using extensions (easiest)
/// print(DateTime.now().subtract(Duration(hours: 2)).timeAgo); // "2 hours ago"
/// print(DateTime.now().calendar);  // "Today"
///
/// // Using the class directly (for custom labels)
/// final formatter = SmartDateFormatter();
/// print(formatter.format(someDate));
/// ```
library smart_date_formatter;

export 'src/formatter.dart';
export 'src/extensions.dart';
export 'src/date_format_helper.dart';
