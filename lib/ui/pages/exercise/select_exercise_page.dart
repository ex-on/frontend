import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/enums.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/transformers.dart';

class SelectExercisePage extends GetView<AddExerciseController> {
  const SelectExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _headerTitle = ' 운동 추가하기';
    const _searchFieldLabelText = '';
    const List<String> _targetMuscleList = [
      '전체',
      '가슴',
      '등',
      '어깨',
      '팔',
      '복근',
      '하체',
      '엉덩이'
    ];

    const List<String> _exerciseMethodList = [
      '전체',
      '맨몸',
      '머신',
      '스미스머신',
      '덤벨',
      '바벨',
      '트랩바',
      '케틀벨',
      '플레이트',
      '케이블',
      '밴드',
      '기타',
    ];

    const List<String> _cardioMethodList = [
      '전체',
      '맨몸',
      '머신',
      '기타',
    ];

    const double _targetSelectWidth = 340;
    const double _targetMuscleSelectHeight = 50;
    const double _excerciseMethodSelectHeight = 45;
    const double _targetMuscleSelectFontSize = 14;
    const double _exerciseMethodSelectFontSize = 12;

    const Color _searchIconColor = Color(0xffC6C6C6);

    Future.delayed(Duration.zero, () async {
      await controller.getExerciseList();
      controller.updateCurrentExerciseDataList();
    });

    void _onBackPressed() {
      Get.back();
      controller.resetExerciseSelect();
    }

    void _onTargetMusclePressed(String target) {
      controller.targetMuscleSelectUpdate(targetMuscleStrToInt[target] ?? 0);
    }

    void _onExerciseMethodPressed(String method) {
      controller
          .exerciseMethodSelectUpdate(exerciseMethodStrToInt[method] ?? 0);
    }

    void _onAerobicMethodPressed(int target) {
      controller.exerciseMethodSelectUpdate(target);
    }

    void _onExerciseBlockPressed(int index) {
      controller.updateSelectedExercise(index);
      controller.jumpToPage(1);
    }

    void _onExerciseTypeChangePressed() {
      controller.changeExerciseType();
    }

