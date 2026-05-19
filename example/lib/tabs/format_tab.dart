import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/example_tile.dart';
import '../widgets/section_header.dart';

/// Demonstrates [DateTime.format] and related extensions.
class FormatTab extends StatelessWidget {
  const FormatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formats = [
      ("format('dd-MM-yyyy')", date.format('dd-MM-yyyy')),
      ("format('MM/dd/yyyy')", date.format('MM/dd/yyyy')),
      ("format('MMM dd, yyyy')", date.format('MMM dd, yyyy')),
      ("format('MMMM dd, yyyy')", date.format('MMMM dd, yyyy')),
      ("format('EEEE')", date.format('EEEE')),
      ("format('EEE, dd MMM yy')", date.format('EEE, dd MMM yy')),
      ("format('hh:mm a')", date.format('hh:mm a')),
      ("format('HH:mm:ss')", date.format('HH:mm:ss')),
      ("format('EEEE, dd MMMM yyyy')", date.format('EEEE, dd MMMM yyyy')),
      ('toReadable', date.toReadable),
      ('toISO', date.toISO),
      ('toTimeString', date.toTimeString),
      ('to12Hour', date.to12Hour),
      ('to24Hour', date.to24Hour),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader("date.format('pattern') — Custom Patterns"),
        const SizedBox(height: 8),
        const CodeBox(
          "DateTime.now().format('dd-MM-yyyy') // '15-06-2024'\n"
          "DateTime.now().toReadable           // 'Saturday, 15 June 2024'\n"
          "DateTime.now().to12Hour             // '02:30 PM'",
        ),
        const SizedBox(height: 12),
        ...formats.map(
          (f) => ExampleTile(label: f.$1, value: f.$2, mono: true),
        ),
      ],
    );
  }
}
