class DateFormatHelper {
  static const List<String> _weekdaysFull = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  static const List<String> _weekdaysShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  static const List<String> _monthsFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String format(DateTime date, String pattern) {
    final hour12 = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;

    // Step 1 — Sab tokens ko null-char placeholders mein convert karo
    // \x00 kabhi bhi normal string mein nahi aata — 100% safe
    final String result = pattern
        .replaceAll('EEEE', '\x00A\x00')
        .replaceAll('EEE', '\x00B\x00')
        .replaceAll('MMMM', '\x00C\x00')
        .replaceAll('MMM', '\x00D\x00')
        .replaceAll('MM', '\x00E\x00')
        .replaceAll('yyyy', '\x00F\x00')
        .replaceAll('yy', '\x00G\x00')
        .replaceAll('dd', '\x00H\x00')
        .replaceAll('d', '\x00I\x00')
        .replaceAll('HH', '\x00J\x00')
        .replaceAll('hh', '\x00K\x00')
        .replaceAll('mm', '\x00L\x00')
        .replaceAll('ss', '\x00M\x00')
        .replaceAll('a', '\x00N\x00')

        // Step 2 — Placeholders ko actual values se replace karo
        .replaceAll('\x00A\x00', _weekdaysFull[date.weekday - 1])
        .replaceAll('\x00B\x00', _weekdaysShort[date.weekday - 1])
        .replaceAll('\x00C\x00', _monthsFull[date.month - 1])
        .replaceAll('\x00D\x00', _monthsShort[date.month - 1])
        .replaceAll('\x00E\x00', date.month.toString().padLeft(2, '0'))
        .replaceAll('\x00F\x00', date.year.toString())
        .replaceAll('\x00G\x00', date.year.toString().substring(2))
        .replaceAll('\x00H\x00', date.day.toString().padLeft(2, '0'))
        .replaceAll('\x00I\x00', date.day.toString())
        .replaceAll('\x00J\x00', date.hour.toString().padLeft(2, '0'))
        .replaceAll('\x00K\x00', hour12.toString().padLeft(2, '0'))
        .replaceAll('\x00L\x00', date.minute.toString().padLeft(2, '0'))
        .replaceAll('\x00M\x00', date.second.toString().padLeft(2, '0'))
        .replaceAll('\x00N\x00', date.hour >= 12 ? 'PM' : 'AM');

    return result;
  }
}
