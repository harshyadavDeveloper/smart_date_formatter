/// Built-in locale definitions for SmartDateFormatter.
class SdfLocale {
  /// Locale identifier code (e.g. 'en', 'hi', 'es')
  final String code;

  /// Label map containing all time strings for this locale
  final Map<String, String> labels;

  /// Creates a custom [SdfLocale] with given [code] and [labels].
  ///
  /// ```dart
  /// const SdfLocale(
  ///   code: 'my',
  ///   labels: {'justNow': 'just now', ...},
  /// )
  /// ```
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

  /// German
  static const SdfLocale de = SdfLocale(code: 'de', labels: {
    'justNow': 'Gerade eben',
    'secondsAgo': 'Sekunden her',
    'minuteAgo': 'vor 1 Minute',
    'minutesAgo': 'Minuten her',
    'hourAgo': 'vor 1 Stunde',
    'hoursAgo': 'Stunden her',
    'yesterday': 'Gestern',
    'tomorrow': 'Morgen',
    'daysAgo': 'Tage her',
    'inDays': 'in {n} Tagen',
    'lastWeek': 'Letzte Woche',
    'nextWeek': 'Nächste Woche',
    'weeksAgo': 'Wochen her',
    'inWeeks': 'in {n} Wochen',
    'lastMonth': 'Letzten Monat',
    'nextMonth': 'Nächsten Monat',
    'monthsAgo': 'Monate her',
    'inMonths': 'in {n} Monaten',
    'lastYear': 'Letztes Jahr',
    'nextYear': 'Nächstes Jahr',
    'yearsAgo': 'Jahre her',
    'inYears': 'in {n} Jahren',
  });

  /// Russian
  static const SdfLocale ru = SdfLocale(code: 'ru', labels: {
    'justNow': 'Только что',
    'secondsAgo': 'секунд назад',
    'minuteAgo': '1 минуту назад',
    'minutesAgo': 'минут назад',
    'hourAgo': '1 час назад',
    'hoursAgo': 'часов назад',
    'yesterday': 'Вчера',
    'tomorrow': 'Завтра',
    'daysAgo': 'дней назад',
    'inDays': 'через {n} дней',
    'lastWeek': 'На прошлой неделе',
    'nextWeek': 'На следующей неделе',
    'weeksAgo': 'недель назад',
    'inWeeks': 'через {n} недель',
    'lastMonth': 'В прошлом месяце',
    'nextMonth': 'В следующем месяце',
    'monthsAgo': 'месяцев назад',
    'inMonths': 'через {n} месяцев',
    'lastYear': 'В прошлом году',
    'nextYear': 'В следующем году',
    'yearsAgo': 'лет назад',
    'inYears': 'через {n} лет',
  });

  /// Chinese (Simplified)
  static const SdfLocale zh = SdfLocale(code: 'zh', labels: {
    'justNow': '刚刚',
    'secondsAgo': '秒前',
    'minuteAgo': '1分钟前',
    'minutesAgo': '分钟前',
    'hourAgo': '1小时前',
    'hoursAgo': '小时前',
    'yesterday': '昨天',
    'tomorrow': '明天',
    'daysAgo': '天前',
    'inDays': '{n}天后',
    'lastWeek': '上周',
    'nextWeek': '下周',
    'weeksAgo': '周前',
    'inWeeks': '{n}周后',
    'lastMonth': '上个月',
    'nextMonth': '下个月',
    'monthsAgo': '个月前',
    'inMonths': '{n}个月后',
    'lastYear': '去年',
    'nextYear': '明年',
    'yearsAgo': '年前',
    'inYears': '{n}年后',
  });

  /// Marathi
  static const SdfLocale mr = SdfLocale(code: 'mr', labels: {
    'justNow': 'आत्ता',
    'secondsAgo': 'सेकंद पूर्वी',
    'minuteAgo': '1 मिनिट पूर्वी',
    'minutesAgo': 'मिनिटे पूर्वी',
    'hourAgo': '1 तास पूर्वी',
    'hoursAgo': 'तास पूर्वी',
    'yesterday': 'काल',
    'tomorrow': 'उद्या',
    'daysAgo': 'दिवस पूर्वी',
    'inDays': '{n} दिवसांत',
    'lastWeek': 'मागील आठवडा',
    'nextWeek': 'पुढील आठवडा',
    'weeksAgo': 'आठवडे पूर्वी',
    'inWeeks': '{n} आठवड्यांत',
    'lastMonth': 'मागील महिना',
    'nextMonth': 'पुढील महिना',
    'monthsAgo': 'महिने पूर्वी',
    'inMonths': '{n} महिन्यांत',
    'lastYear': 'मागील वर्ष',
    'nextYear': 'पुढील वर्ष',
    'yearsAgo': 'वर्षे पूर्वी',
    'inYears': '{n} वर्षांत',
  });

