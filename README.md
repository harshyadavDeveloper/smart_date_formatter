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
  <a href="YOUR_NETLIFY_LINK_HERE">
    <img src="https://img.shields.io/badge/🌐 Live Playground-Try it now!-brightgreen?style=for-the-badge" alt="Live Playground"/>
  </a>
</p>

<p align="center">
  <b>The complete Flutter DateTime toolkit.</b><br/>
  Format • Parse • Calculate • Localize • Widget-Ready • Analytics
</p>

<p align="center">
  👉 <a href="YOUR_NETLIFY_LINK_HERE"><b>Try the Interactive Playground</b></a> — no installation needed!
</p>

---

## ✨ Features

| Feature | Description |
|---|---|
| ⏱️ **Relative time** | `"Just now"`, `"2 hours ago"`, `"Last week"` |
| 📅 **Calendar strings** | `"Today"`, `"Yesterday"`, `"Monday"`, `"12 Jan 2024"` |
| 🕐 **Short timestamps** | `"2:30 PM"`, `"Mon 4:15 PM"`, `"5 Mar"` |
| 🎨 **Custom formats** | `format('dd-MM-yyyy')`, `toReadable`, `to12Hour` |
| 🧮 **Date calculations** | `addWorkingDays`, `daysUntil`, `isBetween`, `age` |
| 📆 **Range helpers** | `startOfWeek`, `endOfMonth`, `quarter`, `weekOfYear` |
| 🌍 **16 Languages** | English, Hindi, Marathi, Gujarati, Bengali, Tamil, Telugu, Kannada, Punjabi, Spanish, French, German, Russian, Chinese, Japanese, Arabic |
| 🔍 **Smart parsing** | `"tomorrow"` → DateTime, `"next monday"` → DateTime |
| ⏱️ **TimeAgoText** | Auto-refreshing Flutter widget |
| ⏳ **CountdownText** | Live countdown Flutter widget |
| 🏷️ **DateBadge** | Smart date chip widget |
| 📝 **SmartDateText** | All-in-one date text widget |
| 🔧 **RelativeDateBuilder** | Builder pattern for custom UI |
| 🗄️ **DateRangeHelper** | Ready-made ranges for DB queries |
| 🎄 **HolidayHelper** | Holiday detection + working days |
| 🔁 **RecurrenceHelper** | Generate recurring date lists |
| 📊 **StreakCalculator** | Habit/attendance streak analysis |
| 📈 **DateGrouper** | Group dates by day/week/month/year |
| ✅ **Boolean helpers** | `isToday`, `isWeekend`, `isMorning`, `isPast` |
| 🪶 **Zero dependencies** | Pure Flutter — no external packages |
| 💙 **Null safe** | Full Dart null safety |

---

## 📦 Installation

```yaml
dependencies:
  smart_date_formatter: ^1.5.0
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

// 🎨 Custom format
DateTime.now().format('dd-MM-yyyy');                      // "15-06-2024"
DateTime.now().toReadable;                                // "Saturday, 15 June 2024"

// 🌍 Localization
date.timeAgoIn(SdfLocale.hi);                             // "2 घंटे पहले"
date.timeAgoIn(SdfLocale.mr);                             // "2 तास पूर्वी"

// 🔍 Smart parsing
SmartParser.parse("next monday");                         // DateTime
SmartParser.parse("in 3 days");                           // DateTime

// ⏱️ Auto-refreshing widget
TimeAgoText(date: message.sentAt)

// ⏳ Countdown widget
CountdownText(target: event.startsAt, format: '{d}d {h}h {m}m {s}s')

// 🏷️ Date badge
DateBadge(date: DateTime.now())                           // "TODAY" chip

// 🗄️ Date ranges
DateRangeHelper.thisMonth()                               // DateRange(start, end)
DateRangeHelper.lastNDays(30)

// 🎄 Holiday support
date.isHoliday(holidays: HolidayHelper.indianHolidays(2024))
date.addWorkingDaysWithHolidays(5, holidays: holidays)

// 🔁 Recurrence
RecurrenceHelper.weekly(start: date, count: 8)

// 📊 Streak & Analytics
StreakCalculator.currentStreak(habitDates)               // 7
StreakCalculator.longestStreak(habitDates)               // 21
DateGrouper.byMonth(activityDates)                       // {'2024-06': [...]}
DateGrouper.mostActiveWeekday(activityDates)             // 'Monday'
```

