import 'package:flutter/material.dart';
import '../date_format_helper.dart';
import '../date_range_helper.dart';
import '../extensions.dart';

/// Preset range options for [SmartDateRangePicker].
enum DateRangePreset {
  /// Today only
  today,

  /// Yesterday only
  yesterday,

  /// This week — Monday to Sunday
  thisWeek,

  /// Last week
  lastWeek,

  /// This month
  thisMonth,

  /// Last month
  lastMonth,

  /// Last 7 days
  last7Days,

  /// Last 30 days
  last30Days,

  /// Last 90 days
  last90Days,

  /// This year
  thisYear,

  /// Custom — user selected
  custom,
}

/// Result of a date range selection.
class SelectedDateRange {
  /// Start date of the range
  final DateTime start;

  /// End date of the range
  final DateTime end;

  /// Preset used — null if custom
  final DateRangePreset? preset;

  /// Creates a [SelectedDateRange].
  const SelectedDateRange({
    required this.start,
    required this.end,
    this.preset,
  });

  /// Number of days in range
  int get days => end.difference(start).inDays + 1;

  /// Whether range contains [date]
  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return (d.isAtSameMomentAs(s) || d.isAfter(s)) &&
        (d.isAtSameMomentAs(e) || d.isBefore(e));
  }

  /// Converts to [DateRange]
  DateRange toDateRange() => DateRange(start: start, end: end);

  @override
  String toString() => 'SelectedDateRange(${start.toIso8601String()} → '
      '${end.toIso8601String()}, $days days)';
}

/// Controller for [SmartDateRangePicker].
///
/// ```dart
/// final controller = SmartDateRangePickerController();
/// controller.setRange(start, end);
/// controller.setPreset(DateRangePreset.thisMonth);
/// controller.clear();
/// print(controller.value); // SelectedDateRange?
/// ```
class SmartDateRangePickerController extends ChangeNotifier {
  SelectedDateRange? _value;

  /// Creates a [SmartDateRangePickerController].
  ///
  /// ```dart
  /// SmartDateRangePickerController(
  ///   initialRange: SelectedDateRange(
  ///     start: DateTime.now(),
  ///     end: DateTime.now().add(Duration(days: 7)),
  ///   ),
  /// )
  /// ```
  SmartDateRangePickerController({
    SelectedDateRange? initialRange,
  }) : _value = initialRange;

  /// Current selected range
  SelectedDateRange? get value => _value;

  /// Whether a range is selected
  bool get hasValue => _value != null;

  /// Set a custom range
  void setRange(DateTime start, DateTime end) {
    _value = SelectedDateRange(
      start: start,
      end: end,
      preset: DateRangePreset.custom,
    );
    notifyListeners();
  }

  /// Set a preset range
  void setPreset(DateRangePreset preset) {
    final range = _rangeForPreset(preset);
    if (range != null) {
      _value = SelectedDateRange(
        start: range.start,
        end: range.end,
        preset: preset,
      );
      notifyListeners();
    }
  }

  /// Clear selection
  void clear() {
    _value = null;
    notifyListeners();
  }

  static DateRange? _rangeForPreset(DateRangePreset preset) {
    switch (preset) {
      case DateRangePreset.today:
        return DateRangeHelper.today();
      case DateRangePreset.yesterday:
        return DateRangeHelper.yesterday();
      case DateRangePreset.thisWeek:
        return DateRangeHelper.thisWeek();
      case DateRangePreset.lastWeek:
        return DateRangeHelper.lastWeek();
      case DateRangePreset.thisMonth:
        return DateRangeHelper.thisMonth();
      case DateRangePreset.lastMonth:
        return DateRangeHelper.lastMonth();
      case DateRangePreset.last7Days:
        return DateRangeHelper.lastNDays(7);
      case DateRangePreset.last30Days:
        return DateRangeHelper.lastNDays(30);
      case DateRangePreset.last90Days:
        return DateRangeHelper.lastNDays(90);
      case DateRangePreset.thisYear:
        return DateRangeHelper.thisYear();
      case DateRangePreset.custom:
        return null;
    }
  }
}

/// A smart date range picker widget.
///
/// Supports inline and dialog modes, preset ranges,
/// and visual range highlighting.
///
/// ```dart
/// // Inline
/// SmartDateRangePicker(
///   onRangeSelected: (range) => print(range),
/// )
///
/// // Dialog
/// SmartDateRangePicker.showDialog(
///   context: context,
///   onRangeSelected: (range) => print(range),
/// )
/// ```
class SmartDateRangePicker extends StatefulWidget {
  /// Called when range is selected
  final void Function(SelectedDateRange range)? onRangeSelected;

  /// Called when selection is cleared
  final VoidCallback? onCleared;

  /// External controller
  final SmartDateRangePickerController? controller;

  /// Minimum selectable date
  final DateTime? minDate;

  /// Maximum selectable date
  final DateTime? maxDate;

  /// Initial selected range
  final SelectedDateRange? initialRange;

