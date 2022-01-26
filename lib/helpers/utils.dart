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