---

## 📖 Complete API Reference

### 1️⃣ Relative Time

```dart
date.timeAgo                    // "2 hours ago"
date.timeAgoIn(SdfLocale.hi)   // "2 घंटे पहले"
date.calendar                   // "Today", "Yesterday", "Monday"
date.shortTimestamp             // "2:30 PM", "Mon 4:15 PM"
```

---

### 2️⃣ Custom Format

```dart
date.format('dd-MM-yyyy')          // "15-06-2024"
date.format('MMM dd, yyyy')        // "Jun 15, 2024"
date.format('EEEE, dd MMMM yyyy')  // "Saturday, 15 June 2024"
date.format('hh:mm a')             // "02:30 PM"
date.format('HH:mm:ss')            // "14:30:45"
date.toReadable                    // "Saturday, 15 June 2024"
date.toISO                         // "2024-06-15T14:30:45"
date.to12Hour                      // "02:30 PM"
date.to24Hour                      // "14:30"
date.toTimeString                  // "14:30:45"
```

**Format tokens:**

| Token | Output | Token | Output |
|---|---|---|---|
| `dd` | `15` | `EEEE` | `Saturday` |
| `d` | `5` | `EEE` | `Sat` |
| `MM` | `06` | `yyyy` | `2024` |
| `MMM` | `Jun` | `yy` | `24` |
| `MMMM` | `June` | `HH` | `14` |
| `hh` | `02` | `mm` | `30` |
| `ss` | `45` | `a` | `PM` |

---

### 3️⃣ Boolean Extensions

```dart
date.isToday       date.isYesterday    date.isTomorrow
date.isPast        date.isFuture
date.isWeekend     date.isWeekday
date.isMorning     date.isAfternoon
date.isEvening     date.isNight
date.isSameDay(other)    date.isSameWeek(other)
date.isSameMonth(other)  date.isSameYear(other)
date.isBetween(start, end)
```

---

### 4️⃣ Date Calculations

```dart
// Working days
date.addWorkingDays(5)
date.workingDaysUntil(other)

// Days between
date.daysUntil(other)
date.daysSince(other)

// Age
DateTime(1999, 5, 20).age           // 25

// Quarter & Year
date.quarter                         // 2
date.isQ1 / isQ2 / isQ3 / isQ4
date.weekOfYear                      // 24
date.dayOfYear                       // 167
date.isLeapYear                      // true

// Next/Previous weekday
date.nextMonday     date.nextFriday
date.previousMonday date.previousFriday
// ... all 7 weekdays supported

// Boundaries
date.startOfDay    date.endOfDay
date.startOfWeek   date.endOfWeek
date.startOfMonth  date.endOfMonth
date.startOfYear   date.endOfYear

// Copy with
date.copyWith(hour: 0, minute: 0)
```

---

### 5️⃣ Localization 🌍

```dart
// 16 supported languages
SmartDateFormatter(locale: SdfLocale.hi).format(date)
date.timeAgoIn(SdfLocale.mr)    // "2 तास पूर्वी"
date.timeAgoIn(SdfLocale.bn)    // "2 ঘন্টা আগে"
SdfLocale.fromCode('ta')        // Tamil
```

| Code | Language | Code | Language |
|---|---|---|---|
| `en` | English 🇬🇧 | `de` | German 🇩🇪 |
| `hi` | Hindi 🇮🇳 | `ru` | Russian 🇷🇺 |
| `mr` | Marathi 🇮🇳 | `zh` | Chinese 🇨🇳 |
| `gu` | Gujarati 🇮🇳 | `ja` | Japanese 🇯🇵 |
| `bn` | Bengali 🇮🇳 | `ar` | Arabic 🇸🇦 |
| `ta` | Tamil 🇮🇳 | `es` | Spanish 🇪🇸 |
| `te` | Telugu 🇮🇳 | `fr` | French 🇫🇷 |
| `kn` | Kannada 🇮🇳 | `pa` | Punjabi 🇮🇳 |

---

### 6️⃣ Smart Parser 🔍

