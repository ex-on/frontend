bool compareSameDate(DateTime dateTime1, DateTime dateTime2) {
  return (dateTime1.year == dateTime2.year) &&
      (dateTime1.month == dateTime2.month) &&
      (dateTime1.day == dateTime2.day);
}

DateTime dateTimeToDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

int getOtherExerciseType(int type) {
  if (type == 0) {
    return 1;
  } else {
    return 0;
  }
}

extension DateTimeExtension on DateTime {
  int get firstWeekdayOfMonth {
    var date = this;
    return DateTime(date.year, date.month, 1).weekday;
  }

  int get weekOfMonth {
    var date = this;
    var wom = ((date.day + date.firstWeekdayOfMonth - 1) / 7).ceil();
    return wom;
  }

  DateTime get firstDateOfWeek {
    var date = this;
    return date.subtract(Duration(days: date.weekday - 1));
  }
  DateTime get lastDateOfWeek {
    var date = this;
    return date.add(Duration(days: 7 - date.weekday));
  }

  DateTime get lastDateOfMonth {
    var date = this;
    return DateTime(date.year, date.month + 1, 0);
  }

  int get numWeeksInMonth {
    var date = this;
    return date.lastDateOfMonth.weekOfMonth;
  }
}
