import 'dart:async';
import 'package:flutter/material.dart';
import '../localization.dart';
import '../formatter.dart';

/// Signature for [RelativeDateBuilder] builder function.
typedef RelativeDateWidgetBuilder = Widget Function(
  BuildContext context,
  String timeAgo,
  String calendar,
  String shortTimestamp,
  DateTime date,
);

/// A builder widget that provides formatted date strings to its child.
///
/// Gives full control over how the date is displayed while handling
/// all formatting and auto-refresh internally.
///
/// ```dart
/// RelativeDateBuilder(
///   date: post.createdAt,
///   builder: (context, timeAgo, calendar, timestamp, date) {
///     return Row(children: [
///       Icon(Icons.access_time, size: 12),
///       Text(timeAgo),
///       if (date.isToday) Badge(label: Text('NEW')),
///     ]);
///   },
/// )
/// ```
class RelativeDateBuilder extends StatefulWidget {
  /// The date to format
  final DateTime date;

  /// Locale for formatting
  final SdfLocale locale;

  /// Whether to auto-refresh
  final bool autoRefresh;

  /// How often to refresh
  final Duration refreshRate;

  /// Builder function receiving all formatted strings
  final RelativeDateWidgetBuilder builder;

  /// Creates a [RelativeDateBuilder] widget.
  ///
  /// ```dart
  /// RelativeDateBuilder(
  ///   date: message.sentAt,
  ///   autoRefresh: true,
  ///   builder: (ctx, timeAgo, calendar, timestamp, date) =>
  ///     Text(timeAgo),
  /// )
  /// ```
  const RelativeDateBuilder({
    super.key,
    required this.date,
    required this.builder,
    this.locale = SdfLocale.en,
    this.autoRefresh = false,
    this.refreshRate = const Duration(seconds: 60),
  });

  @override
  State<RelativeDateBuilder> createState() => _RelativeDateBuilderState();
}

class _RelativeDateBuilderState extends State<RelativeDateBuilder> {
  late SmartDateFormatter _formatter;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _formatter = SmartDateFormatter(locale: widget.locale);
    if (widget.autoRefresh) _startTimer();
  }

  @override
  void didUpdateWidget(RelativeDateBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _formatter = SmartDateFormatter(locale: widget.locale);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.refreshRate, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _formatter.format(widget.date),
      _formatter.calendar(widget.date),
      _formatter.shortTimestamp(widget.date),
      widget.date,
    );
  }
}
