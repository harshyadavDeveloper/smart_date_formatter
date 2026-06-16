import 'package:flutter/material.dart';
import 'tabs/time_ago_tab.dart';
import 'tabs/calendar_tab.dart';
import 'tabs/format_tab.dart';
import 'tabs/calculate_tab.dart';
import 'tabs/locale_tab.dart';
import 'tabs/parser_tab.dart';
import 'tabs/widgets_tab.dart';
import 'tabs/ranges_tab.dart';
import 'tabs/analytics_tab.dart';
import 'tabs/calendar_widget_tab.dart';
import 'tabs/date_field_tab.dart'; // 👈 new

void main() => runApp(const ExampleApp());

/// Root app for smart_date_formatter example.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDateFormatter Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ExampleHomePage(),
    );
  }
}

/// Home page with tabbed navigation showing all features.
class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 11, // 👈 10 → 11
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('smart_date_formatter',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text('v2.2.0 — Full Example',
                  style: TextStyle(
                      fontSize: 11, color: Colors.white70)),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: '⏱ timeAgo'),
              Tab(text: '📅 Calendar'),
              Tab(text: '🎨 Format'),
              Tab(text: '🧮 Calculate'),
              Tab(text: '🌍 Locale'),
              Tab(text: '🔍 Parser'),
              Tab(text: '⏳ Widgets'),
              Tab(text: '🗄 Ranges'),
              Tab(text: '📊 Analytics'),
              Tab(text: '🗓 SmartCalendar'),
              Tab(text: '📝 DateField'), // 👈 new
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TimeAgoTab(),
            CalendarTab(),
            FormatTab(),
            CalculateTab(),
            LocaleTab(),
            ParserTab(),
            WidgetsTab(),
            RangesTab(),
            AnalyticsTab(),
            CalendarWidgetTab(),
            DateFieldTab(),
          ],
        ),
      ),
    );
  }
}