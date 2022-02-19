import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankProteinPage extends GetView<RankController> {
  const RankProteinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onHelpPressed() {}

    return Builder(builder: (context) {
      List<Widget> children = [
        Container(
          color: Colors.white,
          width: context.width,
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 20,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const ProteinIcon(),
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text(
                            '내 프로틴',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: clearBlackColor,
                            ),
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: HelpIconButton(onPressed: _onHelpPressed),
                        ),
                      ],
                    ),
                    const Text.rich(TextSpan(
                      text: '헬린이',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: darkSecondaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: '까지 ',
                          style: TextStyle(
                            fontSize: 13,
                            color: clearBlackColor,
                          ),
                        ),
                        TextSpan(
                          text: '4,349',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: darkSecondaryColor,
                            letterSpacing: -1,
                          ),
                        ),
                        TextSpan(
                          text: ' 프로틴 남았어요',
                          style: TextStyle(
                            fontSize: 13,
                            color: clearBlackColor,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                width: context.width - 60,
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: const Text.rich(
                  TextSpan(
                    text: 'exon_official 님은 지금까지 총 ',
                    style: TextStyle(
                      fontSize: 14,
                      height: 22 / 14,
                      letterSpacing: -1,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '21,651 ',
                        style: TextStyle(
                          fontSize: 18,
                          height: 22 / 18,
                          letterSpacing: -2,
                          color: brightPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '프로틴을 획득했고, 매달 평균 ',
                        style: TextStyle(
                          fontSize: 14,
                          height: 22 / 14,
                          letterSpacing: -1,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '3,582 ',
                        style: TextStyle(
                          fontSize: 18,
                          height: 22 / 18,
                          letterSpacing: -2,
                          color: brightPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '프로틴을 얻었어요',
                        style: TextStyle(
                          fontSize: 14,
                          height: 22 / 14,
                          letterSpacing: -1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: context.width - 60,
                      height: 20,
                      padding: const EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: mainBackgroundColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        '4,349',
                        style: TextStyle(
                          fontSize: 13,
                          color: lightGrayColor,
                        ),
                      ),
                    ),
                    Container(
                      width: (context.width - 60) * 21651 / 30000,
                      height: 20,
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: brightPrimaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          WhiteProteinIcon(),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Text(
                              '21,651',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '헬스세포',
                      style: TextStyle(
                        color: brightPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '헬린이',
                      style: TextStyle(
                        color: lightGrayColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.5, color: lightGrayColor),
        SizedBox(
          height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    '순위',
                    style: TextStyle(
                      color: deepGrayColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '닉네임',
                  style: TextStyle(
                    color: deepGrayColor,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 35),
                  child: Text(
                    '프로틴',
                    style: TextStyle(
                      color: deepGrayColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 0.5, color: lightGrayColor),
      ];

      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: RankBadgeFirstIcon(),
                    ),
                    Text.rich(
                      TextSpan(
                        text: '헬스세포',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: lightGrayColor,
                        ),
                        children: [
                          TextSpan(
                            text: ' 김근육',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: clearBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  '14,918',
                  style: TextStyle(
                    fontSize: 16,
                    color: clearBlackColor,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 0.5, color: lightGrayColor),
          ],
        ),
      ));

      return ListView(
        padding: EdgeInsets.zero,
        children: children,
      );
    });
  }
}
