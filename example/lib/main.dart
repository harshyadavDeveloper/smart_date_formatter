import 'package:flutter/material.dart';
import 'tabs/time_ago_tab.dart';
import 'tabs/calendar_tab.dart';
import 'tabs/format_tab.dart';
import 'tabs/calculate_tab.dart';
import 'tabs/locale_tab.dart';
import 'tabs/parser_tab.dart';
import 'tabs/widgets_tab.dart';
import 'tabs/ranges_tab.dart';

void main() => runApp(const ExampleApp());

/// Root app for smart_date_formatter example.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDateFormatter Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
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
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'smart_date_formatter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'v1.2.1 — Full Example',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
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
          ],
        ),
      ),
    );
  }
}
