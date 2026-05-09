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
  <a href="https://github.com/harshyadavDeveloper/smart_date_formatter/actions">
    <img src="https://github.com/harshyadavDeveloper/smart_date_formatter/actions/workflows/ci.yml/badge.svg" alt="CI"/>
  </a>
</p>

<p align="center">
  <a href="https://smart-date-formatter.netlify.app/">
    <img src="https://img.shields.io/badge/🌐 Live Playground-Try it now!-brightgreen?style=for-the-badge" alt="Live Playground"/>
  </a>
</p>

<p align="center">
  <b>👉 <a href="https://smart-date-formatter.netlify.app/">Try the Interactive Playground</a> — no installation needed!</b>
</p>

<p align="center">
  The <b>complete</b> Flutter DateTime toolkit.<br/>
  Format • Parse • Calculate • Localize • Widget-Ready
</p>

---

## ✨ Features

| Feature                  | Description                                           |
| ------------------------ | ----------------------------------------------------- |
| ⏱️ **Relative time**     | `"Just now"`, `"2 hours ago"`, `"Last week"`          |
| 📅 **Calendar strings**  | `"Today"`, `"Yesterday"`, `"Monday"`, `"12 Jan 2024"` |
| 🕐 **Short timestamps**  | `"2:30 PM"`, `"Mon 4:15 PM"`, `"5 Mar"`               |
| 🎨 **Custom formats**    | `format('dd-MM-yyyy')`, `toReadable`, `to12Hour`      |
| 🧮 **Date calculations** | `addWorkingDays`, `daysUntil`, `isBetween`, `age`     |
| 📆 **Range helpers**     | `startOfWeek`, `endOfMonth`, `startOfYear`            |
| 🌍 **Localization**      | English, Hindi, Spanish, French, Japanese, Arabic     |
| 🔍 **Smart parsing**     | `"tomorrow"` → DateTime, `"next monday"` → DateTime   |
| ⏱️ **TimeAgoText**       | Auto-refreshing Flutter widget                        |
| ⏳ **CountdownText**     | Live countdown Flutter widget                         |
| 🗄️ **DateRangeHelper**   | Ready-made ranges for DB queries                      |
| ✅ **Boolean helpers**   | `isToday`, `isWeekend`, `isPast`, `isFuture`          |
| 🪶 **Zero dependencies** | Pure Flutter — no external packages                   |
| 💙 **Null safe**         | Full Dart null safety support                         |

---

## 📦 Installation

```yaml
dependencies:
  smart_date_formatter: ^1.0.0
```

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
import 'package:smart_date_formatter/smart_date_formatter.dart';

// ⏱️ Relative time
DateTime.now().subtract(Duration(hours: 2)).timeAgo;    // "2 hours ago"
DateTime.now().add(Duration(days: 1)).timeAgo;           // "Tomorrow"

// 📅 Calendar
DateTime.now().calendar;                                  // "Today"
DateTime.now().add(Duration(days: 2)).calendar;           // "Wednesday"

// 🎨 Custom format
DateTime.now().format('dd-MM-yyyy');                      // "15-06-2024"
DateTime.now().toReadable;                                // "Saturday, 15 June 2024"
DateTime.now().to12Hour;                                  // "02:30 PM"

// 🌍 Localization
SmartDateFormatter(locale: SdfLocale.hi).format(date);   // "2 घंटे पहले"
date.timeAgoIn(SdfLocale.es);                             // "2 horas atrás"

// 🔍 Smart parsing
SmartParser.parse("tomorrow");                            // DateTime
SmartParser.parse("next monday");                         // DateTime
SmartParser.parse("in 3 days");                           // DateTime

// ⏱️ Auto-refreshing widget
TimeAgoText(date: message.sentAt)

// ⏳ Countdown widget
CountdownText(
  target: event.startsAt,
  format: '{d}d {h}h {m}m {s}s',
)