```dart
SmartParser.parse("today")         // DateTime
SmartParser.parse("tomorrow")      // DateTime
SmartParser.parse("in 3 days")     // DateTime
SmartParser.parse("next monday")   // DateTime
SmartParser.parse("2 weeks ago")   // DateTime
SmartParser.parse("last year")     // DateTime
SmartParser.parse("2024-06-15")    // DateTime
SmartParser.canParse("tomorrow")   // true
SmartParser.parseOrThrow("blah")   // FormatException
```

---

### 7️⃣ Widgets

#### TimeAgoText ⏱️
```dart
TimeAgoText(
  date: message.sentAt,
  locale: SdfLocale.hi,
  refreshRate: Duration(seconds: 30),
  prefix: 'Posted ',
  style: TextStyle(color: Colors.grey),
)
```

#### CountdownText ⏳
```dart
CountdownText(
  target: saleEndsAt,
  format: '{hh}:{mm}:{ss}',
  finishedText: 'Sale Ended!',
  onFinished: () => hideSaleBanner(),
  style: TextStyle(color: Colors.red, fontSize: 24),
)
```

#### DateBadge 🏷️
```dart
DateBadge(date: DateTime.now())
DateBadge(date: date, style: DateBadgeStyle.outlined)
DateBadge(date: date, style: DateBadgeStyle.flat)
DateBadge(date: date, label: 'NEW', uppercase: true)
```

#### SmartDateText 📝
```dart
SmartDateText(date: date, mode: SmartDateMode.auto)
SmartDateText(date: date, mode: SmartDateMode.timeAgo)
SmartDateText(date: date, mode: SmartDateMode.calendar)
SmartDateText(
  date: date,
  mode: SmartDateMode.custom,
  pattern: 'dd-MM-yyyy',
  autoRefresh: true,
)
```

#### RelativeDateBuilder 🔧
```dart
RelativeDateBuilder(
  date: post.createdAt,
  autoRefresh: true,
  builder: (ctx, timeAgo, calendar, timestamp, date) {
    return Row(children: [
      Icon(Icons.access_time, size: 12),
      Text(timeAgo),
      if (date.isToday) Badge(label: Text('NEW')),
    ]);
  },
)
```

---

### 8️⃣ DateRangeHelper 🗄️

```dart
DateRangeHelper.today()           DateRangeHelper.yesterday()
DateRangeHelper.thisWeek()        DateRangeHelper.lastWeek()
DateRangeHelper.thisMonth()       DateRangeHelper.lastMonth()
DateRangeHelper.thisYear()        DateRangeHelper.lastYear()
DateRangeHelper.lastNDays(30)     DateRangeHelper.nextNDays(14)
DateRangeHelper.quarter(2)        DateRangeHelper.currentQuarter()
DateRangeHelper.custom(start, end)

// Use with DB
final range = DateRangeHelper.thisMonth();
await db.query(
  where: 'created_at BETWEEN ? AND ?',
  whereArgs: [range.start.toIso8601String(), range.end.toIso8601String()],
);
range.contains(DateTime.now());  // true
range.days;                       // 30
range.overlaps(otherRange);       // true/false
```

---

### 9️⃣ HolidayHelper 🎄

```dart
// Check
date.isHoliday(holidays: holidays)
date.isWorkingDay(holidays: holidays)

// Add working days skipping holidays
date.addWorkingDaysWithHolidays(5, holidays: holidays)
date.workingDaysUntilWithHolidays(deadline, holidays: holidays)

// Static methods
HolidayHelper.isHoliday(date, holidays: list)
HolidayHelper.nextWorkingDay(date, holidays: list)
HolidayHelper.workingDaysBetween(start, end, holidays: list)

// Preset lists
HolidayHelper.indianHolidays(2024)   // 8 Indian holidays
HolidayHelper.globalHolidays(2024)   // New Year, Christmas, Boxing Day
```

---

### 🔟 RecurrenceHelper 🔁

```dart
RecurrenceHelper.daily(start: date, count: 30)
RecurrenceHelper.weekly(start: date, count: 8)
RecurrenceHelper.monthly(start: date, count: 12)
RecurrenceHelper.yearly(start: date, count: 5)

// With options
RecurrenceHelper.daily(
  start: date,
  count: 10,
  skipWeekends: true,
  skipHolidays: HolidayHelper.indianHolidays(2024),
)

// Until date
RecurrenceHelper.monthly(
  start: date,
  until: DateTime(2024, 12, 31),
)

// Next occurrence
RecurrenceHelper.nextOccurrence(date, RecurrenceFrequency.weekly)
```

