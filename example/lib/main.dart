import 'package:flutter/material.dart';
import 'pages/time_ago_page.dart';
import 'pages/calendar_page.dart';
import 'pages/format_page.dart';
import 'pages/calculations_page.dart';
import 'pages/localization_page.dart';
import 'pages/parser_page.dart';
import 'pages/widgets_page.dart';
import 'pages/ranges_page.dart';
import 'pages/analytics_page.dart';

void main() => runApp(const SmartDateDemoApp());

/// Root app for smart_date_formatter interactive playground.
class SmartDateDemoApp extends StatelessWidget {
  const SmartDateDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smart_date_formatter Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PlaygroundHome(),
    );
  }
}

/// Main playground with all feature tabs.
class PlaygroundHome extends StatelessWidget {
  const PlaygroundHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
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
              Text('Interactive Playground v1.5.0',
                  style:
                      TextStyle(fontSize: 11, color: Colors.white70)),
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
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TimeAgoPage(),
            CalendarPage(),
            FormatPage(),
            CalculationsPage(),
            LocalizationPage(),
            ParserPage(),
            WidgetsPage(),
            RangesPage(),
            AnalyticsPage(),
          ],
        ),
      ),
    );
  }
}