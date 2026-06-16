import 'dart:async';
import 'package:flutter/material.dart';
import '../date_format_helper.dart';
import '../smart_parser.dart';
import '../extensions.dart';
import '../localization.dart';

/// Validation result for [SmartDateField].
class DateValidationResult {
  /// Whether the date is valid
  final bool isValid;

  /// Error message if invalid
  final String? error;

  /// Creates a valid [DateValidationResult].
  const DateValidationResult.valid()
      : isValid = true,
        error = null;

  /// Creates an invalid [DateValidationResult] with [error].
  const DateValidationResult.invalid(this.error) : isValid = false;
}

/// A smart Flutter form field for date input.
///
/// Supports natural language input, date picker,
/// smart autocomplete, and validation.
///
/// ```dart
/// SmartDateField(
///   label: 'Due Date',
///   onChanged: (date) => print(date),
///   validator: (date) {
///     if (date == null) return 'Date required';
///     if (date.isPast) return 'Must be future date';
///     return null;
///   },
/// )
/// ```
class SmartDateField extends StatefulWidget {
  /// Label for the field
  final String label;

  /// Hint text
  final String? hint;

  /// Called when date changes
  final void Function(DateTime? date)? onChanged;

  /// Validator function — return error string or null
  final String? Function(DateTime? date)? validator;

  /// Initial date value
  final DateTime? initialValue;

  /// Minimum selectable date
  final DateTime? minDate;

  /// Maximum selectable date
  final DateTime? maxDate;

  /// Display format for selected date
  final String displayFormat;

  /// Whether to show date picker icon
  final bool showPickerIcon;

  /// Whether to show clear button
  final bool showClearButton;

  /// Whether to enable natural language input
  final bool enableNaturalLanguage;

  /// Whether to show autocomplete suggestions
  final bool showSuggestions;

  /// Locale for formatting
  final SdfLocale locale;

  /// Controller for external control
  final SmartDateFieldController? controller;

  /// Text style for input
  final TextStyle? textStyle;

  /// Decoration override
  final InputDecoration? decoration;

  /// Creates a [SmartDateField].
  ///
  /// ```dart
  /// SmartDateField(
  ///   label: 'Select Date',
  ///   displayFormat: 'dd MMM yyyy',
  ///   minDate: DateTime.now(),
  ///   onChanged: (date) => setState(() => _date = date),
  /// )
  /// ```
  const SmartDateField({
    super.key,
    this.label = 'Select Date',
    this.hint,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.minDate,
    this.maxDate,
    this.displayFormat = 'dd MMM yyyy',
    this.showPickerIcon = true,
    this.showClearButton = true,
    this.enableNaturalLanguage = true,
    this.showSuggestions = true,
    this.locale = SdfLocale.en,
    this.controller,
    this.textStyle,
    this.decoration,
  });

  @override
  State<SmartDateField> createState() => _SmartDateFieldState();
}

class _SmartDateFieldState extends State<SmartDateField> {
  late TextEditingController _textController;
  DateTime? _selectedDate;
  String? _errorText;
  bool _showSuggestions = false;
  List<String> _suggestions = [];
  Timer? _debounce;

  // Natural language suggestions
  static const _naturalSuggestions = [
    'today',
    'tomorrow',
    'yesterday',
    'next monday',
    'next friday',
    'next week',
    'next month',
    'in 3 days',
    'in 1 week',
    'in 2 weeks',
    'in 1 month',
    'end of month',
    'start of month',
    'end of year',
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _selectedDate = widget.initialValue ?? widget.controller?.value;

    if (_selectedDate != null) {
      _textController.text =
          DateFormatHelper.format(_selectedDate!, widget.displayFormat);
    }

    widget.controller?.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (widget.controller?.value != _selectedDate) {
      setState(() {
        _selectedDate = widget.controller?.value;
        _textController.text = _selectedDate != null
            ? DateFormatHelper.format(_selectedDate!, widget.displayFormat)
            : '';
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!widget.enableNaturalLanguage) return;

      // Try to parse natural language
      final parsed = SmartParser.parse(value);
      if (parsed != null) {
        _setDate(parsed, updateText: false);
      } else {
        // Try standard date format
        try {
          final date = DateTime.parse(value);
          _setDate(date, updateText: false);
        } catch (_) {
          _setDate(null, updateText: false);
        }
      }

      // Update suggestions
      if (widget.showSuggestions && value.isNotEmpty) {
        setState(() {
          _suggestions = _naturalSuggestions
              .where((s) => s.toLowerCase().startsWith(value.toLowerCase()))
              .toList();
          _showSuggestions = _suggestions.isNotEmpty;
        });
      } else {
        setState(() {
          _showSuggestions = false;
          _suggestions = [];
        });
      }
    });
  }