  /// Whether to show preset buttons
  final bool showPresets;

  /// Custom preset labels — override default labels
  final Map<DateRangePreset, String>? presetLabels;

  /// Which presets to show
  final List<DateRangePreset> presets;

  /// Primary color
  final Color primaryColor;

  /// Range highlight color
  final Color rangeColor;

  /// Display format for dates
  final String displayFormat;

  /// Whether to show confirm button
  final bool showConfirmButton;

  /// Confirm button label
  final String confirmLabel;

  /// Creates a [SmartDateRangePicker].
  ///
  /// ```dart
  /// SmartDateRangePicker(
  ///   onRangeSelected: (range) {
  ///     print('${range.start} → ${range.end}');
  ///     print('${range.days} days');
  ///   },
  ///   showPresets: true,
  ///   primaryColor: Colors.indigo,
  /// )
  /// ```
  const SmartDateRangePicker({
    super.key,
    this.onRangeSelected,
    this.onCleared,
    this.controller,
    this.minDate,
    this.maxDate,
    this.initialRange,
    this.showPresets = true,
    this.presetLabels,
    this.presets = const [
      DateRangePreset.today,
      DateRangePreset.thisWeek,
      DateRangePreset.thisMonth,
      DateRangePreset.last7Days,
      DateRangePreset.last30Days,
      DateRangePreset.thisYear,
    ],
    this.primaryColor = Colors.indigo,
    this.rangeColor = Colors.indigo,
    this.displayFormat = 'dd MMM yyyy',
    this.showConfirmButton = true,
    this.confirmLabel = 'Apply Range',
  });

