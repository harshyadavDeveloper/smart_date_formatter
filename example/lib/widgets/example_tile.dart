import 'package:flutter/material.dart';

/// A simple label → value tile used across all tabs.
class ExampleTile extends StatelessWidget {
  const ExampleTile({
    super.key,
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;

  /// Whether label uses monospace font
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: mono ? 'monospace' : null,
            color: mono ? Colors.indigo : null,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
