import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/pages/community/community_main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityMainView extends GetView<CommunityController> {
  const CommunityMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      CommunityMainPage(),
    ];

    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.jumpToPage(0);
    }

    return GetBuilder<CommunityController>(
      builder: (_) {
        return _pages[_.page];
      },
    );
  }
}
