import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyExerciseLevelInfoDialog extends StatelessWidget {
  const MonthlyExerciseLevelInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: const [
                    ProteinIcon(),
                    Padding(
                      padding: EdgeInsets.only(left: 6.5),
                      child: Text(
                        '운동 수행 등급',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 20,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              children: List.generate(
                4,
                (index) {
                  late String _labelText;

                  switch (index) {
                    case 1:
                      _labelText = '운동 계획을 세웠지만,\n진행 기록이 없어요';
                      break;
                    case 2:
                      _labelText = '운동 계획을 세웠고,\n일부를 진행했어요';
                      break;
                    case 3:
                      _labelText = '운동 계획을 세웠고,\n모두 진행했어요';
                      break;
                    default:
                      _labelText = '세운 운동 계획이 없어요';
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: profileExerciseStatusIntToColor[index]!,
                            ),
                            color: profileExerciseStatusIntToColor[index],
                          ),
                          alignment: Alignment.center,
                        ),
                        horizontalSpacer(30),
                        SizedBox(
                          height: 40,
                          width: 140,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _labelText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: deepGrayColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
