import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates SmartDateField widget.
class DateFieldTab extends StatefulWidget {
  const DateFieldTab({super.key});

  @override
  State<DateFieldTab> createState() => _DateFieldTabState();
}

class _DateFieldTabState extends State<DateFieldTab> {
  // Basic field
  DateTime? _basicDate;

  // Validated field
  DateTime? _validatedDate;
  String? _validationMessage;

  // Controller field
  final _controller = SmartDateFieldController();
  DateTime? _controllerDate;

  // Min/Max field
  DateTime? _minMaxDate;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _controllerDate = _controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('SmartDateField v2.2.0'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateField(\n'
          "  label: 'Due Date',\n"
          '  onChanged: (date) => print(date),\n'
          '  validator: (date) {\n'
          '    if (date == null) return "Required";\n'
          '    if (date.isPast) return "Must be future";\n'
          '    return null;\n'
          '  },\n'
          ')',
        ),
        const SizedBox(height: 24),

        // ── Basic ──────────────────────────────────────────────
        const SectionHeader('Basic Usage',
            subtitle:
                'Type naturally — "tomorrow", "next monday", "in 3 days"'),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'Select Date',
          onChanged: (date) => setState(() => _basicDate = date),
        ),
        if (_basicDate != null) ...[
          const SizedBox(height: 8),
          _resultCard(_basicDate!, 'Basic Field Result'),
        ],

        const SizedBox(height: 24),

