# smart_date_formatter

<p align="center">
  <a href="https://pub.dev/packages/smart_date_formatter">
    <img src="https://img.shields.io/pub/v/smart_date_formatter.svg" alt="Pub Version"/>
  </a>
  <a href="https://pub.dev/packages/smart_date_formatter">
    <img src="https://img.shields.io/pub/likes/smart_date_formatter" alt="Pub Likes"/>
  </a>
  <a href="https://pub.dev/packages/smart_date_formatter">
    <img src="https://img.shields.io/pub/points/smart_date_formatter" alt="Pub Points"/>
  </a>
  <a href="https://pub.dev/packages/smart_date_formatter">
    <img src="https://img.shields.io/pub/popularity/smart_date_formatter" alt="Popularity"/>
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License"/>
  </a>
</p>

<p align="center">
A Flutter package that converts <code>DateTime</code> into smart, human-readable strings.<br/>
Stop writing repetitive date formatting code in every project!
</p>

---

## ✨ Features

- ⏱️ **Relative time** — `"Just now"`, `"2 hours ago"`, `"Last week"`, `"3 months ago"`
- 📅 **Calendar strings** — `"Today"`, `"Yesterday"`, `"Monday"`, `"12 Jan 2024"`
- 🕐 **Short timestamps** — `"2:30 PM"`, `"Mon 4:15 PM"`, `"5 Mar"`
- ✅ **Boolean helpers** — `isToday`, `isYesterday`, `isTomorrow`, `isPast`, `isFuture`
- 🛠️ **Utility extensions** — `startOfDay`, `endOfDay`
- 🌍 **Custom labels** — full localization support
- 💙 **Null safe** — fully supports Dart null safety
- 🪶 **Zero dependencies** — no external packages needed

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  smart_date_formatter: ^0.0.2
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
import 'package:smart_date_formatter/smart_date_formatter.dart';

// Relative time
DateTime.now().subtract(Duration(seconds: 5)).timeAgo;   // "Just now"
DateTime.now().subtract(Duration(minutes: 2)).timeAgo;   // "2 minutes ago"
DateTime.now().subtract(Duration(hours: 3)).timeAgo;     // "3 hours ago"
DateTime.now().subtract(Duration(days: 1)).timeAgo;      // "Yesterday"
DateTime.now().subtract(Duration(days: 9)).timeAgo;      // "Last week"
DateTime.now().add(Duration(days: 1)).timeAgo;           // "Tomorrow"
DateTime.now().add(Duration(days: 4)).timeAgo;           // "in 4 days"

// Calendar strings
DateTime.now().calendar;                                  // "Today"
DateTime.now().subtract(Duration(days: 1)).calendar;     // "Yesterday"
DateTime.now().add(Duration(days: 2)).calendar;          // "Wednesday"
DateTime(2023, 3, 7).calendar;                           // "7 March 2023"

// Short timestamps
DateTime.now().shortTimestamp;                            // "2:30 PM"
DateTime.now().subtract(Duration(days: 2)).shortTimestamp; // "Mon 2:30 PM"
DateTime(2024, 1, 5).shortTimestamp;                     // "5 Jan"
```

---

## 📖 Full Usage

### 1️⃣ Relative Time — `.timeAgo`

```dart
import 'package:smart_date_formatter/smart_date_formatter.dart';

final date = DateTime.now().subtract(Duration(hours: 2));
print(date.timeAgo); // "2 hours ago"
```

| Time Difference | Output |
|---|---|
| < 10 seconds | `Just now` |
| < 60 seconds | `45 seconds ago` |
| 1 minute | `1 minute ago` |
| < 60 minutes | `25 minutes ago` |
| 1 hour | `1 hour ago` |
| < 24 hours | `5 hours ago` |
| 1 day back | `Yesterday` |
| 1 day ahead | `Tomorrow` |
| < 7 days | `3 days ago` |
| ~1 week | `Last week` |
| < 30 days | `2 weeks ago` |
| ~1 month | `Last month` |
| < 12 months | `3 months ago` |
| ~1 year | `Last year` |
| 2+ years | `2 years ago` |

---

### 2️⃣ Calendar Format — `.calendar`

```dart
final date = DateTime.now().add(Duration(days: 3));
print(date.calendar); // "Wednesday"
```

| Date | Output |
|---|---|
| Today | `Today` |
| Yesterday | `Yesterday` |
| Tomorrow | `Tomorrow` |
| Within this week | `Wednesday` |
| Last week | `Last Tuesday` |
| Older | `7 March 2023` |

---

### 3️⃣ Short Timestamp — `.shortTimestamp`

```dart
final date = DateTime.now();
print(date.shortTimestamp); // "2:30 PM"
```

| Date | Output |
|---|---|
| Today | `2:30 PM` |
| Within this week | `Mon 9:15 AM` |
| Older | `5 Mar` |

---

### 4️⃣ Boolean Extensions

```dart
DateTime.now().isToday;              // true
DateTime.now().isYesterday;          // false
DateTime.now().isTomorrow;           // false
DateTime.now().isPast;               // false
DateTime(2099, 1, 1).isFuture;       // true
```

---

### 5️⃣ Utility Extensions

```dart
final now = DateTime.now();

