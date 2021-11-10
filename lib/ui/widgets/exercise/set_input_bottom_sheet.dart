import 'package:exon_app/ui/widgets/common/spacer.dart';
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
                    child:
                        DecoratedBox(
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