  /// Gujarati
  static const SdfLocale gu = SdfLocale(code: 'gu', labels: {
    'justNow': 'હમણાં જ',
    'secondsAgo': 'સેકન્ડ પહેલાં',
    'minuteAgo': '1 મિનિટ પહેલાં',
    'minutesAgo': 'મિનિટ પહેલાં',
    'hourAgo': '1 કલાક પહેલાં',
    'hoursAgo': 'કલાક પહેલાં',
    'yesterday': 'ગઈ કાલે',
    'tomorrow': 'આવતી કાલે',
    'daysAgo': 'દિવસ પહેલાં',
    'inDays': '{n} દિવસમાં',
    'lastWeek': 'ગયા અઠવાડિયે',
    'nextWeek': 'આવતા અઠવાડિયે',
    'weeksAgo': 'અઠવાડિયા પહેલાં',
    'inWeeks': '{n} અઠવાડિયામાં',
    'lastMonth': 'ગયા મહિને',
    'nextMonth': 'આવતા મહિને',
    'monthsAgo': 'મહિના પહેલાં',
    'inMonths': '{n} મહિનામાં',
    'lastYear': 'ગયા વર્ષે',
    'nextYear': 'આવતા વર્ષે',
    'yearsAgo': 'વર્ષ પહેલાં',
    'inYears': '{n} વર્ષમાં',
  });

  /// Bengali
  static const SdfLocale bn = SdfLocale(code: 'bn', labels: {
    'justNow': 'এইমাত্র',
    'secondsAgo': 'সেকেন্ড আগে',
    'minuteAgo': '১ মিনিট আগে',
    'minutesAgo': 'মিনিট আগে',
    'hourAgo': '১ ঘন্টা আগে',
    'hoursAgo': 'ঘন্টা আগে',
    'yesterday': 'গতকাল',
    'tomorrow': 'আগামীকাল',
    'daysAgo': 'দিন আগে',
    'inDays': '{n} দিনের মধ্যে',
    'lastWeek': 'গত সপ্তাহ',
    'nextWeek': 'আগামী সপ্তাহ',
    'weeksAgo': 'সপ্তাহ আগে',
    'inWeeks': '{n} সপ্তাহের মধ্যে',
    'lastMonth': 'গত মাস',
    'nextMonth': 'আগামী মাস',
    'monthsAgo': 'মাস আগে',
    'inMonths': '{n} মাসের মধ্যে',
    'lastYear': 'গত বছর',
    'nextYear': 'আগামী বছর',
    'yearsAgo': 'বছর আগে',
    'inYears': '{n} বছরের মধ্যে',
  });

  /// Tamil
  static const SdfLocale ta = SdfLocale(code: 'ta', labels: {
    'justNow': 'இப்போதுதான்',
    'secondsAgo': 'வினாடிகள் முன்பு',
    'minuteAgo': '1 நிமிடம் முன்பு',
    'minutesAgo': 'நிமிடங்கள் முன்பு',
    'hourAgo': '1 மணி நேரம் முன்பு',
    'hoursAgo': 'மணி நேரம் முன்பு',
    'yesterday': 'நேற்று',
    'tomorrow': 'நாளை',
    'daysAgo': 'நாட்கள் முன்பு',
    'inDays': '{n} நாட்களில்',
    'lastWeek': 'கடந்த வாரம்',
    'nextWeek': 'அடுத்த வாரம்',
    'weeksAgo': 'வாரங்கள் முன்பு',
    'inWeeks': '{n} வாரங்களில்',
    'lastMonth': 'கடந்த மாதம்',
    'nextMonth': 'அடுத்த மாதம்',
    'monthsAgo': 'மாதங்கள் முன்பு',
    'inMonths': '{n} மாதங்களில்',
    'lastYear': 'கடந்த ஆண்டு',
    'nextYear': 'அடுத்த ஆண்டு',
    'yearsAgo': 'ஆண்டுகள் முன்பு',
    'inYears': '{n} ஆண்டுகளில்',
  });

  /// Telugu
  static const SdfLocale te = SdfLocale(code: 'te', labels: {
    'justNow': 'ఇప్పుడే',
    'secondsAgo': 'సెకన్లు క్రితం',
    'minuteAgo': '1 నిమిషం క్రితం',
    'minutesAgo': 'నిమిషాలు క్రితం',
    'hourAgo': '1 గంట క్రితం',
    'hoursAgo': 'గంటలు క్రితం',
    'yesterday': 'నిన్న',
    'tomorrow': 'రేపు',
    'daysAgo': 'రోజులు క్రితం',
    'inDays': '{n} రోజుల్లో',
    'lastWeek': 'గత వారం',
    'nextWeek': 'వచ్చే వారం',
    'weeksAgo': 'వారాలు క్రితం',
    'inWeeks': '{n} వారాల్లో',
    'lastMonth': 'గత నెల',
    'nextMonth': 'వచ్చే నెల',
    'monthsAgo': 'నెలలు క్రితం',
    'inMonths': '{n} నెలల్లో',
    'lastYear': 'గత సంవత్సరం',
    'nextYear': 'వచ్చే సంవత్సరం',
    'yearsAgo': 'సంవత్సరాలు క్రితం',
    'inYears': '{n} సంవత్సరాల్లో',
  });

