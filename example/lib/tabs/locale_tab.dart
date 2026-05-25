import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';
import '../widgets/code_box.dart';
import '../widgets/section_header.dart';

/// Demonstrates multi-language localization.
class LocaleTab extends StatelessWidget {
  const LocaleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final date2h = DateTime.now().subtract(const Duration(hours: 2));
    final date1d = DateTime.now().subtract(const Duration(days: 1));
    final date1w = DateTime.now().subtract(const Duration(days: 8));

    const locales = [
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader('16 Languages — Multi-Language Support'),
        const SizedBox(height: 8),
        const CodeBox(
          'SmartDateFormatter(locale: SdfLocale.hi).format(date)\n'
          "date.timeAgoIn(SdfLocale.mr) // 'तास पूर्वी'\n"
          "SdfLocale.fromCode('bn')     // Bengali",
        ),
        const SizedBox(height: 12),
        ...locales.map((l) {
          final fmt = SmartDateFormatter(locale: l.$1);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(l.$2, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        l.$3,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.indigo,
                        ),
                      ),
                      const Spacer(),
                      _badge(l.$1.code),
                    ],
                  ),
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
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _badge(String code) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.indigo.shade50,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      code,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.indigo,
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
