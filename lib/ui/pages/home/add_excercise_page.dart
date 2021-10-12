import 'package:exon_app/constants/colors.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_text_field.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExcercisePage extends StatelessWidget {
  const AddExcercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    const _headerTitle = '운동 추가하기';
    const _searchFieldLabelText = '운동을 검색해보세요';
    const List<String> _targetMuscleList = [
      '전체',
      '가슴',
      '어깨',
      '팔',
      '복근',
      '허벅지',
      '종아리',
      '엉덩이'
    ];
    const Map<String, int> _targetMuscleStrToInt = {
      '전체': 0,
      '가슴': 1,
      '어깨': 2,
      '팔': 3,
      '복근': 4,
      '허벅지': 5,
      '종아리': 6,
      '엉덩이': 7,
    };
    const List<String> _excerciseMethodList = [
      '전체',
      '머신',
      '덤벨',
      '바벨',
      '케틀벨',
      '케이블',
      '밴드',
    ];
    const Map<String, int> _excerciseMethodStrToInt = {
      '전체': 0,
      '머신': 1,
      '덤벨': 2,
      '바벨': 3,
      '케틀벨': 4,
      '케이블': 5,
      '밴드': 6,
    };
    const Map<int, String> _excerciseLevelIntToStr = {
      0: '난이도 하',
      1: '난이도 중',
      2: '난이도 상',
    };
    const List<List<dynamic>> _excerciseData = [
      ['벤치프레스', 1],
      ['인클라인 벤치프레스', 2],
      ['머신 체스트프레스', 0],
      ['덤벨 체스트프레스', 2],
      ['인클라인 덤벨프레스', 2],
      ['머신 체스트플라이', 0]
    ];
    const double _targetSelectWidth = 340;
    const double _targetMuscleSelectHeight = 50;
    const double _excerciseMethodSelectHeight = 45;
    const double _targetMuscleSelectFontSize = 14;
    const double _excerciseMethodSelectFontSize = 12;

    void _onBackPressed() {
      controller.jumpToPage(0);
    }

    void _onTargetMusclePressed(String target) {
      controller.targetMuscleSelectUpdate(_targetMuscleStrToInt[target] ?? 0);
    }

    void _onExcerciseMethodPressed(String method) {
      controller
          .excerciseMethodSelectUpdate(_excerciseMethodStrToInt[method] ?? 0);
    }

    Widget _header = Header(onPressed: _onBackPressed, title: _headerTitle);

    Widget _excerciseSearchBar = InputTextField(
      label: _searchFieldLabelText,
      controller: controller.searchExcerciseController,
      height: 55,
      borderRadius: 30,
    );

    Widget _targetMuscleSelect = SizedBox(
      width: _targetSelectWidth,
      height: _targetMuscleSelectHeight,
      child: DisableGlowListView(
        padding: const EdgeInsets.only(top: 10),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _targetMuscleList.length * 2 - 1,
              (index) {
                if (index % 2 != 0) {
                  return horizontalSpacer(5);
                } else {
                  return TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () =>
                        _onTargetMusclePressed(_targetMuscleList[(index ~/ 2)]),
                    child: GetBuilder<HomeController>(
                      builder: (_) {
                        return Text(
                          _targetMuscleList[(index ~/ 2)],
                          style: TextStyle(
                            fontSize: _targetMuscleSelectFontSize,
                            color: _.targetMuscle == (index ~/ 2)
                                ? Colors.black
                                : lightBlackColor,
                            fontWeight: _.targetMuscle == (index ~/ 2)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    Widget _excerciseMethodSelect = SizedBox(
      width: _targetSelectWidth,
      height: _excerciseMethodSelectHeight,
      child: DisableGlowListView(
        padding: const EdgeInsets.only(bottom: 2),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _excerciseMethodList.length * 2 - 1,
              (index) {
                if (index % 2 != 0) {
                  return horizontalSpacer(5);
                } else {
                  return GetBuilder<HomeController>(
                    builder: (_) {
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(30, 28),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          side: (index ~/ 2) == _.excerciseMethod
                              ? const BorderSide(
                                  color: deepPrimaryColor,
                                  width: 1.5,
                                )
                              : BorderSide.none,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => _onExcerciseMethodPressed(
                            _excerciseMethodList[(index ~/ 2)]),
                        child: Text(
                          _excerciseMethodList[(index ~/ 2)],
                          style: TextStyle(
                            fontSize: _excerciseMethodSelectFontSize,
                            color: _.excerciseMethod == (index ~/ 2)
                                ? Colors.black
                                : lightBlackColor,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    Widget _excerciseBlock(String name, int level) {
      return SizedBox(
        width: 330,
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 215,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                color: lightPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2,
                    ),
                  ),
                  Text(
                    _excerciseLevelIntToStr[level] ??
                        _excerciseLevelIntToStr[0]!,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 115,
              decoration: const BoxDecoration(
                color: lightGrayColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _excerciseBlockList = Expanded(
      child: DisableGlowListView(
        padding: const EdgeInsets.only(top: 10, bottom: 30),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              _excerciseData.length * 2 - 1,
              (index) {
                if (index % 2 != 0) {
                  return verticalSpacer(15);
                } else {
                  return _excerciseBlock(_excerciseData[index ~/ 2][0],
                      _excerciseData[index ~/ 2][1]);
                }
              },
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        _header,
        verticalSpacer(10),
        _excerciseSearchBar,
        _targetMuscleSelect,
        _excerciseMethodSelect,
        _excerciseBlockList,
      ],
    );
  }
}
