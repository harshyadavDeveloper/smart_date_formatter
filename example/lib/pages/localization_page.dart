import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/demo_section.dart';
import '../widgets/demo_code_box.dart';
import '../widgets/demo_badge.dart';

/// Demonstrates 16 language localization.
class LocalizationPage extends StatelessWidget {
  const LocalizationPage({super.key});

  static const _locales = [
    (SdfLocale.en, '🇬🇧', 'English'),
    (SdfLocale.hi, '🇮🇳', 'Hindi'),
    (SdfLocale.mr, '🇮🇳', 'Marathi'),
    (SdfLocale.gu, '🇮🇳', 'Gujarati'),
    (SdfLocale.bn, '🇮🇳', 'Bengali'),
    (SdfLocale.ta, '🇮🇳', 'Tamil'),
    (SdfLocale.te, '🇮🇳', 'Telugu'),
    (SdfLocale.kn, '🇮🇳', 'Kannada'),
    (SdfLocale.pa, '🇮🇳', 'Punjabi'),
    (SdfLocale.es, '🇪🇸', 'Spanish'),
    (SdfLocale.fr, '🇫🇷', 'French'),
    (SdfLocale.de, '🇩🇪', 'German'),
    (SdfLocale.ru, '🇷🇺', 'Russian'),
    (SdfLocale.zh, '🇨🇳', 'Chinese'),
    (SdfLocale.ja, '🇯🇵', 'Japanese'),
    (SdfLocale.ar, '🇸🇦', 'Arabic'),
  ];

  @override
  Widget build(BuildContext context) {
    final date2h = DateTime.now().subtract(const Duration(hours: 2));
    final date1d = DateTime.now().subtract(const Duration(days: 1));
    final date1w = DateTime.now().subtract(const Duration(days: 8));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DemoSection('16 Languages',
            subtitle: 'SdfLocale.supported: ${SdfLocale.supported.join(', ')}'),
        const SizedBox(height: 8),
        const DemoCodeBox(
          'SmartDateFormatter(locale: SdfLocale.hi).format(date)\n'
          "date.timeAgoIn(SdfLocale.mr) // 'तास पूर्वी'\n"
          "SdfLocale.fromCode('bn')     // Bengali",
        ),
        const SizedBox(height: 12),
        ..._locales.map((l) {
          final fmt = SmartDateFormatter(locale: l.$1);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(l.$2, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(l.$3,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.indigo)),
                    const Spacer(),
                    DemoBadge(l.$1.code),
                  ]),
                  const Divider(height: 14),
                  _row('2h ago', fmt.format(date2h)),
                  _row('Yesterday', fmt.format(date1d)),
                  _row('Last week', fmt.format(date1w)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
