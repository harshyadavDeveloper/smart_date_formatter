import 'dart:async';
import 'package:flutter/material.dart';
import '../formatter.dart';
import '../localization.dart';

/// A Flutter widget that displays a [DateTime] as a human-readable
/// relative time string — and **automatically refreshes** itself.
///
/// No `setState`, no `Timer` management — it's all handled internally.
///
/// ```dart
/// TimeAgoText(
///   date: message.sentAt,
///   style: TextStyle(color: Colors.grey, fontSize: 12),
/// )
///
/// // With locale
/// TimeAgoText(
///   date: message.sentAt,
///   locale: SdfLocale.hi,
///   refreshRate: Duration(seconds: 30),
/// )
/// ```
class TimeAgoText extends StatefulWidget {
  /// The date to display as relative time
  final DateTime date;

  /// Text style
  final TextStyle? style;

  /// Locale for formatting — defaults to English
  final SdfLocale locale;

  /// How often to refresh the displayed text
  /// Defaults to 60 seconds
  final Duration refreshRate;

  /// Optional text align
  final TextAlign? textAlign;

  /// Optional prefix — e.g. "Sent " → "Sent 2 hours ago"
  final String prefix;

  /// Optional suffix — e.g. " ago" added after the time string
  final String suffix;

  const TimeAgoText({
    super.key,
    required this.date,
    this.style,
    this.locale = SdfLocale.en,
    this.refreshRate = const Duration(seconds: 60),
    this.textAlign,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  State<TimeAgoText> createState() => _TimeAgoTextState();
}

class _TimeAgoTextState extends State<TimeAgoText> {
  late Timer _timer;
  late SmartDateFormatter _formatter;
  late String _text;

  @override
  void initState() {
    super.initState();
    _formatter = SmartDateFormatter(locale: widget.locale);
    _text = _buildText();
    _startTimer();
  }

  @override
  void didUpdateWidget(TimeAgoText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _formatter = SmartDateFormatter(locale: widget.locale);
    }
    if (oldWidget.date != widget.date ||
        oldWidget.refreshRate != widget.refreshRate) {
      _timer.cancel();
      _text = _buildText();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.refreshRate, (_) {
      if (mounted) {
        setState(() => _text = _buildText());
      }
    });
  }

  String _buildText() =>
      '${widget.prefix}${_formatter.format(widget.date)}${widget.suffix}';

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
