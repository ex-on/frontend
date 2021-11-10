import 'dart:async';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/dummy_data.dart';
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
    const String _addSetButtonText = '세트 추가하기';
    const String _completeButtonText = '완료';
    const String _inputWeightLabelText = '중량';
    const String _inputRepsLabelText = '횟수';
    const double _addIconSize = 26;
    const double _deleteIconSize = 30;
    final _data =
        DummyDataController.to.exerciseInfoList[controller.selectedExercise] ??
            {};

    void _onBackPressed() {
      controller.jumpToPage(0);
      controller.reset();
    }

    void _onLoadRecordPressed() {}

    void _onDeleteSetPressed(int setNum) {
      controller.deleteSet(setNum);
    }

    void _onCompletePressed() {
      DummyDataController.to.addDailyExercisePlan(
          controller.selectedExercise, controller.inputSetValues);
      controller.reset();
      Get.offNamed('/home');
    }

    void _onBottomSheetClosePressed() {
      Get.back();
    }

    void _onBottomSheetClosed() {
      if (!controller.addedNewSet) {
        controller.deleteSet(controller.numSets);
      } else {
        controller.resetAddedNewSet();
      }
    }

    void _onBottomSheetCompletePressed() {
      controller.confirmNewSet();
      controller.updateInputSetValues();
      Get.back();
    }

    void _onInputSetWeightChanged(int index) {
      controller.updateCurrentInputSetWeight((index + 1));
    }

    void _onInputSetRepsChanged(int index) {
      controller.updateCurrentInputSetReps(index + 1);
    }

    Widget _bottomSheet(int setNum) {
      return SetInputBottomSheet(
        setNum: setNum,
        onClosePressed: _onBottomSheetClosePressed,
        onCompletePressed: _onBottomSheetCompletePressed,
        onWeightChanged: _onInputSetWeightChanged,
        onRepsChanged: _onInputSetRepsChanged,
        weightController: controller.getWeightController(setNum),
        repsController: controller.getRepsController(setNum),
      );
      // return Container(
      //   height: context.height * 0.5,
      //   width: context.width,
      //   decoration: const BoxDecoration(
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      //     color: Color(0xffF4F3F8),
      //   ),
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 4,
      //         width: 50,
      //         margin: const EdgeInsets.symmetric(vertical: 10),
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(20),
      //           color: const Color(0xffD4D1E1),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 20),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             IconButton(
      //               onPressed: _onBottomSheetClosePressed,
      //               icon: const Icon(
      //                 Icons.close_rounded,
      //                 color: Color(0xff333333),
      //                 size: 30,
      //               ),
      //             ),
      //             Text(
      //               setNum.toString() + '세트',
      //               style: const TextStyle(
      //                 color: Color(0xff000300),
      //                 fontSize: 22,
      //               ),
      //             ),
      //             IconButton(
      //               onPressed: _onBottomSheetCompletePressed,
      //               icon: const Icon(
      //                 Icons.check_rounded,
      //                 color: darkSecondaryColor,
      //                 size: 30,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       verticalSpacer(20),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.end,
      //         children: [
      //           Column(
      //             children: [
      //               const Padding(
      //                 padding: EdgeInsets.only(bottom: 12),
      //                 child: Text(
      //                   _inputWeightLabelText,
      //                   style: TextStyle(
      //                     fontSize: 18,
      //                     color: Color(0xff333333),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 100,
      //                 height: 250,
      //                 child: DecoratedBox(
      //                   decoration: const BoxDecoration(
      //                     border: Border(
      //                       top: BorderSide(
      //                         color: darkSecondaryColor,
      //                         width: 2,
      //                       ),
      //                     ),
      //                   ),
      //                   child: CupertinoPicker(
      //                     itemExtent: 60,
      //                     scrollController:
      //                         // _.getWeightController(setNum),
      //                         controller.getWeightController(setNum),
      //                     onSelectedItemChanged: (int index) =>
      //                         _onInputSetWeightChanged(index + 1),
      //                     children: List.generate(
      //                       200,
      //                       (index) => Center(
      //                         child: Text(
      //                           (index + 1).toString() + ' kg',
      //                           style: const TextStyle(
      //                             fontSize: 18,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           horizontalSpacer(40),
      //           Column(
      //             children: [
      //               const Padding(
      //                 padding: EdgeInsets.only(bottom: 12),
      //                 child: Text(
      //                   _inputRepsLabelText,
      //                   style: TextStyle(
      //                     fontSize: 18,
      //                     color: Color(0xff333333),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 100,
      //                 height: 250,
      //                 child: DecoratedBox(
      //                   decoration: const BoxDecoration(
      //                     border: Border(
      //                       top: BorderSide(
      //                         color: darkSecondaryColor,
      //                         width: 2,
      //                       ),
      //                     ),
      //                   ),
      //                   child: CupertinoPicker(
      //                     itemExtent: 60,
      //                     scrollController:
      //                         controller.getRepsController(setNum),
      //                     onSelectedItemChanged: (int index) =>
      //                         _onInputSetRepsChanged(index + 1),
      //                     children: List.generate(
      //                       20,
      //                       (index) => Center(
      //                         child: Text(
      //                           (index + 1).toString(),
      //                           style: const TextStyle(
      //                             fontSize: 18,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // );
    }

    void _onNumRepsTap(int setNum) {
      controller.updateInputSetNum(setNum);
      Get.bottomSheet(_bottomSheet(setNum)).whenComplete(_onBottomSheetClosed);
    }

    void _onAddSetPressed() {
      controller.addSet();
      controller.updateInputSetNum(controller.numSets);
      Get.bottomSheet(_bottomSheet(controller.numSets))
          .whenComplete(_onBottomSheetClosed);
    }

    Widget _header = Header(
      onPressed: _onBackPressed,
      color: mainBackgroundColor,
    );

    Widget _exerciseInfoSection = DecoratedBox(
      decoration: const BoxDecoration(
        color: mainBackgroundColor,
      ),
      child: _data.isEmpty
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
                      _data['name'],
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
                              text:
                                  targetMuscleIntToStr[_data['target_muscle']]!,
                              type: 'targetMuscle',
                              fontSize: 20,
                              height: 37,
                              width: 61,
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
                              text: excerciseMethodIntToStr[
                                  _data['exercise_method']]!,
                              type: 'exerciseMethod',
                              fontSize: 20,
                              height: 37,
                              width: 61,
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
                    child: NumberInputFieldDisplay(
                        hintText: '0.0',
                        inputText: _.inputSetValues[setNum - 1][0].toString(),
                        onTap: () => _onNumRepsTap(setNum)),
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
                    child: NumberInputFieldDisplay(
                        hintText: '0',
                        inputText: _.inputSetValues[setNum - 1][1].toString(),
                        onTap: () => _onNumRepsTap(setNum)),
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

    Widget _excerciseSetList = GetBuilder<AddExerciseController>(
      builder: (_) {
        var children = List.generate(
          !_.isAddingNewSet ? _.numSets : _.numSets - 1,
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
      child: ElevatedActionButton(
        buttonText: _completeButtonText,
        onPressed: _onCompletePressed,
      ),
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
                    _excerciseSetList,
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