        // ── Autocomplete Demo ──────────────────────────────────
        const SectionHeader('Smart Autocomplete',
            subtitle: 'Tap field to see suggestions'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateField(\n'
          '  showSuggestions: true,\n'
          '  enableNaturalLanguage: true,\n'
          '  // Try typing: "tom", "next", "in"...\n'
          ')',
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'With Autocomplete',
          showSuggestions: true,
          enableNaturalLanguage: true,
          onChanged: (date) => setState(() {}),
        ),

        const SizedBox(height: 24),

        // ── Validation ─────────────────────────────────────────
        const SectionHeader('Validation',
            subtitle: 'Built-in validator support'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateField(\n'
          '  validator: (date) {\n'
          '    if (date == null) return "Date required";\n'
          '    if (date.isPast) return "Must be future date";\n'
          '    return null;\n'
          '  },\n'
          ')',
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'Future Date Only',
          hint: 'Select a future date',
          validator: (date) {
            if (date == null) return 'Date is required';
            if (date.isPast) return 'Must be a future date';
            return null;
          },
          onChanged: (date) {
            setState(() {
              _validatedDate = date;
              _validationMessage =
                  date != null ? '✅ Valid date selected!' : null;
            });
          },
        ),
        if (_validationMessage != null) ...[
          const SizedBox(height: 6),
          Text(_validationMessage!,
              style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
        if (_validatedDate != null) ...[
          const SizedBox(height: 8),
          _resultCard(_validatedDate!, 'Validated Result'),
        ],

        const SizedBox(height: 24),

        // ── Min Max ────────────────────────────────────────────
        const SectionHeader('Min / Max Date Constraints'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateField(\n'
          '  minDate: DateTime.now(),\n'
          '  maxDate: DateTime.now().addWorkingDays(30),\n'
          ')',
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'Next 30 Working Days',
          hint: 'Only future dates allowed',
          minDate: DateTime.now(),
          maxDate: DateTime.now().addWorkingDays(30),
          onChanged: (date) => setState(() => _minMaxDate = date),
        ),
        if (_minMaxDate != null) ...[
          const SizedBox(height: 8),
          _resultCard(_minMaxDate!, 'Min/Max Result'),
        ],

        const SizedBox(height: 24),

        // ── Custom Format ──────────────────────────────────────
        const SectionHeader('Custom Display Format'),
        const SizedBox(height: 8),
        const CodeBox(
          "SmartDateField(displayFormat: 'dd-MM-yyyy')\n"
          "SmartDateField(displayFormat: 'EEEE, dd MMMM yyyy')\n"
          "SmartDateField(displayFormat: 'MMM dd, yyyy')",
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'dd-MM-yyyy format',
          displayFormat: 'dd-MM-yyyy',
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'Full readable format',
          displayFormat: 'EEEE, dd MMMM yyyy',
          onChanged: (_) {},
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'MMM dd, yyyy format',
          displayFormat: 'MMM dd, yyyy',
          onChanged: (_) {},
        ),

        const SizedBox(height: 24),

        // ── Controller ─────────────────────────────────────────
        const SectionHeader('SmartDateFieldController',
            subtitle: 'Programmatic control'),
        const SizedBox(height: 8),
        const CodeBox(
          'final controller = SmartDateFieldController();\n'
          'controller.setValue(DateTime.now());\n'
          'controller.clear();\n'
          'print(controller.value);\n'
          'print(controller.hasValue);',
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'Controlled Field',
          controller: _controller,
          onChanged: (date) => setState(() => _controllerDate = date),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ctrlBtn('📅 Set Today', () {
              _controller.setValue(DateTime.now());
            }),
            _ctrlBtn('📅 Set Tomorrow', () {
              _controller.setValue(DateTime.now().add(const Duration(days: 1)));
            }),
            _ctrlBtn('📅 Next Monday', () {
              _controller.setValue(DateTime.now().nextMonday);
            }),
            _ctrlBtn('📅 End of Month', () {
              _controller.setValue(DateTime.now().endOfMonth);
            }),
            _ctrlBtn('🗑️ Clear', () {
              _controller.clear();
            }, color: Colors.red),
          ],
        ),
        if (_controllerDate != null) ...[
          const SizedBox(height: 8),
          _resultCard(_controllerDate!, 'Controller Result'),
        ],

        const SizedBox(height: 24),

        // ── No Natural Language ────────────────────────────────
        const SectionHeader('Picker Only Mode',
            subtitle: 'Natural language disabled'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateField(\n'
          '  enableNaturalLanguage: false,\n'
          '  showSuggestions: false,\n'
          '  showPickerIcon: true,\n'
          ')',
        ),
        const SizedBox(height: 8),
        SmartDateField(
          label: 'Picker Only',
          enableNaturalLanguage: false,
          showSuggestions: false,
          showPickerIcon: true,
          onChanged: (date) => setState(() {}),
        ),

        const SizedBox(height: 24),

        // ── Supported Expressions ──────────────────────────────
        const SectionHeader('Supported Natural Language Expressions'),
        const SizedBox(height: 8),
        _expressionsCard(),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _resultCard(DateTime date, String title) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.indigo.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _infoRow('calendar', date.calendar),
            _infoRow('timeAgo', date.timeAgo),
            _infoRow('toReadable', date.toReadable),
            _infoRow('toISO', date.toISO),
            _infoRow('isToday', '${date.isToday}'),
            _infoRow('isWeekend', '${date.isWeekend}'),
          ],
        ),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Colors.indigo)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

  Widget _expressionsCard() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'today', 'tomorrow', 'yesterday',
              'next monday', 'last friday',
              'next week', 'last week',
              'next month', 'last year',
              'in 3 days', 'in 2 weeks',
              '3 days ago', '2 weeks ago',
              'end of month', 'start of year',
              'midnight', 'noon',
              'day after tomorrow',
              'a week from now',
              // Hindi
              'आज', 'कल', 'परसों',
              'अगले सोमवार',
              // Marathi
              'उद्या', 'काल',
            ].map((expr) {
              final parsed = SmartParser.parse(expr);
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(parsed != null
                          ? '✅ "$expr" → ${parsed.format('dd MMM yyyy')}'
                          : '❌ Cannot parse "$expr"'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: parsed != null
                        ? Colors.indigo.withValues(alpha: 0.08)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: parsed != null
                          ? Colors.indigo.withValues(alpha: 0.3)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    expr,
                    style: TextStyle(
                      fontSize: 12,
                      color: parsed != null ? Colors.indigo : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );

  Widget _ctrlBtn(
    String label,
    VoidCallback onTap, {
    Color color = Colors.indigo,
  }) =>
      ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 11),
        ),
        child: Text(label),
      );
}
