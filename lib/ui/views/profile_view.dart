import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
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
    void _onMenuPressed() {
      Get.toNamed('/settings');
    }

    Future.delayed(Duration.zero, () => AuthController.to.getUserInfo());

    void _onProfileEditPressed() {}

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

    Widget _qnaPostContentBuilder() {
      return Container();
    }

    Widget _profileActivityView = Column();

    Widget _profileCommunityView = Column();

    TabBarView _tabBarView = TabBarView(
      physics: const BouncingScrollPhysics(),
      controller: controller.profileTabController,
      children: <Widget>[
        _profileActivityView,
        _profileCommunityView,
      ],
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
