import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates [SmartParser] natural language parsing.
class ParserTab extends StatelessWidget {
  const ParserTab({super.key});

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
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('SmartParser — Natural Language → DateTime'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartParser.parse("tomorrow")     // DateTime\n'
          'SmartParser.parse("next monday")  // DateTime\n'
          'SmartParser.canParse("in 3 days") // true\n'
          'SmartParser.parseOrThrow("blah")  // FormatException',
        ),
        const SizedBox(height: 12),
        ..._expressions.map((expr) {
          final result = SmartParser.parse(expr);
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    fontWeight: FontWeight.w600),
              ),
              trailing: result != null
                  ? Text(result.format('dd MMM yyyy'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12))
                  : const Text('null', style: TextStyle(color: Colors.red)),
            ),
          );
        }),
      ],
    );
  }
}