now.startOfDay;   // 2024-06-15 00:00:00.000
now.endOfDay;     // 2024-06-15 23:59:59.999
```

Perfect for database range queries:
```dart
// Fetch all records from today
final results = await db.query(
  where: 'created_at BETWEEN ? AND ?',
  whereArgs: [
    DateTime.now().startOfDay.toIso8601String(),
    DateTime.now().endOfDay.toIso8601String(),
  ],
);
```

---

### 6️⃣ Using the Class Directly

```dart
final formatter = SmartDateFormatter();

formatter.format(someDate);           // relative time
formatter.calendar(someDate);         // calendar string
formatter.shortTimestamp(someDate);   // short timestamp
```

---

### 7️⃣ Custom Labels (Localization) 🌍

```dart
// Hindi example
final hindiFormatter = SmartDateFormatter(
  labels: {
    'justNow': 'अभी',
    'secondsAgo': 'सेकंड पहले',
    'minuteAgo': '1 मिनट पहले',
    'minutesAgo': 'मिनट पहले',
    'hourAgo': '1 घंटा पहले',
    'hoursAgo': 'घंटे पहले',
    'yesterday': 'कल',
    'tomorrow': 'आने वाला कल',
    'lastWeek': 'पिछले हफ्ते',
    'lastMonth': 'पिछले महीने',
    'lastYear': 'पिछले साल',
  },
);

print(hindiFormatter.format(
  DateTime.now().subtract(Duration(hours: 2))
)); // "2 घंटे पहले"
```

---

## 💡 Real World Examples

### Chat App — Message Timestamps
```dart
ListTile(
  title: Text(message.text),
  trailing: Text(message.sentAt.timeAgo), // "2 mins ago"
)
```

### Notification Screen
```dart
Text(notification.createdAt.calendar) // "Yesterday"
```

### Social Media Post
```dart
Text(post.publishedAt.shortTimestamp) // "Mon 4:15 PM"
```

### Conditional UI
```dart
// Show "NEW" badge only for today's content
if (article.publishedAt.isToday)
  Badge(label: Text('NEW'))

// Highlight overdue tasks in red
color: task.dueDate.isPast ? Colors.red : Colors.green,
```

### Database Query
```dart
// Get today's orders
final todayOrders = orders.where(
  (o) => o.createdAt.isToday
).toList();
```

---

## 🔄 Before vs After

**Before `smart_date_formatter`:**
```dart
// ❌ 30+ lines of manual code in every project
String getTimeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inSeconds < 60) return '${diff.inSeconds} seconds ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  // ... 30 more lines, still incomplete!
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
         date.month == now.month &&
         date.day == now.day;
}
```

**After `smart_date_formatter`:**
```dart
// ✅ Clean, complete, one line
date.timeAgo       // "2 hours ago"
date.isToday       // true
date.calendar      // "Yesterday"
```

---

## 📊 API Reference

### Extensions on `DateTime`

| Extension | Return Type | Description |
|---|---|---|
| `.timeAgo` | `String` | Relative time string |
| `.calendar` | `String` | Calendar format string |
| `.shortTimestamp` | `String` | Short time/date string |
| `.isToday` | `bool` | Is date today? |
| `.isYesterday` | `bool` | Is date yesterday? |
| `.isTomorrow` | `bool` | Is date tomorrow? |
| `.isPast` | `bool` | Is date in the past? |
| `.isFuture` | `bool` | Is date in the future? |
| `.startOfDay` | `DateTime` | Start of day `00:00:00` |
| `.endOfDay` | `DateTime` | End of day `23:59:59` |

### `SmartDateFormatter` Class

| Method | Description |
|---|---|
| `format(date, {now})` | Returns relative time string |
| `calendar(date, {now})` | Returns calendar string |
| `shortTimestamp(date, {now})` | Returns short timestamp |

---

## 🧪 Testing

```bash
flutter test
```

All core functions are fully tested with edge cases covered.

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repo — [github.com/harshyadavDeveloper/smart_date_formatter](https://github.com/harshyadavDeveloper/smart_date_formatter)
2. Create your feature branch — `git checkout -b feat/amazing-feature`
3. Commit your changes — `git commit -m 'feat: add amazing feature'`
4. Push to branch — `git push origin feat/amazing-feature`
5. Open a Pull Request

---

## 🐛 Issues & Feedback

Found a bug or have a feature request?
👉 [Open an issue](https://github.com/harshyadavDeveloper/smart_date_formatter/issues)

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👨‍💻 Author

Made with 💙 by [Harsh Yadav](https://github.com/harshyadavDeveloper)

If this package helped you, please ⭐ the repo and 👍 like it on pub.dev!

[![pub.dev](https://img.shields.io/badge/pub.dev-smart__date__formatter-blue)](https://pub.dev/packages/smart_date_formatter)
[![GitHub](https://img.shields.io/badge/GitHub-harshyadavDeveloper-black?logo=github)](https://github.com/harshyadavDeveloper/smart_date_formatter)