## 1.5.0

- Added `StreakCalculator` — habit/attendance streak analysis
  - `currentStreak()` — active streak count
  - `longestStreak()` — best streak ever
  - `isTodayCompleted()` — today check
  - `totalCompleted()` — total days count
  - `completionRate()` — percentage between dates
  - `allStreaks()` — all streak runs as list
  - `missedDays()` — missed days since start
  - `lastCompletedDate()` — most recent date
- Added `DateGrouper` — group dates by time period
  - `byDay/byWeek/byMonth/byQuarter/byYear`
  - `byHour/byWeekday`
  - `countByDay/countByMonth/countByWeekday`
  - `mostActiveDay/mostActiveWeekday/mostActiveHour`
  - `averageGap()`

## 1.4.0

- Added `HolidayHelper` — holiday detection and working day utilities
- Added `isHoliday()`, `isWorkingDay()` static methods
- Added `addWorkingDays()` with holiday skip support
- Added `workingDaysBetween()` with holiday skip support
- Added `nextWorkingDay()`, `previousWorkingDay()`
- Added `indianHolidays()`, `globalHolidays()` preset lists
- Added `HolidayExtension` on DateTime
- Added `RecurrenceHelper` — generate recurring date lists
- Added `RecurrenceFrequency` enum: daily, weekly, monthly, yearly
- Recurrence supports: count, until date, skipWeekends, skipHolidays
- Added `RecurrenceHelper.daily/weekly/monthly/yearly` convenience methods
- Added `RecurrenceHelper.nextOccurrence()`

## 1.3.0

- Added `DateBadge` widget — smart date chip/badge
  - Styles: chip, outlined, flat
  - Auto colors: green (today), blue (tomorrow), orange (yesterday)
  - Custom label support
- Added `SmartDateText` widget — all-in-one date text widget
  - Modes: timeAgo, calendar, shortTimestamp, custom, auto
  - Auto-refresh support
  - prefix/suffix support
- Added `RelativeDateBuilder` widget — builder pattern for custom UI
  - Provides timeAgo, calendar, shortTimestamp strings
  - Auto-refresh support

## 1.2.1

...

## 1.2.1

- Refactored example app — modular tab structure
- Added shared widgets: ExampleTile, SectionHeader, CodeBox
- Stricter analysis_options.yaml rules
- No API changes — pure code quality improvement

...

## 1.2.0

- Added 10 new languages — total 16 supported!
- International: German (de), Russian (ru), Chinese Simplified (zh)
- Indian: Marathi (mr), Gujarati (gu), Bengali (bn),
  Tamil (ta), Telugu (te), Kannada (kn), Punjabi (pa)
- Updated `SdfLocale.supported` — now 16 locales
- Updated `SdfLocale.fromCode()` — supports all 16 codes

...

## 1.1.0

- Added `quarter` — quarter of year (1–4)
- Added `isQ1`, `isQ2`, `isQ3`, `isQ4`
- Added `weekOfYear` — week number (1–53)
- Added `dayOfYear` — day number (1–366)
- Added `isLeapYear`
- Added `isMorning`, `isAfternoon`, `isEvening`, `isNight`
- Added `isSameDay`, `isSameWeek`, `isSameMonth`, `isSameYear`
- Added `nextMonday` through `nextSunday`
- Added `previousMonday` through `previousSunday`
- Added `copyWith` — create modified copies of DateTime

...

## 1.0.1

- Added live playground link in README
- Minor documentation improvements

## 1.0.0

- 🎉 Stable release!
- Added `TimeAgoText` widget — auto-refreshing relative time widget
- Added `CountdownText` widget — live countdown to a target DateTime
- Added `DateRangeHelper` — ready-made date ranges for DB queries
- Added `DateRange` class with `contains()`, `overlaps()`, `days`
- Ranges: today, yesterday, tomorrow, thisWeek, lastWeek, nextWeek,
  thisMonth, lastMonth, nextMonth, thisYear, lastYear,
  lastNDays(n), nextNDays(n), custom(s,e), quarter(q), currentQuarter
- Stable API — no breaking changes planned

## 0.9.0

- Added `SdfLocale` — built-in localization support
- Supported locales: English, Hindi, Spanish, French, Japanese, Arabic
- Added `SmartDateFormatter(locale: SdfLocale.hi)` constructor
- Added `timeAgoIn(SdfLocale)` DateTime extension
- Added `SdfLocale.fromCode(String)` — locale by code string
- Added `SmartParser` — natural language to DateTime
- SmartParser supports: today, tomorrow, yesterday, next/last week/month/year,
  in N days/weeks/months, N days/weeks ago, next/last weekday

## 0.5.0

- Added `addWorkingDays(n)` — adds working days skipping weekends
- Added `daysUntil(date)` — days between two dates
- Added `daysSince(date)` — days since a date
- Added `isBetween(start, end)` — range check
- Added `isWeekend` — Saturday or Sunday check
- Added `isWeekday` — Monday to Friday check
- Added `age` — age in years from birthdate
- Added `startOfWeek` / `endOfWeek`
- Added `startOfMonth` / `endOfMonth`
- Added `startOfYear` / `endOfYear`
- Added `workingDaysUntil(date)` — working days count
- Added `DateCalculations` class

## 0.1.0

- Added `format(String pattern)` extension — custom pattern-based formatting
- Added `toReadable` — "Saturday, 15 June 2024"
- Added `toISO` — "2024-06-15T14:30:00"
- Added `toTimeString` — "14:30:00"
- Added `to12Hour` — "02:30 PM"
- Added `to24Hour` — "14:30"
- Added `DateFormatHelper` class — zero dependency formatter
- Supported tokens: dd, d, MM, MMM, MMMM, yyyy, yy, HH, hh, mm, ss, a, EEEE, EEE

## 0.0.4

- Added missing CHANGELOG.md to comply with pub.dev requirements
- Improved package documentation and structure
- Minor internal improvements and cleanup

## 0.0.3

- Initial stable release of smart_date_formatter
- Converts DateTime into human-readable formats like:
  - "Just now"
  - "2 hours ago"
  - "Yesterday"
  - "Next Monday"

- Improved formatting logic and edge case handling

## 0.0.2

- Minor improvements and bug fixes

## 0.0.1

- Initial project setup
