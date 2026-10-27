import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates [SmartParser] natural language parsing.
class ParserTab extends StatelessWidget {
  const ParserTab({super.key});

  // Fixed reference date so playground results are reproducible
  static final _ref = DateTime(2024, 6, 15); // Sat 15 Jun 2024

  static const _expressions = [
    'today',
    'tomorrow',
    'yesterday',
    'in 3 days',
    'in 2 weeks',
    'in 1 month',
    '3 days ago',
    '2 weeks ago',
    'next monday',
    'last friday',
    'next week',
    'last week',
    'next month',
    'last year',
    '2024-06-15',
    'in 1 month',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('SmartParser – Natural Language → DateTime'),
        const SizedBox(height: 8),
        // Reference date banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Text(
                'Reference date: 15 Jun 2024 (fixed for reproducibility)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartParser.parse("tomorrow")     // DateTime\n'
          'SmartParser.parse("next monday")  // DateTime\n'
          'SmartParser.canParse("in 3 days") // true\n'
          'SmartParser.parseOrThrow("blah")  // FormatException',
        ),
        const SizedBox(height: 12),
        ..._expressions.map((expr) {
          final result = SmartParser.parse(expr, now: _ref);
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor:
                    result != null ? Colors.green.shade50 : Colors.red.shade50,
                child: Icon(
                  result != null ? Icons.check : Icons.close,
                  color: result != null ? Colors.green : Colors.red,
                  size: 14,
                ),
              ),
              title: Text(
                '"$expr"',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: result != null
                  ? Text(
                      result.format('dd MMM yyyy'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  : const Text('null', style: TextStyle(color: Colors.red)),
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edge Case — Month-end clamping',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Reference: 31 Jan 2024 (to show clamping)',
                style: TextStyle(fontSize: 11, color: Colors.purple.shade500),
              ),
              const SizedBox(height: 8),
              ...[
                ('in 1 month', DateTime(2024, 1, 31)),
                ('in 1 month', DateTime(2023, 1, 31)),
                ('next month', DateTime(2024, 1, 31)),
              ].map((entry) {
                final result = SmartParser.parse(entry.$1, now: entry.$2);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '"${entry.$1}" from ${entry.$2.format('dd MMM yyyy')}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.indigo,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        result?.format('dd MMM yyyy') ?? 'null',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
