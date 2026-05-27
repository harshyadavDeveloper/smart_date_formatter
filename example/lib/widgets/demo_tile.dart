import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable label → value tile with copy on tap.
class DemoTile extends StatelessWidget {
  const DemoTile({
    super.key,
    required this.label,
    required this.value,
    this.mono = false,
    this.color,
  });

  final String label;
  final String value;
  final bool mono;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied: $value'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
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
          style: TextStyle(
            color: color ?? Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