  /// Kannada
  static const SdfLocale kn = SdfLocale(code: 'kn', labels: {
    'justNow': 'ಈಗಷ್ಟೇ',
    'secondsAgo': 'ಸೆಕೆಂಡುಗಳ ಹಿಂದೆ',
    'minuteAgo': '1 ನಿಮಿಷದ ಹಿಂದೆ',
    'minutesAgo': 'ನಿಮಿಷಗಳ ಹಿಂದೆ',
    'hourAgo': '1 ಗಂಟೆ ಹಿಂದೆ',
    'hoursAgo': 'ಗಂಟೆಗಳ ಹಿಂದೆ',
    'yesterday': 'ನಿನ್ನೆ',
    'tomorrow': 'ನಾಳೆ',
    'daysAgo': 'ದಿನಗಳ ಹಿಂದೆ',
    'inDays': '{n} ದಿನಗಳಲ್ಲಿ',
    'lastWeek': 'ಕಳೆದ ವಾರ',
    'nextWeek': 'ಮುಂದಿನ ವಾರ',
    'weeksAgo': 'ವಾರಗಳ ಹಿಂದೆ',
    'inWeeks': '{n} ವಾರಗಳಲ್ಲಿ',
    'lastMonth': 'ಕಳೆದ ತಿಂಗಳು',
    'nextMonth': 'ಮುಂದಿನ ತಿಂಗಳು',
    'monthsAgo': 'ತಿಂಗಳುಗಳ ಹಿಂದೆ',
    'inMonths': '{n} ತಿಂಗಳುಗಳಲ್ಲಿ',
    'lastYear': 'ಕಳೆದ ವರ್ಷ',
    'nextYear': 'ಮುಂದಿನ ವರ್ಷ',
    'yearsAgo': 'ವರ್ಷಗಳ ಹಿಂದೆ',
    'inYears': '{n} ವರ್ಷಗಳಲ್ಲಿ',
  });

  /// Punjabi
  static const SdfLocale pa = SdfLocale(code: 'pa', labels: {
    'justNow': 'ਹੁਣੇ',
    'secondsAgo': 'ਸਕਿੰਟ ਪਹਿਲਾਂ',
    'minuteAgo': '1 ਮਿੰਟ ਪਹਿਲਾਂ',
    'minutesAgo': 'ਮਿੰਟ ਪਹਿਲਾਂ',
    'hourAgo': '1 ਘੰਟਾ ਪਹਿਲਾਂ',
    'hoursAgo': 'ਘੰਟੇ ਪਹਿਲਾਂ',
    'yesterday': 'ਕੱਲ੍ਹ',
    'tomorrow': 'ਕੱਲ੍ਹ',
    'daysAgo': 'ਦਿਨ ਪਹਿਲਾਂ',
    'inDays': '{n} ਦਿਨਾਂ ਵਿੱਚ',
    'lastWeek': 'ਪਿਛਲੇ ਹਫ਼ਤੇ',
    'nextWeek': 'ਅਗਲੇ ਹਫ਼ਤੇ',
    'weeksAgo': 'ਹਫ਼ਤੇ ਪਹਿਲਾਂ',
    'inWeeks': '{n} ਹਫ਼ਤਿਆਂ ਵਿੱਚ',
    'lastMonth': 'ਪਿਛਲੇ ਮਹੀਨੇ',
    'nextMonth': 'ਅਗਲੇ ਮਹੀਨੇ',
    'monthsAgo': 'ਮਹੀਨੇ ਪਹਿਲਾਂ',
    'inMonths': '{n} ਮਹੀਨਿਆਂ ਵਿੱਚ',
    'lastYear': 'ਪਿਛਲੇ ਸਾਲ',
    'nextYear': 'ਅਗਲੇ ਸਾਲ',
    'yearsAgo': 'ਸਾਲ ਪਹਿਲਾਂ',
    'inYears': '{n} ਸਾਲਾਂ ਵਿੱਚ',
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
      case 'de':
        return de;
      case 'ru':
        return ru;
      case 'zh':
        return zh;
      case 'mr':
        return mr;
      case 'gu':
        return gu;
      case 'bn':
        return bn;
      case 'ta':
        return ta;
      case 'te':
        return te;
      case 'kn':
        return kn;
      case 'pa':
        return pa;
      default:
        return en;
    }
  }

  /// All available locale codes
  static const List<String> supported = [
    'en',
    'hi',
    'es',
    'fr',
    'ja',
    'ar',
    'de',
    'ru',
    'zh',
    'mr',
    'gu',
    'bn',
    'ta',
    'te',
    'kn',
    'pa',
  ];
}
