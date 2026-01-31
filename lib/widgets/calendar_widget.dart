import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final String userName;
  final DateTime focusedDay;
  final ImageProvider? backgroundImage;

  const CalendarWidget({
    super.key,
    required this.userName,
    required this.focusedDay,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: backgroundImage != null
              ? DecorationImage(image: backgroundImage!, fit: BoxFit.cover)
              : null,
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    "${focusedDay.year} - ${focusedDay.month.toString().padLeft(2,'0')}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, color: Colors.black87, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: focusedDay,
                headerVisible: true, // now user can switch months/years
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.lightBlue, shape: BoxShape.circle),
                  defaultTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 14, color: Colors.black54),
                  weekendStyle: TextStyle(fontSize: 14, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
