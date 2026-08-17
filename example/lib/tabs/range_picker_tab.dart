import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates SmartDateRangePicker widget.
class RangePickerTab extends StatefulWidget {
  const RangePickerTab({super.key});

  @override
  State<RangePickerTab> createState() => _RangePickerTabState();
}

class _RangePickerTabState extends State<RangePickerTab> {
  SelectedDateRange? _basicRange;
  SelectedDateRange? _controllerRange;
  SelectedDateRange? _customRange;
  final _controller = SmartDateRangePickerController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _controllerRange = _controller.value);
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
        const SectionHeader('SmartDateRangePicker v2.3.0'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateRangePicker(\n'
          '  onRangeSelected: (range) {\n'
          '    print(range.start);\n'
          '    print(range.end);\n'
          '    print(range.days);\n'
          '  },\n'
          '  showPresets: true,\n'
          '  primaryColor: Colors.indigo,\n'
          ')',
        ),
        const SizedBox(height: 24),

        // ── Basic ───────────────────────────────────────
        const SectionHeader('Basic Usage',
            subtitle: 'Tap dates to select range'),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SmartDateRangePicker(
              showConfirmButton: true,
              onRangeSelected: (range) => setState(() => _basicRange = range),
              onCleared: () => setState(() => _basicRange = null),
            ),
          ),
        ),
        if (_basicRange != null) ...[
          const SizedBox(height: 8),
          _rangeResultCard(_basicRange!, 'Selected Range'),
        ],

        const SizedBox(height: 24),

        // ── Custom Presets ──────────────────────────────
        const SectionHeader('Custom Presets',
            subtitle: 'Show only specific presets'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateRangePicker(\n'
          '  presets: [\n'
          '    DateRangePreset.last7Days,\n'
          '    DateRangePreset.last30Days,\n'
          '    DateRangePreset.last90Days,\n'
          '    DateRangePreset.thisYear,\n'
          '  ],\n'
          ')',
        ),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SmartDateRangePicker(
              showConfirmButton: false,
              presets: const [
                DateRangePreset.last7Days,
                DateRangePreset.last30Days,
                DateRangePreset.last90Days,
                DateRangePreset.thisYear,
              ],
              onRangeSelected: (range) => setState(() => _customRange = range),
              onCleared: () => setState(() => _customRange = null),
            ),
          ),
        ),
        if (_customRange != null) ...[
          const SizedBox(height: 8),
          _rangeResultCard(_customRange!, 'Analytics Range'),
        ],

        const SizedBox(height: 24),

        // ── Controller ──────────────────────────────────
        const SectionHeader('Controller — Programmatic Control'),
        const SizedBox(height: 8),
        const CodeBox(
          'final controller = SmartDateRangePickerController();\n'
          'controller.setPreset(DateRangePreset.thisMonth);\n'
          'controller.setRange(start, end);\n'
          'controller.clear();\n'
          'print(controller.value?.days);',
        ),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                SmartDateRangePicker(
                  controller: _controller,
                  showConfirmButton: false,
                  onRangeSelected: (range) =>
                      setState(() => _controllerRange = range),
                  onCleared: () => setState(() => _controllerRange = null),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ctrlBtn('📅 This Week', () {
                      _controller.setPreset(DateRangePreset.thisWeek);
                    }),
                    _ctrlBtn('📅 This Month', () {
                      _controller.setPreset(DateRangePreset.thisMonth);
                    }),
                    _ctrlBtn('📅 Last 30 Days', () {
                      _controller.setPreset(DateRangePreset.last30Days);
                    }),
                    _ctrlBtn('📅 Custom Range', () {
                      _controller.setRange(
                        DateTime.now().subtract(const Duration(days: 10)),
                        DateTime.now().add(const Duration(days: 5)),
                      );
                    }),
                    _ctrlBtn('🗑️ Clear', () {
                      _controller.clear();
                    }, color: Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_controllerRange != null) ...[
          const SizedBox(height: 8),
          _rangeResultCard(_controllerRange!, 'Controller Range'),
        ],

        const SizedBox(height: 24),

        // ── Bottom Sheet ────────────────────────────────
        const SectionHeader('Bottom Sheet Mode',
            subtitle: 'Show as modal dialog'),
        const SizedBox(height: 8),
        const CodeBox(
          'await SmartDateRangePicker.showAsBottomSheet(\n'
          '  context: context,\n'
          '  onRangeSelected: (range) => print(range),\n'
          ')',
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await SmartDateRangePicker.showAsBottomSheet(
                context: context,
                onRangeSelected: (range) {
                  setState(() => _basicRange = range);
                },
              );
              if (result != null) {
                setState(() => _basicRange = result);
              }
            },
            icon: const Icon(Icons.date_range),
            label: const Text('Open Date Range Picker'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        if (_basicRange != null) ...[
          const SizedBox(height: 8),
          _rangeResultCard(_basicRange!, 'Bottom Sheet Result'),
        ],

        const SizedBox(height: 24),

        // ── Real World Use Cases ─────────────────────────
        const SectionHeader('Real World Use Cases'),
        const SizedBox(height: 8),
        _useCasesCard(),
        const SizedBox(height: 16),
        const SizedBox(height: 24),

// ── Custom Colors ───────────────────────────────
        const SectionHeader('Custom Colors & Styling 🆕'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateRangePicker(\n'
          '  primaryColor: Colors.teal,\n'
          '  rangeHighlightColor: Colors.teal.withOpacity(0.15),\n'
          '  weekendColor: Colors.orange,\n'
          '  cellBorderRadius: 20,\n'
          '  highlightWeekends: true,\n'
          ')',
        ),
        const SizedBox(height: 12),

// Teal theme
        _themedPicker(
          title: '🏨 Hotel Booking Theme',
          primaryColor: Colors.teal,
          rangeColor: Colors.teal,
          weekendColor: Colors.orange,
          cellBorderRadius: 20,
          confirmLabel: 'Book Now',
        ),
        const SizedBox(height: 12),

// Purple theme
        _themedPicker(
          title: '💜 Purple Theme',
          primaryColor: Colors.purple,
          rangeColor: Colors.purple,
          weekendColor: Colors.pink,
          cellBorderRadius: 4,
          confirmLabel: 'Apply',
        ),
        const SizedBox(height: 12),

// Red theme
        _themedPicker(
          title: '❤️ Red Theme',
          primaryColor: Colors.red,
          rangeColor: Colors.red,
          weekendColor: Colors.deepOrange,
          cellBorderRadius: 0,
          confirmLabel: 'Select',
        ),
      ],
    );
  }

  Widget _rangeResultCard(SelectedDateRange range, String title) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.indigo.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.date_range, color: Colors.indigo, size: 16),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${range.days} days',
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const Divider(height: 12),
            _infoRow('start', range.start.toReadable),
            _infoRow('end', range.end.toReadable),
            _infoRow('timeAgo (start)', range.start.timeAgo),
            _infoRow('preset', range.preset?.name ?? 'custom'),
            _infoRow('contains today', '${range.contains(DateTime.now())}'),
            _infoRow('toISO (start)', range.start.toISO),
          ],
        ),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 110,
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

  Widget _useCasesCard() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _useCase(
                icon: '📊',
                title: 'Analytics Dashboard',
                code: 'final range = DateRangeHelper.lastNDays(30);\n'
                    'await api.getStats(\n'
                    '  from: range.start,\n'
                    '  to: range.end,\n'
                    ');',
              ),
              const Divider(height: 20),
              _useCase(
                icon: '🛒',
                title: 'Order History Filter',
                code: 'SmartDateRangePicker(\n'
                    '  onRangeSelected: (range) {\n'
                    '    orders.where((o) =>\n'
                    '      range.contains(o.date)\n'
                    '    ).toList();\n'
                    '  },\n'
                    ')',
              ),
              const Divider(height: 20),
              _useCase(
                icon: '🏨',
                title: 'Hotel Booking',
                code: 'SmartDateRangePicker(\n'
                    '  minDate: DateTime.now(),\n'
                    '  primaryColor: Colors.teal,\n'
                    '  confirmLabel: "Book Now",\n'
                    '  onRangeSelected: (range) {\n'
                    '    bookRoom(\n'
                    '      checkIn: range.start,\n'
                    '      checkOut: range.end,\n'
                    '    );\n'
                    '  },\n'
                    ')',
              ),
            ],
          ),
        ),
      );

  Widget _useCase({
    required String icon,
    required String title,
    required String code,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.indigo)),
          ]),
          const SizedBox(height: 8),
          CodeBox(code),
        ],
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

  Widget _themedPicker({
    required String title,
    required Color primaryColor,
    required Color rangeColor,
    required Color weekendColor,
    required double cellBorderRadius,
    required String confirmLabel,
  }) =>
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              SmartDateRangePicker(
                primaryColor: primaryColor,
                rangeColor: rangeColor,
                weekendColor: weekendColor,
                cellBorderRadius: cellBorderRadius,
                highlightWeekends: true,
                confirmLabel: confirmLabel,
                showConfirmButton: false,
                presets: const [
                  DateRangePreset.thisWeek,
                  DateRangePreset.thisMonth,
                  DateRangePreset.last30Days,
                ],
                onRangeSelected: (range) =>
                    setState(() => _customRange = range),
              ),
            ],
          ),
        ),
      );
}
