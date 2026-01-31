import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/holiday_service.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final holidays = HolidayService.holidays;

    return TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: DateTime.now(),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, _) {
          for (var h in holidays) {
            if (date.day == h.day && date.month == h.month) {
              return const Icon(Icons.circle, size: 6, color: Colors.red);
            }
          }
          return null;
        },
      ),
    );
  }
}
