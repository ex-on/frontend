import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/exercise/set_input_bottom_sheet.dart';
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
    const String _addSetButtonText = '세트 추가';
    const String _completeButtonText = '완료';
    const String _inputWeightLabelText = '중량';
    const String _inputRepsLabelText = '횟수';
    const double _addIconSize = 26;

    void _onBackPressed() {
      controller.jumpToPage(0);
      controller.resetExerciseDetails();
    }

    void _onLoadRecordPressed() {}

    void _onDeleteSetPressed(int setNum) {
      controller.deleteSet(setNum);
    }

    void _onCompletePressed() {
      controller.postExerciseWeightPlan();
      controller.resetExerciseDetails();
      Get.back();
    }

    void _onSetPressed(int setNum) {
      controller.updateInputSetNum(setNum);
    }

    void _onAddSetPressed() {
      controller.addSet();
      controller.updateInputSetNum(controller.numSets);
    }

    Widget _exerciseInfoSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            controller.selectedExerciseInfo['name'],
            style: const TextStyle(
              fontSize: 20,
              color: clearBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            TargetMuscleLabel(
                text: targetMuscleIntToStr[
                    controller.selectedExerciseInfo['target_muscle']]!),
            horizontalSpacer(10),
            ExerciseMethodLabel(
                text: exerciseMethodIntToStr[
                    controller.selectedExerciseInfo['exercise_method']]!),
          ],
        ),
      ],
    );

    Widget _addExerciseSetHeader = Padding(
      padding: const EdgeInsets.only(bottom: 5, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextActionButton(
            buttonText: _loadRecordButtonText,
            onPressed: _onLoadRecordPressed,
            fontSize: 13,
            isUnderlined: false,
            textColor: softGrayColor,
          ),
        ],
      ),
    );

    Widget _exerciseSetBlock(int setNum) {
      return GetBuilder<AddExerciseController>(
        builder: (_) {
          if (setNum == 1) {
            return SizedBox(
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: setNum == _.inputSetNum
                      ? brightPrimaryColor.withOpacity(0.15)
                      : lightGrayColor.withOpacity(0.15),
                  border: const Border(
                    bottom: BorderSide(
                      color: lightGrayColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => _onSetPressed(setNum),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$setNum세트',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _.inputSetControllerList[setNum - 1][0].text + 'kg',
                            style: const TextStyle(
                              color: clearBlackColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _.inputSetControllerList[setNum - 1][1].text + '회',
                            style: const TextStyle(
                              color: clearBlackColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: setNum == _.inputSetNum
                      ? brightPrimaryColor.withOpacity(0.15)
                      : lightGrayColor.withOpacity(0.15),
                  border: const Border(
                    bottom: BorderSide(
                      color: lightGrayColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => _onSetPressed(setNum),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$setNum세트',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _.inputSetControllerList[setNum - 1][0].text +
                                    'kg',
                                style: const TextStyle(
                                  color: clearBlackColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _.inputSetControllerList[setNum - 1][1].text +
                                    '회',
                                style: const TextStyle(
                                  color: clearBlackColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox.shrink(),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: IconButton(
                                onPressed: () => _onDeleteSetPressed(setNum),
                                padding: EdgeInsets.zero,
                                splashRadius: 13,
                                iconSize: 15,
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Color(0xffD9433A),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    }

    Widget _addExerciseSetButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: TextActionButton(
          buttonText: _addSetButtonText,
          onPressed: _onAddSetPressed,
          fontSize: 18,
          textColor: clearBlackColor,
          isUnderlined: false,
          width: 170,
          fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.only(top: 50, bottom: 40),
      child: GetBuilder<AddExerciseController>(builder: (_) {
        return Center(
          child: ElevatedActionButton(
            buttonText: _completeButtonText,
            onPressed: _onCompletePressed,
            activated: _.inputSetControllerList.every((element) =>
                element[0].text.isNotEmpty &&
                element[0].text != '0.0' &&
                element[0].text != '0' &&
                element[1].text.isNotEmpty &&
                element[1].text != '0'),
          ),
        );
      }),
    );

    return Column(
      children: [
        Header(
          onPressed: _onBackPressed,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                top: 15,
                bottom: 15,
              ),
              child: TextActionButton(
                buttonText: _loadRecordButtonText,
                onPressed: _onLoadRecordPressed,
                fontSize: 13,
                isUnderlined: false,
                textColor: softGrayColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // _addExerciseSetHeader,
              Container(
                decoration: BoxDecoration(
                  // color: darkSecondaryColor,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: context.width,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: controller.selectedExerciseInfo.isEmpty
                    ? const Center(child: Text(_crashText))
                    : Column(
                        children: [
                          _exerciseInfoSection,
                          Column(
                            children: [
                              verticalSpacer(20),
                              _exerciseSetList,
                              verticalSpacer(60),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: GetBuilder<AddExerciseController>(builder: (_) {
            return SizedBox(
              width: context.width,
              height: _.inputSetNum == null ? null : 0,
              child: _.inputSetNum == null ? _completeButtonSection : null,
            );
          }),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: GetBuilder<AddExerciseController>(
            builder: (_) {
              return SizedBox(
                width: context.width,
                height: _.inputSetNum == null ? 0 : null,
                child: _.inputSetNum == null
                    ? null
                    : const WeightSetInputSection(),
              );
            },
          ),
        ),
      ],
    );
  }
}