// 🗄️ Date ranges
DateRangeHelper.thisMonth()     // DateRange(start, end)
DateRangeHelper.lastNDays(30)   // last 30 days
DateRangeHelper.thisWeek()      // this week Mon–Sun
```

---

## 📖 Full API Reference

### 1️⃣ Relative Time — `.timeAgo`

```dart
DateTime.now().subtract(Duration(seconds: 5)).timeAgo;   // "Just now"
DateTime.now().subtract(Duration(minutes: 25)).timeAgo;  // "25 minutes ago"
DateTime.now().subtract(Duration(hours: 3)).timeAgo;     // "3 hours ago"
DateTime.now().subtract(Duration(days: 1)).timeAgo;      // "Yesterday"
DateTime.now().subtract(Duration(days: 9)).timeAgo;      // "Last week"
DateTime.now().add(Duration(days: 1)).timeAgo;           // "Tomorrow"
DateTime.now().add(Duration(days: 4)).timeAgo;           // "in 4 days"
```

| Difference   | Output           |
| ------------ | ---------------- |
| < 10 seconds | `Just now`       |
| < 60 seconds | `45 seconds ago` |
| 1 minute     | `1 minute ago`   |
| < 60 minutes | `25 minutes ago` |
| 1 hour       | `1 hour ago`     |
| < 24 hours   | `5 hours ago`    |
| 1 day back   | `Yesterday`      |
| 1 day ahead  | `Tomorrow`       |
| < 7 days     | `3 days ago`     |
| ~1 week      | `Last week`      |
| < 30 days    | `2 weeks ago`    |
| ~1 month     | `Last month`     |
| < 12 months  | `3 months ago`   |
| ~1 year      | `Last year`      |
| 2+ years     | `2 years ago`    |

---

### 2️⃣ Calendar Format — `.calendar`

```dart
DateTime.now().calendar;                                  // "Today"
DateTime.now().subtract(Duration(days: 1)).calendar;     // "Yesterday"
DateTime.now().add(Duration(days: 1)).calendar;          // "Tomorrow"
DateTime.now().add(Duration(days: 3)).calendar;          // "Wednesday"
DateTime(2023, 3, 7).calendar;                           // "7 March 2023"
```

---

### 3️⃣ Short Timestamp — `.shortTimestamp`

```dart
DateTime.now().shortTimestamp;                            // "2:30 PM"
DateTime.now().subtract(Duration(days: 2)).shortTimestamp;// "Mon 2:30 PM"
DateTime(2024, 1, 5).shortTimestamp;                     // "5 Jan"
```

---

### 4️⃣ Custom Format — `.format(pattern)`

```dart
final date = DateTime(2024, 6, 15, 14, 30, 45);

date.format('dd-MM-yyyy');         // "15-06-2024"
date.format('MM/dd/yyyy');         // "06/15/2024"
date.format('MMM dd, yyyy');       // "Jun 15, 2024"
date.format('MMMM dd, yyyy');      // "June 15, 2024"
date.format('EEEE');               // "Saturday"
date.format('EEE, dd MMM yyyy');   // "Sat, 15 Jun 2024"
date.format('hh:mm a');            // "02:30 PM"
date.format('HH:mm:ss');           // "14:30:45"
date.toReadable;                   // "Saturday, 15 June 2024"
date.toISO;                        // "2024-06-15T14:30:45"
date.to12Hour;                     // "02:30 PM"
date.to24Hour;                     // "14:30"
date.toTimeString;                 // "14:30:45"
```

**Supported tokens:**

| Token  | Output           | Example    |
| ------ | ---------------- | ---------- |
| `dd`   | Day with zero    | `05`       |
| `d`    | Day without zero | `5`        |
| `MM`   | Month number     | `06`       |
| `MMM`  | Short month      | `Jun`      |
| `MMMM` | Full month       | `June`     |
| `yyyy` | 4-digit year     | `2024`     |
| `yy`   | 2-digit year     | `24`       |
| `HH`   | 24-hour          | `14`       |
| `hh`   | 12-hour          | `02`       |
| `mm`   | Minutes          | `30`       |
| `ss`   | Seconds          | `45`       |
| `a`    | AM/PM            | `PM`       |
| `EEE`  | Short weekday    | `Sat`      |
| `EEEE` | Full weekday     | `Saturday` |

---

### 5️⃣ Boolean Extensions

```dart
DateTime.now().isToday;       // true
DateTime.now().isYesterday;   // false
DateTime.now().isTomorrow;    // false
DateTime.now().isPast;        // false
DateTime.now().isFuture;      // false
DateTime(2024,6,22).isWeekend;// true  (Saturday)
DateTime(2024,6,17).isWeekday;// true  (Monday)
```

---

### 6️⃣ Date Calculations

```dart
// Working days
DateTime.now().addWorkingDays(5);           // skip weekends
DateTime.now().workingDaysUntil(deadline);  // count working days

