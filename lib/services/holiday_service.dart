class Holiday {
  final int day;
  final int month;
  final String name;

  Holiday(this.day, this.month, this.name);
}

class HolidayService {
  static List<Holiday> holidays = [
    Holiday(1, 1, "New Year"),
    Holiday(14, 4, "Sinhala & Tamil New Year"),
    Holiday(25, 12, "Christmas"),
  ];
}
