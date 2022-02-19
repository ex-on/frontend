import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:flutter/cupertino.dart';

class SetInputBottomSheet extends StatelessWidget {
  final int setNum;
  final void Function() onClosePressed;
  final void Function() onCompletePressed;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  final FixedExtentScrollController weightController;
  final FixedExtentScrollController repsController;

  const SetInputBottomSheet({
    Key? key,
    required this.setNum,
    required this.onClosePressed,
    required this.onCompletePressed,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.weightController,
    required this.repsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _inputWeightLabelText = '중량';
    const String _inputRepsLabelText = '횟수';
    return Container(
      height: context.height * 0.5,
      width: context.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Color(0xffF4F3F8),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffD4D1E1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onClosePressed,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xff333333),
                    size: 30,
                  ),
                ),
                Text(
                  setNum.toString() + '세트',
                  style: const TextStyle(
                    color: Color(0xff000300),
                    fontSize: 22,
                  ),
                ),
                IconButton(
                  onPressed: onCompletePressed,
                  icon: const Icon(
                    Icons.check_rounded,
                    color: darkSecondaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          verticalSpacer(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      _inputWeightLabelText,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 250,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: darkSecondaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: CupertinoPicker(
                        itemExtent: 60,
                        scrollController: weightController,
                        onSelectedItemChanged: onWeightChanged,
                        children: List.generate(
                          200,
                          (index) => Center(
                            child: Text(
                              (index + 1).toString() + ' kg',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              horizontalSpacer(40),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      _inputRepsLabelText,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 250,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: darkSecondaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: CupertinoPicker(
                        itemExtent: 60,
                        scrollController: repsController,
                        onSelectedItemChanged: onRepsChanged,
                        children: List.generate(
                          20,
                          (index) => Center(
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeightSetInputSection extends GetView<AddExerciseController> {
  final bool bodyWeight;
  const WeightSetInputSection({
    Key? key,
    required this.bodyWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _onCompletePressed() {
      controller.updateInputSetNum(null);
    }

    void _updateWeightChangeValue(int index) {
      controller
          .updateInputWeightChangeValue(inputWeightChangeValueList[index]);
    }

    void _onSubtractWeightPressed() {
      controller.subtractInputWeight();
    }

    void _onAddWeightPressed() {
      controller.addInputWeight();
    }

    void _onWeightInputChanged(String value) {
      controller.onWeightInputChanged(value);
    }

    return Container(
      height: bodyWeight ? 150 : 240,
      width: context.width,
      color: Colors.white,
      child: GetBuilder<AddExerciseController>(
        builder: (_) {
          return Column(
            children: [
              Container(
                width: context.width,
                height: 55,
                color: brightPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _.inputSetNum.toString() + '세트',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    bodyWeight
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4 + 3,
                              (index) => index % 2 == 1
                                  ? horizontalSpacer(10)
                                  : SizedBox(
                                      height: 31,
                                      width: 53,
                                      child: ElevatedActionButton(
                                        buttonText: getCleanTextFromDouble(
                                            inputWeightChangeValueList[
                                                index ~/ 2]),
                                        onPressed: () =>
                                            _updateWeightChangeValue(
                                                index ~/ 2),
                                        backgroundColor:
                                            _.inputWeightChangeValue ==
                                                    inputWeightChangeValueList[
                                                        index ~/ 2]
                                                ? const Color(0xff007590)
                                                : const Color(0xff40CCEC),
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Manrope',
                                          fontSize: 13,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                    TextActionButton(
                        isUnderlined: false,
                        textColor: Colors.white,
                        fontSize: 16,
                        buttonText: '완료',
                        onPressed: _onCompletePressed),
                  ],
                ),
              ),
              bodyWeight
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const SubtractIcon(
                                width: null,
                                height: null,
                              ),
                              splashRadius: 20,
                              splashColor: brightPrimaryColor.withOpacity(0.1),
                              highlightColor:
                                  brightPrimaryColor.withOpacity(0.1),
                              onPressed: _onSubtractWeightPressed,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  NumberInputField(
                                    controller: _.inputSetControllerList[
                                        _.inputSetNum! - 1][0],
                                    onChanged: _onWeightInputChanged,
                                    hintText: '0.0',
                                    fontSize: 30,
                                  ),
                                  const Text(
                                    'kg',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: brightPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Mandrope',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const AddIcon(
                                width: null,
                                height: null,
                              ),
                              splashRadius: 20,
                              splashColor: brightPrimaryColor.withOpacity(0.1),
                              highlightColor:
                                  brightPrimaryColor.withOpacity(0.1),
                              onPressed: _onAddWeightPressed,
                            ),
                          ],
                        ),
                      ),
                    ),
              bodyWeight
                  ? const SizedBox.shrink()
                  : const Divider(
                      color: Color(0xffE1F4F8),
                      thickness: 4,
                      height: 4,
                    ),
              () {
                List<Widget> _children = _.inputTargetRepsList.map((e) {
                  if (e == int.parse(_.getCurrentSetInputReps())) {
                    return Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text.rich(
                          TextSpan(
                            text: e.toString(),
                            style: const TextStyle(
                              color: brightPrimaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Manrope',
                              height: 1.0,
                            ),
                            children: const [
                              TextSpan(
                                text: '회',
                                style: TextStyle(
                                  color: brightPrimaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Manrope',
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: Center(
                        child: Text(
                          e.toString(),
                          style: const TextStyle(
                            color: brightPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    );
                  }
                }).toList();

                _.targetRepsScrollController = FixedExtentScrollController(
                    initialItem: int.parse(_
                            .inputSetControllerList[_.inputSetNum! - 1][1]
                            .text) -
                        1);

                return Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0),
                  child: SizedBox(
                    height: 40,
                    width: context.width,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: CupertinoPicker(
                        scrollController: _.targetRepsScrollController,
                        itemExtent: 80,
                        selectionOverlay: const DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: brightPrimaryColor,
                                width: 0.5,
                              ),
                              bottom: BorderSide(
                                color: brightPrimaryColor,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        onSelectedItemChanged: _.updateInputReps,
                        children: _children,
                      ),
                    ),
                  ),
                );
              }()
            ],
          );
        },
      ),
    );
  }
}
