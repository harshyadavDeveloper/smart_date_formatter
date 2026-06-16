import 'package:flutter/material.dart';

/// Section header with optional subtitle.
class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.title, {
    super.key,
    this.subtitle, // 👈 add karo
  });

  final String title;
  final String? subtitle; // 👈 add karo

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          // 👈 add karo
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
