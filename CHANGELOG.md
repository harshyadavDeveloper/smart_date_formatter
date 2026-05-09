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