// Days between
DateTime.now().daysUntil(futureDate);       // positive
DateTime.now().daysSince(pastDate);         // positive

// Range check
date.isBetween(startDate, endDate);         // true/false

// Age
DateTime(1999, 5, 20).age;                  // 25

// Week/Month/Year boundaries
DateTime.now().startOfWeek;    // Monday 00:00
DateTime.now().endOfWeek;      // Sunday 23:59
DateTime.now().startOfMonth;   // 1st 00:00
DateTime.now().endOfMonth;     // last day 23:59
DateTime.now().startOfYear;    // Jan 1 00:00
DateTime.now().endOfYear;      // Dec 31 23:59
DateTime.now().startOfDay;     // 00:00:00
DateTime.now().endOfDay;       // 23:59:59
```

---

### 7️⃣ Localization 🌍

```dart
// Using locale constants
SmartDateFormatter(locale: SdfLocale.hi).format(date); // Hindi
SmartDateFormatter(locale: SdfLocale.es).format(date); // Spanish
SmartDateFormatter(locale: SdfLocale.fr).format(date); // French
SmartDateFormatter(locale: SdfLocale.ja).format(date); // Japanese
SmartDateFormatter(locale: SdfLocale.ar).format(date); // Arabic

// Using extension
date.timeAgoIn(SdfLocale.hi);  // "2 घंटे पहले"
date.timeAgoIn(SdfLocale.es);  // "2 horas atrás"
date.timeAgoIn(SdfLocale.ja);  // "2 時間前"

// By code string
SmartDateFormatter(locale: SdfLocale.fromCode('hi'));

// Supported locales
SdfLocale.supported; // ['en', 'hi', 'es', 'fr', 'ja', 'ar']
```

| Code | Language | Example         |
| ---- | -------- | --------------- |
| `en` | English  | `2 hours ago`   |
| `hi` | Hindi    | `2 घंटे पहले`   |
| `es` | Spanish  | `2 horas atrás` |
| `fr` | French   | `2 heures`      |
| `ja` | Japanese | `2 時間前`      |
| `ar` | Arabic   | `ساعات مضت 2`   |

---

### 8️⃣ Smart Parser 🔍

```dart
SmartParser.parse("today");           // DateTime — today
SmartParser.parse("tomorrow");        // DateTime — tomorrow
SmartParser.parse("yesterday");       // DateTime — yesterday
SmartParser.parse("in 3 days");       // DateTime — 3 days from now
SmartParser.parse("in 2 weeks");      // DateTime — 2 weeks from now
SmartParser.parse("in 1 month");      // DateTime — 1 month from now
SmartParser.parse("3 days ago");      // DateTime — 3 days back
SmartParser.parse("next monday");     // DateTime — next Monday
SmartParser.parse("last friday");     // DateTime — last Friday
SmartParser.parse("next week");       // DateTime — next week
SmartParser.parse("next month");      // DateTime — next month
SmartParser.parse("last year");       // DateTime — last year
SmartParser.parse("2024-06-15");      // DateTime — from ISO string

// Safe variants
SmartParser.canParse("tomorrow");     // true
SmartParser.canParse("random");       // false
SmartParser.parseOrThrow("invalid");  // throws FormatException
```

---

### 9️⃣ TimeAgoText Widget ⏱️

Auto-refreshing widget — no `setState` or `Timer` needed!

```dart
// Basic
TimeAgoText(
  date: message.sentAt,
  style: TextStyle(color: Colors.grey, fontSize: 12),
)

// With locale
TimeAgoText(
  date: message.sentAt,
  locale: SdfLocale.hi,
  refreshRate: Duration(seconds: 30),
)