  void _setDate(DateTime? date, {bool updateText = true}) {
    // Validate min/max
    if (date != null) {
      if (widget.minDate != null && date.isBefore(widget.minDate!)) {
        setState(() => _errorText =
            'Date must be after ${DateFormatHelper.format(widget.minDate!, widget.displayFormat)}');
        return;
      }
      if (widget.maxDate != null && date.isAfter(widget.maxDate!)) {
        setState(() => _errorText =
            'Date must be before ${DateFormatHelper.format(widget.maxDate!, widget.displayFormat)}');
        return;
      }
    }

    // Run validator
    final validatorError = widget.validator?.call(date);

    setState(() {
      _selectedDate = date;
      _errorText = validatorError;
      _showSuggestions = false;

      if (updateText && date != null) {
        _textController.text =
            DateFormatHelper.format(date, widget.displayFormat);
      }
    });

    widget.controller?.setValue(date);
    widget.onChanged?.call(date);
  }

  void _selectSuggestion(String suggestion) {
    final parsed = SmartParser.parse(suggestion);
    if (parsed != null) {
      _setDate(parsed);
      _textController.text =
          DateFormatHelper.format(parsed, widget.displayFormat);
    }
    setState(() => _showSuggestions = false);
  }

  Future<void> _openDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: widget.minDate ?? DateTime(now.year - 10),
      lastDate: widget.maxDate ?? DateTime(now.year + 10),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      _setDate(picked);
    }
  }

  void _clearDate() {
    setState(() {
      _selectedDate = null;
      _errorText = null;
      _textController.clear();
      _showSuggestions = false;
    });
    widget.controller?.setValue(null);
    widget.onChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text field
        TextField(
          controller: _textController,
          style: widget.textStyle,
          onChanged: _onTextChanged,
          onTap: () {
            if (widget.showSuggestions && _textController.text.isEmpty) {
              setState(() {
                _suggestions = _naturalSuggestions.take(6).toList();
                _showSuggestions = true;
              });
            }
          },
          decoration: widget.decoration ??
              InputDecoration(
                labelText: widget.label,
                hintText: widget.hint ??
                    (widget.enableNaturalLanguage
                        ? 'Type a date or "tomorrow", "next week"...'
                        : 'Select a date'),
                errorText: _errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: _selectedDate != null
                    ? Icon(
                        Icons.event_available,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : const Icon(Icons.calendar_today, color: Colors.grey),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Clear button
                    if (widget.showClearButton && _selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear,
                            size: 18, color: Colors.grey),
                        onPressed: _clearDate,
                        tooltip: 'Clear date',
                      ),
                    // Date picker button
                    if (widget.showPickerIcon)
                      IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: _openDatePicker,
                        tooltip: 'Open date picker',
                      ),
                  ],
                ),
              ),
        ),

        // Selected date display
        if (_selectedDate != null && _errorText == null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_selectedDate!.calendar}  •  ${_selectedDate!.timeAgo}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Autocomplete suggestions
        if (_showSuggestions && _suggestions.isNotEmpty) ...[
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _suggestions.map((suggestion) {
                final parsed = SmartParser.parse(suggestion);
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.access_time,
                      size: 16, color: Colors.grey),
                  title: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: parsed != null
                      ? Text(
                          DateFormatHelper.format(parsed, widget.displayFormat),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                  onTap: () => _selectSuggestion(suggestion),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

/// Controller for [SmartDateField].
///
/// ```dart
/// final controller = SmartDateFieldController();
///
/// // Set date programmatically
/// controller.setValue(DateTime.now());
///
/// // Clear
/// controller.clear();
///
/// // Get current value
/// print(controller.value);
/// ```
class SmartDateFieldController extends ChangeNotifier {
  DateTime? _value;

  /// Creates a [SmartDateFieldController].
  ///
  /// ```dart
  /// SmartDateFieldController(initialValue: DateTime.now())
  /// ```
  SmartDateFieldController({DateTime? initialValue}) : _value = initialValue;

  /// Current date value
  DateTime? get value => _value;

  /// Whether a date is selected
  bool get hasValue => _value != null;

  /// Set a new date value
  void setValue(DateTime? date) {
    _value = date;
    notifyListeners();
  }

  /// Clear the current value
  void clear() {
    _value = null;
    notifyListeners();
  }
}
