import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/excercise_block_controller.dart';
import 'package:exon_app/dummy_data.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcerciseBlock extends StatelessWidget {
  final String titleText;
  final String excerciseDuration;
  final List<List<dynamic>> excerciseDataList;
  const ExcerciseBlock({
    Key? key,
    required this.titleText,
    required this.excerciseDuration,
    required this.excerciseDataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExcerciseBlockController());
    const double _excerciseTextWidth = 130;

    List<Widget> _excerciseList = [
      const Divider(
        color: lightBlackColor,
        thickness: 0.3,
      )
    ];

    void _onPressed() {
      controller.toggle();
    }

    for (int i = 0; i < excerciseDataList.length; i++) {
      _excerciseList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: _excerciseTextWidth,
              child: Text(excerciseDataList[i][0]),
            ),
            excerciseDataList[i][1]
                ? const Icon(
                    Icons.verified,
                    color: completeIconColor,
                  )
                : const Icon(
                    Icons.verified,
                    color: incompleteIconColor,
                  ),
            Text('${excerciseDataList[i][2].toString()} Sets'),
            Text(excerciseDataList[i][3]),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _onPressed,
      child: Container(
        width: 330,
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 24, right: 24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: lightBrightPrimaryColor,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GetBuilder<ExcerciseBlockController>(
                  builder: (_) {
                    return _.open
                        ? IconButton(
                            onPressed: _onPressed,
                            icon: const Icon(
                              Icons.arrow_drop_up,
                              size: 25,
                              color: brightPrimaryColor,
                            ),
                          )
                        : IconButton(
                            onPressed: _onPressed,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: brightPrimaryColor,
                            ),
                          );
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  excerciseDuration,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            GetBuilder<ExcerciseBlockController>(
              builder: (_) {
                return _.open
                    ? Column(
                        children: _excerciseList,
                      )
                    : const SizedBox(height: 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExcercisePlanBlock extends StatelessWidget {
  final int exerciseId;
  final int targetMuscle;
  final int exerciseMethod;
  final int numSets;
  const ExcercisePlanBlock({
    Key? key,
    required this.exerciseId,
    required this.targetMuscle,
    required this.exerciseMethod,
    required this.numSets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExcerciseBlockController());
    const double _excerciseTextWidth = 130;

    void _onPressed() {
      controller.toggle();
    }

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _onPressed,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 24, right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      exerciseIdToName[exerciseId] ?? '',
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2,
                        color: clearBlackColor,
                      ),
                    ),
                    Expanded(
                      child: verticalSpacer(0),
                    ),
                    Text(
                      numSets.toString() + '세트',
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 16,
                        color: clearBlackColor,
                      ),
                    ),
                    horizontalSpacer(5),
                    SizedBox(
                      height: 23,
                      width: 23,
                      child: IconButton(
                        splashRadius: 20,
                        padding: EdgeInsets.zero,
                        onPressed: _onPressed,
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          size: 23,
                          color: softGrayColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 43,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFC700),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        targetMuscleIntToStr[targetMuscle] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    horizontalSpacer(10),
                    Container(
                      width: 43,
                      height: 26,
                      decoration: BoxDecoration(
                        color: brightPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        excerciseMethodIntToStr[exerciseMethod] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 0,
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   child: Icon(Icons.verified, color: incompleteIconColor),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
