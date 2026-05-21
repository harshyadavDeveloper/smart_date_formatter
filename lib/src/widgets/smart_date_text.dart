import 'package:flutter/material.dart';
import '../extensions.dart';
import '../localization.dart';
import '../formatter.dart';

/// Display mode for [SmartDateText].
enum SmartDateMode {
  /// Relative time — "2 hours ago"
  timeAgo,

  /// Calendar string — "Today", "Monday"
  calendar,

  /// Short timestamp — "2:30 PM", "Mon 4:15 PM"
  shortTimestamp,

  /// Custom format pattern — "dd-MM-yyyy"
  custom,

  /// Auto — picks best format based on how old the date is
  auto,
}

/// An all-in-one text widget for displaying [DateTime] values.
///
/// Automatically picks the best display format based on [mode],
/// with optional auto-refresh support.
///
/// ```dart
/// // Auto mode — picks best format
/// SmartDateText(date: post.createdAt)
///
/// // Specific mode
/// SmartDateText(
///   date: message.sentAt,
///   mode: SmartDateMode.timeAgo,
///   locale: SdfLocale.hi,
///   autoRefresh: true,
/// )
///
/// // Custom format
/// SmartDateText(
///   date: invoice.date,
///   mode: SmartDateMode.custom,
///   pattern: 'dd-MM-yyyy',
/// )
/// ```
class SmartDateText extends StatefulWidget {
  /// The date to display
  final DateTime date;

  /// Display mode — defaults to [SmartDateMode.auto]
  final SmartDateMode mode;

  /// Custom format pattern — used when [mode] is [SmartDateMode.custom]
  final String pattern;

  /// Locale for formatting
  final SdfLocale locale;

  /// Text style
  final TextStyle? style;

  /// Text alignment
  final TextAlign? textAlign;

  /// Whether to auto-refresh the displayed text
  final bool autoRefresh;

  /// How often to refresh — defaults to 60 seconds
  final Duration refreshRate;

  /// Optional prefix text
  final String prefix;

  /// Optional suffix text
  final String suffix;

  /// Creates a [SmartDateText] widget.
  ///
  /// ```dart
  /// SmartDateText(date: DateTime.now())
  /// SmartDateText(
  ///   date: post.createdAt,
  ///   mode: SmartDateMode.timeAgo,
  ///   autoRefresh: true,
  /// )
  /// ```
  const SmartDateText({
    super.key,
    required this.date,
    this.mode = SmartDateMode.auto,
    this.pattern = 'dd MMM yyyy',
    this.locale = SdfLocale.en,
    this.style,
    this.textAlign,
    this.autoRefresh = false,
    this.refreshRate = const Duration(seconds: 60),
    this.prefix = '',
    this.suffix = '',
  });

  @override
  State<SmartDateText> createState() => _SmartDateTextState();
}

class _SmartDateTextState extends State<SmartDateText> {
  late String _text;
  late SmartDateFormatter _formatter;

  @override
  void initState() {
    super.initState();
    _formatter = SmartDateFormatter(locale: widget.locale);
    _text = _buildText();
    if (widget.autoRefresh) {
      _startRefresh();
    }
  }

  @override
  void didUpdateWidget(SmartDateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _formatter = SmartDateFormatter(locale: widget.locale);
    }
    setState(() => _text = _buildText());
  }

  void _startRefresh() {
    Future.doWhile(() async {
      await Future<void>.delayed(widget.refreshRate);
      if (!mounted) return false;
      setState(() => _text = _buildText());
      return true;
    });
  }

  String _buildText() {
    final formatted = _format();
    return '${widget.prefix}$formatted${widget.suffix}';
  }

  String _format() {
    switch (widget.mode) {
      case SmartDateMode.timeAgo:
        return _formatter.format(widget.date);
      case SmartDateMode.calendar:
        return _formatter.calendar(widget.date);
      case SmartDateMode.shortTimestamp:
        return _formatter.shortTimestamp(widget.date);
      case SmartDateMode.custom:
        return widget.date.format(widget.pattern);
      case SmartDateMode.auto:
        return _autoFormat();
    }
  }

  /// Auto picks best format:
  /// - < 24 hours → timeAgo
  /// - < 7 days → calendar
  /// - else → shortTimestamp
  String _autoFormat() {
    final diff = DateTime.now().difference(widget.date).abs();
    if (diff.inHours < 24) return _formatter.format(widget.date);
    if (diff.inDays < 7) return _formatter.calendar(widget.date);
    return _formatter.shortTimestamp(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
