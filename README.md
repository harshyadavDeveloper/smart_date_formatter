# smart_date_formatter

A Flutter package for converting `DateTime` into smart, human-readable strings.

## Features

- ⏱️ Relative time: `"2 hours ago"`, `"Yesterday"`, `"in 3 days"`
- 📅 Calendar strings: `"Today"`, `"Monday"`, `"12 Jan 2024"`
- 🕐 Short timestamps: `"2:30 PM"`, `"Mon 4:15 PM"`, `"12 Jan"`
- 🌍 Custom labels (for localization)
- 🔌 DateTime extensions for clean syntax
- ✅ Fully tested & null safe

## Installation

```yaml
dependencies:
  smart_date_formatter: ^0.0.1
```

## Usage

```dart
import 'package:smart_date_formatter/smart_date_formatter.dart';

// Extensions (cleanest syntax)
DateTime.now().subtract(Duration(hours: 2)).timeAgo;   // "2 hours ago"
DateTime.now().calendar;                                // "Today"
DateTime.now().shortTimestamp;                          // "2:30 PM"
DateTime.now().isToday;                                 // true
DateTime.now().isPast;                                  // false

// Direct class usage
final formatter = SmartDateFormatter();
formatter.format(someDate);
formatter.calendar(someDate);
formatter.shortTimestamp(someDate);
```

## Custom Labels (Localization)

```dart
final formatter = SmartDateFormatter(labels: {
  'justNow': 'अभी',
  'yesterday': 'कल',
  'tomorrow': 'आने वाला कल',
  // ... override any label
});
```