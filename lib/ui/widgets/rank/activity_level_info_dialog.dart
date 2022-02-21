import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityLevelInfoDialog extends StatelessWidget {
  const ActivityLevelInfoDialog({Key? key}) : super(key: key);

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
                        '프로틴 등급',
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
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              '프로틴은 EXON의 포인트를 의미합니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: deepGrayColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              children: List.generate(activityLevelIntToStr.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activityLevelIntToStr[index]!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: brightPrimaryColor,
                        ),
                      ),
                      Text(
                        index == activityLevelIntToStr.length - 1
                            ? formatNumberFromInt(
                                    getLevelRequiredProtein(index)) +
                                ' 이상'
                            : '${formatNumberFromInt(getLevelRequiredProtein(index))}~${formatNumberFromInt(getLevelRequiredProtein(index + 1))}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 6.5),
                child: CommentIconTrailing(
                  width: 20,
                  height: 20,
                ),
              ),
              Text(
                '프로틴 부여기준',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: clearBlackColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: List.generate(7, (index) {
                late String _labelText;
                late int protein;

                switch (index) {
                  case 1:
                    _labelText = '일일 운동 계획 모두 수행';
                    protein = 10;
                    break;
                  case 2:
                    _labelText = '주간 운동 정산';
                    protein = 10;
                    break;
                  case 3:
                    _labelText = 'HOT 게시물 선정';
                    protein = 50;
                    break;
                  case 4:
                    _labelText = 'Q&A 인기 답변 선정';
                    protein = 20;
                    break;
                  case 5:
                    _labelText = 'Q&A 질문자 채택';
                    protein = 30;
                    break;
                  case 6:
                    _labelText = 'HOT Q&A 선정';
                    protein = 50;
                    break;
                  default:
                    _labelText = '출석 (일일 첫 운동 기록)';
                    protein = 5;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _labelText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: brightPrimaryColor,
                        ),
                      ),
                      Text(
                        index == 2 ? '운동한 일수 * $protein 프로틴' : '$protein 프로틴',
                        style: const TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