---

### 1️⃣1️⃣ StreakCalculator 📊

```dart
StreakCalculator.currentStreak(dates)    // 7
StreakCalculator.longestStreak(dates)    // 21
StreakCalculator.isTodayCompleted(dates) // true
StreakCalculator.totalCompleted(dates)   // 45
StreakCalculator.allStreaks(dates)        // [[...], [...]]
StreakCalculator.lastCompletedDate(dates) // DateTime
StreakCalculator.missedDays(dates, start: startDate)
StreakCalculator.completionRate(
  dates,
  start: DateTime(2024, 6, 1),
  end: DateTime(2024, 6, 30),
) // 0.8
```

---

### 1️⃣2️⃣ DateGrouper 📈

```dart
DateGrouper.byDay(dates)      // {'2024-06-15': [...]}
DateGrouper.byWeek(dates)     // {'2024-W24': [...]}
DateGrouper.byMonth(dates)    // {'2024-06': [...]}
DateGrouper.byQuarter(dates)  // {'2024-Q2': [...]}
DateGrouper.byYear(dates)     // {'2024': [...]}
DateGrouper.byHour(dates)     // {'14': [...]}
DateGrouper.byWeekday(dates)  // {'Monday': [...]}

// Counts
DateGrouper.countByDay(dates)
DateGrouper.countByMonth(dates)
DateGrouper.countByWeekday(dates)

// Insights
DateGrouper.mostActiveDay(dates)      // '2024-06-15'
DateGrouper.mostActiveWeekday(dates)  // 'Monday'
DateGrouper.mostActiveHour(dates)     // 14
DateGrouper.averageGap(dates)         // Duration(days: 2)
```

---

## 💡 Real World Examples

### Chat App
```dart
// Auto-refreshing message timestamp
TimeAgoText(
  date: message.sentAt,
  style: TextStyle(fontSize: 10, color: Colors.grey),
  refreshRate: Duration(seconds: 30),
)
```

### Habit Tracker
```dart
// Daily streak
final streak = StreakCalculator.currentStreak(completedDates);
final rate = StreakCalculator.completionRate(
  completedDates,
  start: monthStart,
  end: monthEnd,
);
Text('🔥 $streak day streak  •  ${(rate*100).toInt()}% this month')
```

### Analytics Dashboard
```dart
// Group user activity
final byWeekday = DateGrouper.countByWeekday(loginDates);
final mostActive = DateGrouper.mostActiveWeekday(loginDates);
// Show bar chart of activity by day
```

### HR System
```dart
// Working days between dates skipping holidays
final leaveDays = HolidayHelper.workingDaysBetween(
  leaveStart, leaveEnd,
  holidays: HolidayHelper.indianHolidays(DateTime.now().year),
);
```

### Subscription App
```dart
// Generate billing dates
final billingDates = RecurrenceHelper.monthly(
  start: subscriptionStart,
  until: subscriptionEnd,
);
```

### Invoice System
```dart
// Company date format
Text('Invoice Date: ${date.format('dd-MM-yyyy')}')
Text('Due Date: ${dueDate.format('dd MMM yyyy')}')
```

### Multilingual App
```dart
final locale = SdfLocale.fromCode(
  Localizations.localeOf(context).languageCode,
);
Text(post.createdAt.timeAgoIn(locale))
```

---

## 🔄 Before vs After

```dart
// ❌ Before — 3 packages + 120 lines every project
dependencies:
  timeago: ^3.6.0
  intl: ^0.18.0

// ✅ After — one package, complete toolkit
dependencies:
  smart_date_formatter: ^1.5.0

date.timeAgo                    // relative time
date.format('dd-MM-yyyy')       // custom format
date.timeAgoIn(SdfLocale.hi)   // localization
SmartParser.parse("tomorrow")   // natural language
TimeAgoText(date: date)         // auto-refresh widget
DateRangeHelper.thisMonth()     // DB query range
StreakCalculator.currentStreak(dates) // analytics
```

---

## 🧪 Testing

```bash
flutter test
```

200+ tests covering all features and edge cases.

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