  /// Shows [SmartDateRangePicker] as a bottom sheet dialog.
  ///
  /// ```dart
  /// await SmartDateRangePicker.showAsBottomSheet(
  ///   context: context,
  ///   onRangeSelected: (range) => print(range),
  /// );
  /// ```
  static Future<SelectedDateRange?> showAsBottomSheet({
    required BuildContext context,
    void Function(SelectedDateRange range)? onRangeSelected,
    DateTime? minDate,
    DateTime? maxDate,
    SelectedDateRange? initialRange,
    Color primaryColor = Colors.indigo,
    List<DateRangePreset> presets = const [
      DateRangePreset.today,
      DateRangePreset.thisWeek,
      DateRangePreset.thisMonth,
      DateRangePreset.last7Days,
      DateRangePreset.last30Days,
      DateRangePreset.thisYear,
    ],
  }) async {
    SelectedDateRange? result;
    await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Date Range',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SmartDateRangePicker(
              minDate: minDate,
              maxDate: maxDate,
              initialRange: initialRange,
              primaryColor: primaryColor,
              presets: presets,
              confirmLabel: 'Apply',
              onRangeSelected: (range) {
                result = range;
                onRangeSelected?.call(range);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
    return result;
  }

  @override
  State<SmartDateRangePicker> createState() => _SmartDateRangePickerState();
}

class _SmartDateRangePickerState extends State<SmartDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedMonth = DateTime.now();
  DateRangePreset? _activePreset;
  bool _selectingStart = true;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialRange ?? widget.controller?.value;
    if (initial != null) {
      _startDate = initial.start;
      _endDate = initial.end;
      _activePreset = initial.preset;
    }
    widget.controller?.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final val = widget.controller?.value;
    setState(() {
      _startDate = val?.start;
      _endDate = val?.end;
      _activePreset = val?.preset;
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_selectingStart || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
        _selectingStart = false;
        _activePreset = null;
      } else {
        if (date.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
        _selectingStart = true;
        _activePreset = DateRangePreset.custom;
        _notifySelection();
      }
    });
  }

  void _selectPreset(DateRangePreset preset) {
    final range = SmartDateRangePickerController._rangeForPreset(preset);
    if (range == null) return;

    setState(() {
      _startDate = range.start;
      _endDate = range.end;
      _activePreset = preset;
      _selectingStart = true;
    });

    widget.controller?.setPreset(preset);
    _notifySelection();
  }

  void _notifySelection() {
    if (_startDate != null && _endDate != null) {
      final range = SelectedDateRange(
        start: _startDate!,
        end: _endDate!,
        preset: _activePreset,
      );
      widget.controller?.setRange(_startDate!, _endDate!);
      if (!widget.showConfirmButton) {
        widget.onRangeSelected?.call(range);
      }
    }
  }

  void _confirmSelection() {
    if (_startDate != null && _endDate != null) {
      widget.onRangeSelected?.call(SelectedDateRange(
        start: _startDate!,
        end: _endDate!,
        preset: _activePreset,
      ));
    }
  }

  void _clearSelection() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _activePreset = null;
      _selectingStart = true;
    });
    widget.controller?.clear();
    widget.onCleared?.call();
  }

  bool _isInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final e = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    return d.isAfter(s) && d.isBefore(e);
  }

  bool _isStart(DateTime date) =>
      _startDate != null && date.isSameDay(_startDate!);

  bool _isEnd(DateTime date) => _endDate != null && date.isSameDay(_endDate!);

  bool _isDisabled(DateTime date) {
    if (widget.minDate != null && date.isBefore(widget.minDate!)) {
      return true;
    }
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) {
      return true;
    }
    return false;
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final int startWeekday = firstDay.weekday - 1;
    final days = <DateTime>[];

    for (int i = startWeekday - 1; i >= 0; i--) {
      days.add(firstDay.subtract(Duration(days: i + 1)));
    }
    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }
    final int remaining = 42 - days.length;
    for (int i = 1; i <= remaining; i++) {
      days.add(lastDay.add(Duration(days: i)));
    }
    return days;
  }

  String _presetLabel(DateRangePreset preset) {
    if (widget.presetLabels?.containsKey(preset) == true) {
      return widget.presetLabels![preset]!;
    }
    switch (preset) {
      case DateRangePreset.today:
        return 'Today';
      case DateRangePreset.yesterday:
        return 'Yesterday';
      case DateRangePreset.thisWeek:
        return 'This Week';
      case DateRangePreset.lastWeek:
        return 'Last Week';
      case DateRangePreset.thisMonth:
        return 'This Month';
      case DateRangePreset.lastMonth:
        return 'Last Month';
      case DateRangePreset.last7Days:
        return 'Last 7 Days';
      case DateRangePreset.last30Days:
        return 'Last 30 Days';
      case DateRangePreset.last90Days:
        return 'Last 90 Days';
      case DateRangePreset.thisYear:
        return 'This Year';
      case DateRangePreset.custom:
        return 'Custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(_focusedMonth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Presets ─────────────────────────────────────
        if (widget.showPresets) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.presets.map((preset) {
                final isActive = _activePreset == preset;
                return GestureDetector(
                  onTap: () => _selectPreset(preset),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isActive ? widget.primaryColor : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? widget.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      _presetLabel(preset),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Selected Range Display ───────────────────────
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.primaryColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: widget.primaryColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                    Text(
                      _startDate != null
                          ? DateFormatHelper.format(
                              _startDate!, widget.displayFormat)
                          : 'Select start',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _startDate != null
                            ? widget.primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'End Date',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                    Text(
                      _endDate != null
                          ? DateFormatHelper.format(
                              _endDate!, widget.displayFormat)
                          : 'Select end',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _endDate != null
                            ? widget.primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (_startDate != null && _endDate != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${SelectedDateRange(start: _startDate!, end: _endDate!).days}d',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Instruction text ─────────────────────────────
        Text(
          _startDate == null
              ? 'Tap to select start date'
              : _endDate == null
                  ? 'Tap to select end date'
                  : 'Range selected — tap to change',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 8),

        // ── Calendar Header ──────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month - 1);
              }),
              icon: const Icon(Icons.chevron_left),
              visualDensity: VisualDensity.compact,
            ),
            Text(
              DateFormatHelper.format(_focusedMonth, 'MMMM yyyy'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            IconButton(
              onPressed: () => setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month + 1);
              }),
              icon: const Icon(Icons.chevron_right),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),

        // ── Weekday headers ──────────────────────────────
        Row(
          children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
              .map((d) => Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ))
              .toList(),
        ),

        const SizedBox(height: 4),

        // ── Calendar Grid ────────────────────────────────
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            final isCurrentMonth = date.month == _focusedMonth.month;
            final isStart = _isStart(date);
            final isEnd = _isEnd(date);
            final inRange = _isInRange(date);
            final isToday = date.isToday;
            final isDisabled = _isDisabled(date);
            final isWeekend = date.isWeekend;

            return GestureDetector(
              onTap: isDisabled ? null : () => _onDateTap(date),
              child: Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: isStart || isEnd
                      ? widget.primaryColor
                      : inRange
                          ? widget.rangeColor.withValues(alpha: 0.12)
                          : Colors.transparent,
                  borderRadius: isStart
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )
                      : isEnd
                          ? const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )
                          : inRange
                              ? BorderRadius.zero
                              : BorderRadius.circular(8),
                  border: isToday && !isStart && !isEnd
                      ? Border.all(
                          color: widget.primaryColor,
                          width: 1.5,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isStart || isEnd || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isStart || isEnd
                          ? Colors.white
                          : isDisabled
                              ? Colors.grey.shade300
                              : !isCurrentMonth
                                  ? Colors.grey.shade400
                                  : isWeekend
                                      ? Colors.red.shade400
                                      : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // ── Action Buttons ───────────────────────────────
        Row(
          children: [
            // Clear button
            if (_startDate != null || _endDate != null)
              TextButton.icon(
                onPressed: _clearSelection,
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
            const Spacer(),

            // Confirm button
            if (widget.showConfirmButton &&
                _startDate != null &&
                _endDate != null)
              ElevatedButton.icon(
                onPressed: _confirmSelection,
                icon: const Icon(Icons.check, size: 16),
                label: Text(widget.confirmLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
