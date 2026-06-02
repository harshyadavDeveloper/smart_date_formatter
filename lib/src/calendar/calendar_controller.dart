import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

/// Controls a [SmartCalendar] programmatically.
///
/// ```dart
/// final controller = SmartCalendarController();
///
/// // Jump to specific date
/// controller.jumpToDate(DateTime(2024, 12, 25));
///
/// // Navigate months
/// controller.nextMonth();
/// controller.previousMonth();
/// ```
class SmartCalendarController extends ChangeNotifier {
  DateTime _focusedDate;
  DateTime _selectedDate;

  /// Creates a [SmartCalendarController].
  ///
  /// ```dart
  /// SmartCalendarController(
  ///   initialDate: DateTime(2024, 6, 15),
  /// )
  /// ```
  SmartCalendarController({DateTime? initialDate})
      : _focusedDate = initialDate ?? DateTime.now(),
        _selectedDate = initialDate ?? DateTime.now();

  /// Currently focused month/date
  DateTime get focusedDate => _focusedDate;

  /// Currently selected date
  DateTime get selectedDate => _selectedDate;

  /// Jump to specific [date]
  void jumpToDate(DateTime date) {
    _focusedDate = date;
    _selectedDate = date;
    notifyListeners();
  }

  /// Jump to specific month without changing selected date
  void jumpToMonth(DateTime month) {
    _focusedDate = DateTime(month.year, month.month, 1);
    notifyListeners();
  }

  /// Go to next month
  void nextMonth() {
    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
    notifyListeners();
  }

  /// Go to previous month
  void previousMonth() {
    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
    notifyListeners();
  }

  /// Go to next week
  void nextWeek() {
    _focusedDate = _focusedDate.add(const Duration(days: 7));
    notifyListeners();
  }

  /// Go to previous week
  void previousWeek() {
    _focusedDate = _focusedDate.subtract(const Duration(days: 7));
    notifyListeners();
  }

  /// Go to next day
  void nextDay() {
    _focusedDate = _focusedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  /// Go to previous day
  void previousDay() {
    _focusedDate = _focusedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }

  /// Jump to today
  void goToToday() {
    _focusedDate = DateTime.now();
    _selectedDate = DateTime.now();
    notifyListeners();
  }

  /// Select a date
  void selectDate(DateTime date) {
    _selectedDate = date;
    _focusedDate = date;
    notifyListeners();
  }

  /// Whether focused date is today's month
  bool get isCurrentMonth {
    final now = DateTime.now();
    return _focusedDate.year == now.year && _focusedDate.month == now.month;
  }
}
