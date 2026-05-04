import 'dart:async';
import 'package:flutter/material.dart';

/// A Flutter widget that counts down to a [target] DateTime
/// and automatically updates every second.
///
/// ```dart
/// CountdownText(
///   target: event.startsAt,
///   format: '{d}d {h}h {m}m {s}s',
///   style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
///   onFinished: () => print('Event started!'),
/// )
/// ```
///
/// Format tokens:
/// - `{d}` → days remaining
/// - `{h}` → hours (0–23)
/// - `{m}` → minutes (0–59)
/// - `{s}` → seconds (0–59)
/// - `{hh}` → hours with leading zero
/// - `{mm}` → minutes with leading zero
/// - `{ss}` → seconds with leading zero
class CountdownText extends StatefulWidget {
  /// Target date to count down to
  final DateTime target;

  /// Format string using tokens: {d}, {h}, {m}, {s}, {hh}, {mm}, {ss}
  /// Default: '{h}:{mm}:{ss}'
  final String format;

  /// Text style
  final TextStyle? style;

  /// Text align
  final TextAlign? textAlign;

  /// Called when countdown reaches zero
  final VoidCallback? onFinished;

  /// Text to show when countdown finishes
  final String finishedText;

  /// Whether to show days when 0
  final bool showZeroDays;

  const CountdownText({
    super.key,
    required this.target,
    this.format = '{h}:{mm}:{ss}',
    this.style,
    this.textAlign,
    this.onFinished,
    this.finishedText = 'Started!',
    this.showZeroDays = false,
  });

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late Timer _timer;
  late Duration _remaining;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _remaining = _calculateRemaining();
    _startTimer();
  }

  Duration _calculateRemaining() {
    final diff = widget.target.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final remaining = _calculateRemaining();
      setState(() => _remaining = remaining);
      if (remaining == Duration.zero && !_finished) {
        _finished = true;
        widget.onFinished?.call();
        _timer.cancel();
      }
    });
  }

  String _buildText() {
    if (_finished) return widget.finishedText;

    final d = _remaining.inDays;
    final h = _remaining.inHours % 24;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;

    String result = widget.format;
    result = result.replaceAll('{d}', '$d');
    result = result.replaceAll('{h}', '$h');
    result = result.replaceAll('{m}', '$m');
    result = result.replaceAll('{s}', '$s');
    result = result.replaceAll('{hh}', h.toString().padLeft(2, '0'));
    result = result.replaceAll('{mm}', m.toString().padLeft(2, '0'));
    result = result.replaceAll('{ss}', s.toString().padLeft(2, '0'));

    return result;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _buildText(),
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
