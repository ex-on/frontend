import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String profileName = 'aschung01';
    const String nickName = '정순호영상이나올려라';
    const String profileIntroText = '헬스가 제일 쉬웠어요\n벤치, 데드, 스쾃으로만 운동했어요';
    const String _postLabelText = '내가 쓴 글';
    const String _qnaPostLabelText = 'Q&A 답변';
    const String _expandButtonText = '전체보기';

    Future.delayed(Duration.zero, () => AuthController.to.getUserInfo());
    Future.delayed(
        Duration.zero, () => controller.getUserRecentCommunityData());

    void _onMenuPressed() {
      Get.toNamed('/settings');
    }

    void _onProfileEditPressed() {}

    void _onExpandQnaPressed() {}

    void _onExpandPostPressed() {}

    TabBar _tabBar = TabBar(
      controller: controller.profileTabController,
      indicatorColor: darkPrimaryColor,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 2),
        insets: EdgeInsets.symmetric(horizontal: 50),
      ),
      labelColor: darkPrimaryColor,
      tabs: const <Widget>[
        Tab(child: Text('내 활동')),
        Tab(child: Text('내가 쓴 글')),
      ],
    );

    Widget _indexIndicator(int currentIndex, int totalLength) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalLength,
          (index) {
            return Container(
              height: 6,
              width: 6,
              margin: const EdgeInsets.fromLTRB(4, 12, 4, 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    index == currentIndex ? darkPrimaryColor : lightGrayColor,
              ),
            );
          },
        ),
      );
    }

    Widget _qnaPostContentBuilder() {
      return GetBuilder<ProfileController>(
        builder: (_) {
          if (_.loading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CircularLoadingIndicator(),
            );
          } else {
            if (_.totalQnaAnswerNum == 0 || _.totalQnaAnswerNum == null) {
              return const Text(
                '작성한 답변이 없습니다',
                style: TextStyle(
                  color: deepGrayColor,
                  fontSize: 14,
                ),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 170,
                    child: NotificationListener(
                      onNotification:
                          (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowGlow();
                        return true;
                      },
                      child: PageView.builder(
                        itemCount: (_.totalQnaAnswerNum! > 8)
                            ? 8
                            : _.totalQnaAnswerNum,
                        controller: PageController(viewportFraction: 0.9),
                        onPageChanged: (int index) =>
                            _.updateCurrentQnaIndex(index),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 170, // card height
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: mainBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _.recentQnaList[index]['qna_data']['title'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _indexIndicator(_.currentQnaIndex,
                      (_.totalQnaAnswerNum! > 8) ? 8 : _.totalQnaAnswerNum!)
                ],
              );
            }
          }
        },
      );
    }

    Widget _postContentBuilder() {
      return GetBuilder<ProfileController>(builder: (_) {
        if (_.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CircularLoadingIndicator(),
          );
        } else {
          if (_.totalPostNum == 0 || _.totalPostNum == null) {
            return const Text('쓴 글이 없습니다');
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 170,
                  child: NotificationListener(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return true;
                    },
                    child: PageView.builder(
                      itemCount: (controller.totalPostNum! > 8)
                          ? 8
                          : controller.totalPostNum,
                      controller: PageController(viewportFraction: 0.9),
                      onPageChanged: (int index) =>
                          controller.updateCurrentPostIndex(index),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 170, // card height
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: mainBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _.recentPostList[index]['post_data']['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                _.recentPostList[index]['post_data']['content'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: darkPrimaryColor,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      LikeIcon(),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          _.recentPostList[index]['count']
                                                  ['count_likes']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: darkPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      horizontalSpacer(10),
                                      CommentIcon(),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          _.recentPostList[index]['count']
                                                  ['count_comments']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: darkPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _.recentPostList[index]['post_data']
                                        ['creation_date'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _indexIndicator(_.currentPostIndex,
                    (_.totalPostNum! > 8) ? 8 : _.totalPostNum!),
              ],
            );
          }
        }
      });
    }

    Widget _profileActivityView = Column(
      children: [
        SizedBox(height: 100, width: 100),
      ],
    );

    Widget _profileCommunityView = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Text(
                  _qnaPostLabelText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: -2,
                    color: clearBlackColor,
                  ),
                ),
              ),
              GetBuilder<ProfileController>(builder: (_) {
                return Text(
                  _.totalQnaAnswerNum != null
                      ? _.totalQnaAnswerNum.toString()
                      : '---',
                  style: const TextStyle(
                    fontSize: 16,
                    color: brightPrimaryColor,
                  ),
                );
              }),
              Expanded(child: horizontalSpacer(0)),
              TextActionButton(
                buttonText: _expandButtonText,
                onPressed: _onExpandQnaPressed,
                fontSize: 13,
                textColor: deepGrayColor,
              )
            ],
          ),
        ),
        _qnaPostContentBuilder(),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Text(
                  _postLabelText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: -2,
                    color: clearBlackColor,
                  ),
                ),
              ),
              GetBuilder<ProfileController>(builder: (_) {
                return Text(
                  _.totalPostNum != null ? _.totalPostNum.toString() : '---',
                  style: const TextStyle(
                    fontSize: 16,
                    color: brightPrimaryColor,
                  ),
                );
              }),
              Expanded(child: horizontalSpacer(0)),
              TextActionButton(
                buttonText: _expandButtonText,
                onPressed: _onExpandQnaPressed,
                fontSize: 13,
                textColor: deepGrayColor,
              )
            ],
          ),
        ),
        _postContentBuilder(),
      ],
    );

    Widget _tabBarView = NotificationListener(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: TabBarView(
        controller: controller.profileTabController,
        children: <Widget>[
          _profileActivityView,
          _profileCommunityView,
        ],
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          ProfileHeader(onPressed: _onMenuPressed),
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: brightPrimaryColor,
                  radius: 40,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: lightGrayColor),
                  ),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        splashRadius: 15,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: lightGrayColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AuthController.to.userInfo['username'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: -2,
                color: clearBlackColor,
              ),
            ),
          ),
          Text(
            'EXON과 함께한지 ' +
                DateTime.now()
                    .difference(DateTime.parse(
                        AuthController.to.userInfo['created_at']))
                    .inDays
                    .toString() +
                '일째',
            style: const TextStyle(
              color: softBlackColor,
              fontSize: 14,
            ),
          ),
          verticalSpacer(30),
          _tabBar,
          const Divider(height: 0.5, thickness: 0.5, color: lightGrayColor),
          Expanded(
            child: _tabBarView,
          ),
        ],
      ),
    );
  }
}