    Widget _header = GetBuilder<AddExerciseController>(
      builder: (_) => Header(
        onPressed: _onBackPressed,
        title: exerciseTypeEnumToStr[_.exerciseType]! + _headerTitle,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextActionButton(
              buttonText:
                  exerciseTypeEnumToStr[getOtherExerciseType(_.exerciseType)]!,
              onPressed: _onExerciseTypeChangePressed,
              isUnderlined: false,
              textColor: brightPrimaryColor,
            ),
          )
        ],
      ),
    );

    Widget _exerciseSearchBar = InputTextField(
      label: _searchFieldLabelText,
      controller: controller.searchExerciseController,
      height: 40,
      borderRadius: 10,
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.search_rounded,
        size: 24,
        color: _searchIconColor,
      ),
      autofocus: false,
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
                  return GetBuilder<AddExerciseController>(
                    builder: (_) {
                      if (_.targetMuscle == (index ~/ 2)) {
                        return ElevatedButton(
                          onPressed: () => _onTargetMusclePressed(
                              _targetMuscleList[(index ~/ 2)]),
                          style: ElevatedButton.styleFrom(
                            primary: darkSecondaryColor.withOpacity(0.35),
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _targetMuscleList[(index ~/ 2)],
                            style: const TextStyle(
                              fontSize: _targetMuscleSelectFontSize,
                              color: lightBlackColor,
                            ),
                          ),
                        );
                      } else {
                        return TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _onTargetMusclePressed(
                              _targetMuscleList[(index ~/ 2)]),
                          child: Text(
                            _targetMuscleList[(index ~/ 2)],
                            style: const TextStyle(
                              fontSize: _targetMuscleSelectFontSize,
                              color: clearBlackColor,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    Widget _exerciseMethodSelect = SizedBox(
      width: _targetSelectWidth,
      height: _excerciseMethodSelectHeight,
      child: DisableGlowListView(
        padding: const EdgeInsets.only(bottom: 2),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _exerciseMethodList.length * 2 - 1,
              (index) {
                if (index % 2 != 0) {
                  return horizontalSpacer(5);
                } else {
                  return GetBuilder<AddExerciseController>(
                    builder: (_) {
                      if (_.exerciseMethod == (index ~/ 2)) {
                        return ElevatedButton(
                          onPressed: () => _onTargetMusclePressed(
                              _exerciseMethodList[(index ~/ 2)]),
                          style: ElevatedButton.styleFrom(
                            primary: lightGrayColor,
                            minimumSize: Size.zero,
                            padding:
                                const EdgeInsets.fromLTRB(10, 8.5, 10, 8.5),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _exerciseMethodList[(index ~/ 2)],
                            style: const TextStyle(
                              fontSize: _exerciseMethodSelectFontSize,
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else {
                        return TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding:
                                const EdgeInsets.fromLTRB(10, 8.5, 10, 8.5),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _onExerciseMethodPressed(
                              _exerciseMethodList[(index ~/ 2)]),
                          child: Text(
                            _exerciseMethodList[(index ~/ 2)],
                            style: const TextStyle(
                              fontSize: _exerciseMethodSelectFontSize,
                              color: clearBlackColor,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    Widget _cardioMethodSelect = SizedBox(
      width: _targetSelectWidth,
      height: _targetMuscleSelectHeight,
      child: DisableGlowListView(
        padding: const EdgeInsets.only(top: 10),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _cardioMethodList.length * 2 - 1,
              (index) {
                if (index % 2 != 0) {
                  return horizontalSpacer(5);
                } else {
                  return GetBuilder<AddExerciseController>(
                    builder: (_) {
                      if (_.exerciseMethod == (index ~/ 2)) {
                        return ElevatedButton(
                          onPressed: () => _onAerobicMethodPressed(index ~/ 2),
                          style: ElevatedButton.styleFrom(
                            primary: cardioColor,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _cardioMethodList[(index ~/ 2)],
                            style: const TextStyle(
                              fontSize: _targetMuscleSelectFontSize,
                              color: lightBlackColor,
                            ),
                          ),
                        );
                      } else {
                        return TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _onAerobicMethodPressed(index ~/ 2),
                          child: Text(
                            _cardioMethodList[(index ~/ 2)],
                            style: const TextStyle(
                              fontSize: _targetMuscleSelectFontSize,
                              color: clearBlackColor,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    Widget _exerciseBlockList = Expanded(
      child: GetBuilder<AddExerciseController>(builder: (_) {
        if (_.loading) {
          return const CircularLoadingIndicator();
        } else {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _ExerciseBlock(
                    name: _.selectedExerciseDataList[index]['name'] ?? '',
                    exerciseId: _.selectedExerciseDataList[index]['id'],
                    targetMuscle: _.selectedExerciseDataList[index]
                            ['target_muscle'] ??
                        '',
                    exerciseMethod: _.selectedExerciseDataList[index]
                            ['exercise_method'] ??
                        '',
                    onTap: () => _onExerciseBlockPressed(index),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => verticalSpacer(15),
            itemCount: _.selectedExerciseDataList.length,
          );
        }
      }),
    );

    return Column(
      children: [
        _header,
        verticalSpacer(20),
        _exerciseSearchBar,
        GetBuilder<AddExerciseController>(
          builder: (_) {
            if (_.exerciseType == 0) {
              return Column(
                children: [
                  _targetMuscleSelect,
                  _exerciseMethodSelect,
                ],
              );
            } else {
              return _cardioMethodSelect;
            }
          },
        ),
        _exerciseBlockList,
      ],
    );
  }
}

class _ExerciseBlock extends StatelessWidget {
  final String name;
  final int exerciseId;
  final int targetMuscle;
  final int exerciseMethod;
  final void Function() onTap;
  const _ExerciseBlock({
    Key? key,
    required this.name,
    required this.exerciseId,
    required this.targetMuscle,
    required this.exerciseMethod,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onInfoButtonPressed(String name) {
      Get.toNamed('/excercise_info', arguments: name);
    }

    return SizedBox(
      width: 330,
      height: 90,
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            width: 215,
            height: 90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          const Positioned(
            right: 0,
            width: 115,
            height: 90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: lightGrayColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: 215,
                      padding: const EdgeInsets.only(
                          top: 16.5, bottom: 16.5, left: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                name,
                                style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: brightSecondaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, top: 2),
                                  child: Text(
                                    targetMuscleIntToStr[targetMuscle]!,
                                    style: const TextStyle(
                                      height: 1.0,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: clearBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              horizontalSpacer(10),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: lightGrayColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, top: 2),
                                  child: Text(
                                    exerciseMethodIntToStr[exerciseMethod]!,
                                    style: const TextStyle(
                                      height: 1.0,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: clearBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 115,
                      height: 90,
                      alignment: Alignment.topRight,
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.help, color: Colors.white),
                        onPressed: () => _onInfoButtonPressed(name),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
