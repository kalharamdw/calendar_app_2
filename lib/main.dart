import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CalendarDesignerApp());
}

class CalendarDesignerApp extends StatelessWidget {
  const CalendarDesignerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Calendar Designer',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
