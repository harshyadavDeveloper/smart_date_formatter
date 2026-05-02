/// Built-in locale definitions for SmartDateFormatter.
class SdfLocale {
  final String code;
  final Map<String, String> labels;

  const SdfLocale({required this.code, required this.labels});

  /// English (default)
  static const SdfLocale en = SdfLocale(code: 'en', labels: {
    'justNow': 'Just now',
    'secondsAgo': 'seconds ago',
    'minuteAgo': '1 minute ago',
    'minutesAgo': 'minutes ago',
    'hourAgo': '1 hour ago',
    'hoursAgo': 'hours ago',
    'yesterday': 'Yesterday',
    'tomorrow': 'Tomorrow',
    'daysAgo': 'days ago',
    'inDays': 'in {n} days',
    'lastWeek': 'Last week',
    'nextWeek': 'Next week',
    'weeksAgo': 'weeks ago',
    'inWeeks': 'in {n} weeks',
    'lastMonth': 'Last month',
    'nextMonth': 'Next month',
    'monthsAgo': 'months ago',
    'inMonths': 'in {n} months',
    'lastYear': 'Last year',
    'nextYear': 'Next year',
    'yearsAgo': 'years ago',
    'inYears': 'in {n} years',
  });

  /// Hindi
  static const SdfLocale hi = SdfLocale(code: 'hi', labels: {
    'justNow': 'अभी',
    'secondsAgo': 'सेकंड पहले',
    'minuteAgo': '1 मिनट पहले',
    'minutesAgo': 'मिनट पहले',
    'hourAgo': '1 घंटा पहले',
    'hoursAgo': 'घंटे पहले',
    'yesterday': 'कल',
    'tomorrow': 'आने वाला कल',
    'daysAgo': 'दिन पहले',
    'inDays': '{n} दिनों में',
    'lastWeek': 'पिछले हफ्ते',
    'nextWeek': 'अगले हफ्ते',
    'weeksAgo': 'हफ्ते पहले',
    'inWeeks': '{n} हफ्तों में',
    'lastMonth': 'पिछले महीने',
    'nextMonth': 'अगले महीने',
    'monthsAgo': 'महीने पहले',
    'inMonths': '{n} महीनों में',
    'lastYear': 'पिछले साल',
    'nextYear': 'अगले साल',
    'yearsAgo': 'साल पहले',
    'inYears': '{n} सालों में',
  });

  /// Spanish
  static const SdfLocale es = SdfLocale(code: 'es', labels: {
    'justNow': 'Justo ahora',
    'secondsAgo': 'segundos atrás',
    'minuteAgo': 'hace 1 minuto',
    'minutesAgo': 'minutos atrás',
    'hourAgo': 'hace 1 hora',
    'hoursAgo': 'horas atrás',
    'yesterday': 'Ayer',
    'tomorrow': 'Mañana',
    'daysAgo': 'días atrás',
    'inDays': 'en {n} días',
    'lastWeek': 'La semana pasada',
    'nextWeek': 'La próxima semana',
    'weeksAgo': 'semanas atrás',
    'inWeeks': 'en {n} semanas',
    'lastMonth': 'El mes pasado',
    'nextMonth': 'El próximo mes',
    'monthsAgo': 'meses atrás',
    'inMonths': 'en {n} meses',
    'lastYear': 'El año pasado',
    'nextYear': 'El próximo año',
    'yearsAgo': 'años atrás',
    'inYears': 'en {n} años',
  });

  /// French
  static const SdfLocale fr = SdfLocale(code: 'fr', labels: {
    'justNow': 'À l\'instant',
    'secondsAgo': 'secondes',
    'minuteAgo': 'il y a 1 minute',
    'minutesAgo': 'minutes',
    'hourAgo': 'il y a 1 heure',
    'hoursAgo': 'heures',
    'yesterday': 'Hier',
    'tomorrow': 'Demain',
    'daysAgo': 'jours',
    'inDays': 'dans {n} jours',
    'lastWeek': 'La semaine dernière',
    'nextWeek': 'La semaine prochaine',
    'weeksAgo': 'semaines',
    'inWeeks': 'dans {n} semaines',
    'lastMonth': 'Le mois dernier',
    'nextMonth': 'Le mois prochain',
    'monthsAgo': 'mois',
    'inMonths': 'dans {n} mois',
    'lastYear': 'L\'année dernière',
    'nextYear': 'L\'année prochaine',
    'yearsAgo': 'ans',
    'inYears': 'dans {n} ans',
  });

  /// Japanese
  static const SdfLocale ja = SdfLocale(code: 'ja', labels: {
    'justNow': 'たった今',
    'secondsAgo': '秒前',
    'minuteAgo': '1分前',
    'minutesAgo': '分前',
    'hourAgo': '1時間前',
    'hoursAgo': '時間前',
    'yesterday': '昨日',
    'tomorrow': '明日',
    'daysAgo': '日前',
    'inDays': '{n}日後',
    'lastWeek': '先週',
    'nextWeek': '来週',
    'weeksAgo': '週間前',
    'inWeeks': '{n}週間後',
    'lastMonth': '先月',
    'nextMonth': '来月',
    'monthsAgo': 'ヶ月前',
    'inMonths': '{n}ヶ月後',
    'lastYear': '去年',
    'nextYear': '来年',
    'yearsAgo': '年前',
    'inYears': '{n}年後',
  });

  /// Arabic
  static const SdfLocale ar = SdfLocale(code: 'ar', labels: {
    'justNow': 'الآن',
    'secondsAgo': 'ثانية مضت',
    'minuteAgo': 'منذ دقيقة',
    'minutesAgo': 'دقائق مضت',
    'hourAgo': 'منذ ساعة',
    'hoursAgo': 'ساعات مضت',
    'yesterday': 'أمس',
    'tomorrow': 'غداً',
    'daysAgo': 'أيام مضت',
    'inDays': 'في {n} أيام',
    'lastWeek': 'الأسبوع الماضي',
    'nextWeek': 'الأسبوع القادم',
    'weeksAgo': 'أسابيع مضت',
    'inWeeks': 'في {n} أسابيع',
    'lastMonth': 'الشهر الماضي',
    'nextMonth': 'الشهر القادم',
    'monthsAgo': 'أشهر مضت',
    'inMonths': 'في {n} أشهر',
    'lastYear': 'العام الماضي',
    'nextYear': 'العام القادم',
    'yearsAgo': 'سنوات مضت',
    'inYears': 'في {n} سنوات',
  });

  /// Get locale by code string
  /// ```dart
  /// SdfLocale.fromCode('hi') // Hindi
  /// SdfLocale.fromCode('es') // Spanish
  /// ```
  static SdfLocale fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'hi':
        return hi;
      case 'es':
        return es;
      case 'fr':
        return fr;
      case 'ja':
        return ja;
      case 'ar':
        return ar;
      default:
        return en;
    }
  }

  /// All available locale codes
  static const List<String> supported = ['en', 'hi', 'es', 'fr', 'ja', 'ar'];
}
