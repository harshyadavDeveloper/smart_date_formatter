import 'package:flutter/material.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDateFormatter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Smart Date Formatter')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTile('Just now',
                DateTime.now().subtract(const Duration(seconds: 3)).timeAgo),
            _buildTile('30 seconds ago',
                DateTime.now().subtract(const Duration(seconds: 30)).timeAgo),
            _buildTile('5 minutes ago',
                DateTime.now().subtract(const Duration(minutes: 5)).timeAgo),
            _buildTile('2 hours ago',
                DateTime.now().subtract(const Duration(hours: 2)).timeAgo),
            _buildTile('Yesterday',
                DateTime.now().subtract(const Duration(days: 1)).timeAgo),
            _buildTile('3 days ago',
                DateTime.now().subtract(const Duration(days: 3)).timeAgo),
            _buildTile('Last week',
                DateTime.now().subtract(const Duration(days: 9)).timeAgo),
            _buildTile('2 months ago',
                DateTime.now().subtract(const Duration(days: 65)).timeAgo),
            _buildTile('Last year',
                DateTime.now().subtract(const Duration(days: 400)).timeAgo),
            const Divider(height: 32),
            _buildTile('Calendar - Today', DateTime.now().calendar),
            _buildTile('Calendar - Yesterday',
                DateTime.now().subtract(const Duration(days: 1)).calendar),
            _buildTile('Calendar - In 3 days',
                DateTime.now().add(const Duration(days: 3)).calendar),
            _buildTile('Calendar - Old date', DateTime(2023, 3, 7).calendar),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value) => ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(value, style: const TextStyle(color: Colors.blue)),
      );
}
