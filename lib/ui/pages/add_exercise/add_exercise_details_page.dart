import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExerciseDetailsPage extends StatelessWidget {
  const AddExerciseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddExerciseController());
    const String _titleLabel = '기록할 운동';
    const String _crashText = '정보를 찾을 수 없습니다';
    const String _targetMuscleLabelText = '타겟 부위';
    const String _exerciseMethodLabelText = '운동 종류';
    const String _addExerciseSetLabelText = '운동 기록';
    const String _loadRecordButtonText = '최근 기록 가져오기 >';
    const String _addSetButtonText = '세트 추가하기';
    const String _completeButtonText = '완료';
    const String _inputWeightLabelText = '중량';
    const String _inputRepsLabelText = '횟수';
    const double _addIconSize = 26;
    const double _deleteIconSize = 30;

    void _onBackPressed() {
      controller.jumpToPage(0);
      controller.resetExerciseDetails();
    }

    void _onLoadRecordPressed() {}

    void _onDeleteSetPressed(int setNum) {
      controller.deleteSet(setNum);
    }

    void _onCompletePressed() {
      controller.inputSetControllerList.forEach((element) {
        print(element[0].text);
        print(element[1].text);
      });
      controller.postExerciseWeightPlan();
      controller.resetExerciseDetails();
      Get.offNamed('/home');
    }

    void _onAddSetPressed() {
      controller.addSet();
      controller.updateInputSetNum(controller.numSets);
    }

    Widget _header = Header(
      onPressed: _onBackPressed,
      color: mainBackgroundColor,
    );

    Widget _exerciseInfoSection = DecoratedBox(
      decoration: const BoxDecoration(
        color: mainBackgroundColor,
      ),
      child: controller.selectedExerciseInfo.isEmpty
          ? const Text(_crashText)
          : Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 30,
                bottom: 30,
                top: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      controller.selectedExerciseInfo['name'],
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (context.width - 60) / 2,
                        child: Row(
                          children: [
                            const Text(
                              _targetMuscleLabelText,
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 16,
                              ),
                            ),
                            horizontalSpacer(9),
                            ColorBadge(
                              text: targetMuscleIntToStr[controller
                                  .selectedExerciseInfo['target_muscle']]!,
                              type: 'targetMuscle',
                              fontSize: 16,
                              height: 35,
                              width: 57,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (context.width - 60) / 2,
                        child: Row(
                          children: [
                            const Text(
                              _exerciseMethodLabelText,
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 16,
                              ),
                            ),
                            horizontalSpacer(9),
                            ColorBadge(
                              text: excerciseMethodIntToStr[controller
                                  .selectedExerciseInfo['exercise_method']]!,
                              type: 'exerciseMethod',
                              fontSize: 16,
                              height: 35,
                              width: 57,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );

    Widget _addExerciseSetHeader = Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Color(0xffeeeeee),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextActionButton(
                  buttonText: _loadRecordButtonText,
                  onPressed: _onLoadRecordPressed,
                  fontSize: 14,
                  isUnderlined: false,
                  textColor: softGrayColor,
                ),
              ],
            ),
          ),
        ));

    Widget _exerciseSetBlock(int setNum) {
      return GetBuilder<AddExerciseController>(
        builder: (_) {
          return SizedBox(
            width: context.width - 66,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$setNum세트',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: NumberInputField(
                      hintText: '0.0',
                      controller: _.inputSetControllerList[setNum - 1][0],
                      onChanged: (String text) => _.updateInputSetDataNotNull(),
                    ),
                  ),
                  const Text(
                    'kg',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: NumberInputField(
                      hintText: '0',
                      controller: _.inputSetControllerList[setNum - 1][1],
                      onChanged: (String text) => _.updateInputSetDataNotNull(),
                    ),
                  ),
                  const Text(
                    '회',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: verticalSpacer(0),
                  ),
                  setNum == 1
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () => _onDeleteSetPressed(setNum),
                          icon: const Icon(
                            Icons.remove_circle,
                            color: deepGrayColor,
                            size: _deleteIconSize,
                          ),
                        )
                ],
              ),
            ),
          );
        },
      );
    }

    Widget _addExerciseSetButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: TextActionButton(
          buttonText: _addSetButtonText,
          onPressed: _onAddSetPressed,
          fontSize: 20,
          textColor: deepGrayColor,
          isUnderlined: false,
          leading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Icon(
              Icons.add_circle_outline,
              color: deepGrayColor,
              size: _addIconSize,
            ),
          ),
          width: 170,
          fontWeight: FontWeight.bold,
        ));

    Widget _exerciseSetList = GetBuilder<AddExerciseController>(
      builder: (_) {
        var children = List.generate(
          _.numSets,
          (index) {
            return _exerciseSetBlock(index + 1);
          },
        );
        children.add(_addExerciseSetButton);
        return Column(
          children: children,
        );
      },
    );

    Widget _completeButtonSection = Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: GetBuilder<AddExerciseController>(builder: (_) {
        return ElevatedActionButton(
          buttonText: _completeButtonText,
          onPressed: _onCompletePressed,
          activated: _.inputSetDataNotNull,
        );
      }),
    );

    return Column(
      children: [
        _header,
        Expanded(
          child: DisableGlowListView(
            children: [
              _exerciseInfoSection,
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    _addExerciseSetHeader,
                    _exerciseSetList,
                    verticalSpacer(60),
                  ],
                ),
              ),
            ],
          ),
        ),
        _completeButtonSection,
      ],
    );
  }
}
