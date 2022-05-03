import 'package:intl/intl.dart';

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

String formatNumberFromInt(int number) {
  var f = NumberFormat("###,###", "en_US");
  return f.format(number);
}

String formatNumberFromDouble(double number) {
  var f = NumberFormat("###,###.#", "en_US");
  return f.format(number);
}

String formatNumberFromStr(String number) {
  var f = NumberFormat("###,###", "en_US");
  return f.format(int.parse(number));
}

String getCleanTextFromDouble(num val) {
  if (val % 1 != 0) {
    return formatNumberFromDouble(val.toDouble());
  } else {
    return formatNumberFromInt(val.toInt());
  }
}

extension BoolParsing on String {
  bool get parseBool {
    var string = this;
    return string.toLowerCase() == 'true';
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

  DateTime get firstDateOfMonth {
    var date = this;
    return DateTime(date.year, date.month, 1);
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

bool hasBottomConsonant(String input) {
  if (isKorean(input)) {
    if (((input.runes.last - 0xAC00) / (28 * 21)) < 0
        ? false
        : (((input.runes.last - 0xAC00) % 28 != 0) ? true : false)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

bool isKorean(String input) {
  bool isKorean = false;
  int inputToUniCode = input.codeUnits[0];

  isKorean = (inputToUniCode >= 12593 && inputToUniCode <= 12643)
      ? true
      : (inputToUniCode >= 44032 && inputToUniCode <= 55203)
          ? true
          : false;

  return isKorean;
}