// With prefix/suffix
TimeAgoText(
  date: post.createdAt,
  prefix: 'Posted ',
  style: TextStyle(fontSize: 11),
)
```

| Property      | Type         | Default        | Description             |
| ------------- | ------------ | -------------- | ----------------------- |
| `date`        | `DateTime`   | required       | Date to display         |
| `style`       | `TextStyle?` | null           | Text style              |
| `locale`      | `SdfLocale`  | `SdfLocale.en` | Language                |
| `refreshRate` | `Duration`   | 60 seconds     | Auto-refresh interval   |
| `prefix`      | `String`     | `''`           | Text before time string |
| `suffix`      | `String`     | `''`           | Text after time string  |
| `textAlign`   | `TextAlign?` | null           | Text alignment          |

---

### 🔟 CountdownText Widget ⏳

```dart
// Basic
CountdownText(
  target: event.startsAt,
  format: '{d}d {h}h {m}m {s}s',
  style: TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  ),
)

// With callback
CountdownText(
  target: saleEndsAt,
  format: '{hh}:{mm}:{ss}',
  finishedText: 'Sale Ended!',
  onFinished: () => setState(() => saleActive = false),
)
```

**Format tokens:**

| Token  | Description       | Example |
| ------ | ----------------- | ------- |
| `{d}`  | Days              | `3`     |
| `{h}`  | Hours (0-23)      | `5`     |
| `{m}`  | Minutes (0-59)    | `30`    |
| `{s}`  | Seconds (0-59)    | `45`    |
| `{hh}` | Hours with zero   | `05`    |
| `{mm}` | Minutes with zero | `30`    |
| `{ss}` | Seconds with zero | `45`    |

---

### 1️⃣1️⃣ DateRangeHelper 🗄️

Perfect for database queries and analytics filters.

```dart
// Ready-made ranges
DateRangeHelper.today()           // today
DateRangeHelper.yesterday()       // yesterday
DateRangeHelper.tomorrow()        // tomorrow
DateRangeHelper.thisWeek()        // Mon–Sun this week
DateRangeHelper.lastWeek()        // Mon–Sun last week
DateRangeHelper.nextWeek()        // Mon–Sun next week
DateRangeHelper.thisMonth()       // this month
DateRangeHelper.lastMonth()       // last month
DateRangeHelper.nextMonth()       // next month
DateRangeHelper.thisYear()        // this year
DateRangeHelper.lastYear()        // last year
DateRangeHelper.lastNDays(30)     // last 30 days
DateRangeHelper.lastNDays(7)      // last 7 days
DateRangeHelper.nextNDays(14)     // next 14 days
DateRangeHelper.quarter(2)        // Q2 (Apr–Jun)
DateRangeHelper.currentQuarter()  // current quarter
DateRangeHelper.custom(s, e)      // custom range

// Use with database
final range = DateRangeHelper.thisMonth();

// SQLite
final orders = await db.query(
  'orders',
  where: 'created_at BETWEEN ? AND ?',
  whereArgs: [
    range.start.toIso8601String(),
    range.end.toIso8601String(),
  ],
);

// Check if date is in range
range.contains(DateTime.now());   // true
range.overlaps(otherRange);       // true/false
range.days;                       // number of days
range.duration;                   // Duration
```

---

## 💡 Real World Examples

### Chat App

```dart
// Message timestamp — auto updates!
TimeAgoText(
  date: message.sentAt,
  style: TextStyle(fontSize: 10, color: Colors.grey),
  refreshRate: Duration(seconds: 30),
)
```

### Flash Sale Countdown

```dart
CountdownText(
  target: saleEndsAt,
  format: '{hh}:{mm}:{ss}',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  ),
  finishedText: 'Sale Ended!',
  onFinished: () => hideSaleBanner(),
)
```

### Analytics Dashboard

```dart
// Filter by date range
final range = DateRangeHelper.lastNDays(30);
final stats = await analyticsService.getStats(
  from: range.start,
  to: range.end,
);
```

### Company Invoice

```dart
// Exact format for invoices/reports
Text('Date: ${invoiceDate.format('dd-MM-yyyy')}')
// "Date: 15-06-2024"
```

### Multilingual App

```dart
// Detect user locale and show accordingly
final locale = SdfLocale.fromCode(
  Localizations.localeOf(context).languageCode
);
Text(post.createdAt.timeAgoIn(locale))
```

### Deadline Checker

```dart
// Red if past, green if future
Text(
  task.dueDate.calendar,
  style: TextStyle(
    color: task.dueDate.isPast
        ? Colors.red
        : Colors.green,
  ),
)
```

---

## 🔄 Before vs After

```dart
// ❌ Before — 3 packages + 120 lines in every project
dependencies:
  timeago: ^3.6.0
  intl: ^0.18.0
  // + manual utility functions

