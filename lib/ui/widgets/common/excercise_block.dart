import 'package:exon_app/constants/colors.dart';
import 'package:exon_app/core/controllers/excercise_block_controller.dart';
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
          color: lightPrimaryColor,
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
                              color: deepPrimaryColor,
                            ),
                          )
                        : IconButton(
                            onPressed: _onPressed,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: deepPrimaryColor,
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
