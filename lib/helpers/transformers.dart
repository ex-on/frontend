import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const Map<String, int> targetMuscleStrToInt = {
  '전체': 0,
  '가슴': 1,
  '어깨': 2,
  '팔': 3,
  '복근': 4,
  '허벅지': 5,
  '종아리': 6,
  '엉덩이': 7,
};

const Map<int, String> targetMuscleIntToStr = {
  0: '전체',
  1: '가슴',
  2: '어깨',
  3: '팔',
  4: '복근',
  5: '허벅지',
  6: '종아리',
  7: '엉덩이',
};

const Map<String, int> excerciseMethodStrToInt = {
  '전체': 0,
  '머신': 1,
  '덤벨': 2,
  '바벨': 3,
  '케틀벨': 4,
  '케이블': 5,
  '밴드': 6,
};

const Map<int, String> excerciseMethodIntToStr = {
  0: '전체',
  1: '머신',
  2: '덤벨',
  3: '바벨',
  4: '케틀벨',
  5: '케이블',
  6: '밴드',
};

const Map<int, String> excerciseLevelIntToStr = {
  0: '난이도 하',
  1: '난이도 중',
  2: '난이도 상',
};

const Map<int, String> difficultyIntToString = {
  0: '하급',
  1: '중급',
  2: '상급',
};

String dateTimeToDisplayString(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  } else {
    List<String> yMd = DateFormat('yMd').format(dateTime).split('/');
    String year = yMd[2];
    String month = yMd[0];
    String date = yMd[1];
    return '$year년 $month월 $date일';
  }
}

enum Gender { male, female }

Map<Gender, String> genderToString = {
  Gender.male: '남성',
  Gender.female: '여성',
};

Map<Gender, int> genderToInt = {
  Gender.male: 0,
  Gender.female: 1,
};

Map<String, Color> activityRankToColor = {
  '초수': const Color(0xffD1DBFC),
};

Map<String, Color> physicalRankToColor = {
  '헬스꼬마': const Color(0xff1A49EE),
};

String durationToString(Duration time) {
  List<String> splitDuration = time.toString().split(':');
  if (time.inHours == 0) {
    return splitDuration[1] + '분';
  } else {
    return splitDuration[0] + '시간' + splitDuration[1] + '분';
  }
}

enum ColorTheme { day, night }

Map<String, int> weekDayStrToInt = {
  '월': 1,
  '화': 2,
  '수': 3,
  '목': 4,
  '금': 5,
  '토': 6,
  '일': 7,
};

Map<int, String> weekDayIntToStr = {
  1: '월',
  2: '화',
  3: '수',
  4: '목',
  5: '금',
  6: '토',
  7: '일',
};

Map<String, int> exerciseNameToId = {
  '벤치프레스': 1,
};

Map<int, String> exerciseIdToName = {
  1: '벤치프레스',
};

String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  return "$hoursStr : $minutesStr : $secondsStr";
}

String formatMSS(int seconds) {
  int minutes = (seconds / 60).truncate();
  String minutesStr = (minutes).toString();
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');
  return "$minutesStr:$secondsStr";
}

Map<int, String> postCategoryIntToStr = {
  0: '전체',
  1: 'HOT',
  2: '자유',
  3: '정보',
  4: '운동인증'
};