String getTimeAgo(DateTime date) { /* 30 lines */ }
bool isToday(DateTime date) { /* 5 lines */ }
// ... copy-paste in every project 😩

// ✅ After — one package, clean API
dependencies:
  smart_date_formatter: ^1.0.0

date.timeAgo          // "2 hours ago"
date.isToday          // true
date.calendar         // "Yesterday"
date.format('dd-MM-yyyy') // "15-06-2024"
TimeAgoText(date: date)   // auto-refreshing widget!
```

---

## 📊 Complete API Reference

### DateTime Extensions

| Extension              | Return     | Description             |
| ---------------------- | ---------- | ----------------------- |
| `.timeAgo`             | `String`   | Relative time           |
| `.timeAgoIn(locale)`   | `String`   | Relative time in locale |
| `.calendar`            | `String`   | Calendar string         |
| `.shortTimestamp`      | `String`   | Short timestamp         |
| `.format(pattern)`     | `String`   | Custom pattern          |
| `.toReadable`          | `String`   | Full readable date      |
| `.toISO`               | `String`   | ISO 8601                |
| `.to12Hour`            | `String`   | 12-hour time            |
| `.to24Hour`            | `String`   | 24-hour time            |
| `.toTimeString`        | `String`   | HH:mm:ss                |
| `.isToday`             | `bool`     | Today?                  |
| `.isYesterday`         | `bool`     | Yesterday?              |
| `.isTomorrow`          | `bool`     | Tomorrow?               |
| `.isPast`              | `bool`     | In the past?            |
| `.isFuture`            | `bool`     | In the future?          |
| `.isWeekend`           | `bool`     | Weekend?                |
| `.isWeekday`           | `bool`     | Weekday?                |
| `.isBetween(s,e)`      | `bool`     | In range?               |
| `.age`                 | `int`      | Age in years            |
| `.daysUntil(d)`        | `int`      | Days until date         |
| `.daysSince(d)`        | `int`      | Days since date         |
| `.addWorkingDays(n)`   | `DateTime` | Add working days        |
| `.workingDaysUntil(d)` | `int`      | Working days count      |
| `.startOfDay`          | `DateTime` | 00:00:00                |
| `.endOfDay`            | `DateTime` | 23:59:59                |
| `.startOfWeek`         | `DateTime` | Monday 00:00            |
| `.endOfWeek`           | `DateTime` | Sunday 23:59            |
| `.startOfMonth`        | `DateTime` | 1st 00:00               |
| `.endOfMonth`          | `DateTime` | Last day 23:59          |
| `.startOfYear`         | `DateTime` | Jan 1 00:00             |
| `.endOfYear`           | `DateTime` | Dec 31 23:59            |

---

## 🧪 Testing

```bash
flutter test
```

100+ tests covering all features and edge cases.

---

## 🤝 Contributing

1. Fork — [github.com/harshyadavDeveloper/smart_date_formatter](https://github.com/harshyadavDeveloper/smart_date_formatter)
2. Create branch — `git checkout -b feat/your-feature`
3. Commit — `git commit -m 'feat: add your feature'`
4. Push — `git push origin feat/your-feature`
5. Open a Pull Request

---

## 🐛 Issues & Feedback

👉 [Open an issue](https://github.com/harshyadavDeveloper/smart_date_formatter/issues)

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👨‍💻 Author

Made with 💙 by [Harsh Yadav](https://github.com/harshyadavDeveloper)

If this package helped you — please ⭐ the repo and 👍 like it on pub.dev!

[![pub.dev](https://img.shields.io/badge/pub.dev-smart__date__formatter-blue)](https://pub.dev/packages/smart_date_formatter)
[![GitHub](https://img.shields.io/badge/GitHub-harshyadavDeveloper-black?logo=github)](https://github.com/harshyadavDeveloper/smart_date_formatter)
