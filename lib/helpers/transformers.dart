import 'package:exon_app/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const Map<int, String> exerciseTypeEnumToStr = {
  0: '근력',
  1: '유산소',
};

const Map<String, int> targetMuscleStrToInt = {
  '전체': 0,
  '가슴': 1,
  '등': 2,
  '어깨': 3,
  '팔': 4,
  '복근': 5,
  '하체': 6,
  '엉덩이': 7,
};

const Map<int, String> targetMuscleIntToStr = {
  0: '전체',
  1: '가슴',
  2: '등',
  3: '어깨',
  4: '팔',
  5: '복근',
  6: '하체',
  7: '엉덩이',
};

const Map<int, Color> targetMuscleIntToColor = {
  1: chestMuscleColor,
  2: backMuscleColor,
  3: shoulderMuscleColor,
  4: armMuscleColor,
  5: absMuscleColor,
  6: legMuscleColor,
  7: hipMuscleColor,
};

const Map<String, int> exerciseMethodStrToInt = {
  '전체': 0,
  '맨몸': 1,
  '머신': 2,
  '스미스머신': 3,
  '덤벨': 4,
  '바벨': 5,
  '트랩바': 6,
  '케틀벨': 7,
  '플레이트': 8,
  '케이블': 9,
  '밴드': 10,
  '기타': 11,
};

const Map<int, String> exerciseMethodIntToStr = {
  0: '전체',
  1: '맨몸',
  2: '머신',
  3: '스미스머신',
  4: '덤벨',
  5: '바벨',
  6: '트랩바',
  7: '케틀벨',
  8: '플레이트',
  9: '케이블',
  10: '밴드',
  11: '기타',
};

const Map<int, String> cardioMethodIntToStr = {
  0: '전체',
  1: '맨몸',
  2: '머신',
  3: '기타',
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

String formatDateTimeRawString(String rawString) {
  print(rawString);
  DateTime dt = DateTime.parse(rawString);
  print(dt);
  return DateFormat('MM/dd kk:mm').format(dt);
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

Map<int, String> weekdayIntToStr = {
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

String formatMMSS(int seconds) {
  int minutes = (seconds / 60).truncate();
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');
  return "$minutesStr : $secondsStr";
}

String formatTimeToText(int seconds) {
  int hours = (seconds / 3600).truncate();
  int sec = (seconds % 3600).truncate();
  int minutes = (sec / 60).truncate();
  sec = sec % 60;

  if (seconds >= 3600) {
    if (minutes == 0) {
      return "$hours시간";
    }
    return "$hours시간 $minutes분";
  } else if (seconds < 60) {
    return "$sec초";
  } else {
    if (sec == 0) {
      return "$minutes분";
    }
    return "$minutes분 $sec초";
  }
}

List<int> splitHMS(int seconds) {
  int hours = (seconds / 3600).truncate();
  int sec = (seconds % 3600).truncate();
  int minutes = (sec / 60).truncate();
  sec = sec % 60;

  return [hours, minutes, sec];
}

Map<int, String> postCategoryIntToStr = {
  0: 'HOT',
  1: '자유',
  2: '정보',
};

Map<int, String> qnaCategoryIntToStr = {
  0: 'HOT',
  1: '미해결',
  2: '해결',
};

int getLevelRequiredProtein(int level) {
  switch (level) {
    case 1:
      return 100;
    case 2:
      return 1000;
    case 3:
      return 10000;
    case 4:
      return 50000;
    case 5:
      return 100000;
    case 6:
      return 200000;
    default:
      return 0;
  }
}

Map<int, String> activityLevelIntToStr = {
  0: '말랑말랑 인간',
  1: '헬스세포',
  2: '헬린이',
  3: '말하는 닭가슴살',
  4: '근성장 교과서',
  5: '걸어다니는 헬스장',
  6: '근손실 방지 위원회',
};

Map<int, String> monthlyStatsCategoryIntToStr = {
  0: '운동 일수',
  1: '평균 운동 시간',
  2: '평균 운동 볼륨',
  3: '최고 1RM',
  4: '총 주행 거리',
};
Map<int, String> monthlyStatsCategoryIntToStrEng = {
  0: 'exercise_days',
  1: 'avg_exercise_time',
  2: 'avg_exercise_volume',
  3: 'max_one_rm',
  4: 'total_distance',
};

Map<int, String> physicalStatsCategoryIntToStr = {
  0: '몸무게',
  1: '골격근량',
  2: '체지방률',
  3: 'BMI',
  4: '인바디점수',
};

Map<int, String> physicalStatsCategoryIntToStrEng = {
  0: 'weight',
  1: 'muscle_mass',
  2: 'body_fat_percentage',
  3: 'bmi',
  4: 'inbody_score',
};

String getPhysicalStatsUnit(int category) {
  late String unit;

  switch (category) {
    case 2:
      unit = '%';
      break;
    case 3:
      unit = '';
      break;
    case 4:
      unit = '점';
      break;
    default:
      unit = 'kg';
      break;
  }
  return unit;
}

Map<int, Color> profileExerciseStatusIntToColor = {
  1: brightPrimaryColor.withOpacity(0.1),
  2: brightPrimaryColor.withOpacity(0.37),
  3: brightPrimaryColor,
};
