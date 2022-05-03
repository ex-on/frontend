import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/ui/pages/rank/rank_cardio_page.dart';
import 'package:exon_app/ui/pages/rank/rank_protein_page.dart';
import 'package:exon_app/ui/pages/rank/rank_weight_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankTabView extends GetView<RankController> {
  const RankTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _tabBar = TabBar(
      controller: controller.rankMainTabController,
      isScrollable: true,
      indicatorColor: brightPrimaryColor,
      labelColor: brightPrimaryColor,
      unselectedLabelColor: lightGrayColor,
      labelStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3.5,
      unselectedLabelStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      tabs: const <Widget>[
        Tab(child: Text('프로틴')),
        Tab(child: Text('유산소')),
        Tab(child: Text('근력')),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
      child: Column(
        children: [
          CustomLeadingHeader(leading: _tabBar),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: controller.rankMainTabController,
              children: const <Widget>[
                RankProteinPage(),
                RankCardioPage(),
                RankWeightPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
