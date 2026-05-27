import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/demo_section.dart';
import '../widgets/demo_code_box.dart';

/// Demonstrates SmartParser natural language parsing.
class ParserPage extends StatefulWidget {
  const ParserPage({super.key});

  @override
  State<ParserPage> createState() => _ParserPageState();
}

class _ParserPageState extends State<ParserPage> {
  final _controller = TextEditingController();
  DateTime? _result;
  bool _canParse = false;

  static const _expressions = [
    'today',
    'tomorrow',
    'yesterday',
    'in 3 days',
    'in 2 weeks',
    'in 1 month',
    '3 days ago',
    '2 weeks ago',
    '1 year ago',
    'next monday',
    'last friday',
    'next week',
    'last week',
    'next month',
    'last year',
    '2024-06-15',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _parse(String value) {
    setState(() {
      _result = SmartParser.parse(value);
      _canParse = SmartParser.canParse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const DemoSection('SmartParser — Natural Language → DateTime'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'SmartParser.parse("tomorrow")     // DateTime\n'
          'SmartParser.parse("next monday")  // DateTime\n'
          'SmartParser.canParse("in 3 days") // true',
        ),
        const SizedBox(height: 16),

        // Live parser
        const DemoSection('Live Parser — Type anything!'),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  onChanged: _parse,
                  decoration: InputDecoration(
                    hintText: 'Try: tomorrow, next monday, in 3 days...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : Icon(
                            _canParse ? Icons.check_circle : Icons.cancel,
                            color: _canParse ? Colors.green : Colors.red,
                          ),
                  ),
                ),
                if (_controller.text.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _canParse
                          ? Colors.green.withValues(alpha: 0.08)
                          : Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _canParse
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                    ),
                    child: _canParse && _result != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('✅ Parsed!',
                                  style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold)),
                              Text('DateTime: ${_result!.toISO}'),
                              Text('calendar: ${_result!.calendar}'),
                              Text('timeAgo: ${_result!.timeAgo}'),
                            ],
                          )
                        : Text(
                            '❌ Cannot parse "${_controller.text}"',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        const DemoSection('Supported Expressions'),
        const SizedBox(height: 8),
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
                backgroundColor: result != null
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                child: Icon(
                  result != null ? Icons.check : Icons.close,
                  color: result != null ? Colors.green : Colors.red,
                  size: 14,
                ),
              ),
              title: Text('"$expr"',
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600)),
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
