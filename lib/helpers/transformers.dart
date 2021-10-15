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
