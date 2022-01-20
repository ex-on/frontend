import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/ui/pages/rank/rank_aerobic_page.dart';
import 'package:exon_app/ui/pages/rank/rank_protein_page.dart';
import 'package:exon_app/ui/pages/rank/rank_weight_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RankTabView extends GetView<RankController> {
  const RankTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _tabBar = TabBar(
      controller: controller.rankMainTabController,
      isScrollable: true,
      indicator: BoxDecoration(),
      labelColor: brightPrimaryColor,
      unselectedLabelColor: lightGrayColor,
      labelStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
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

    return Column(
      children: [
        CustomLeadingHeader(leading: _tabBar),
        Expanded(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: controller.rankMainTabController,
            children: const <Widget>[
              RankProteinPage(),
              RankAerobicPage(),
              RankWeightPage(),
            ],
          ),
        ),
      ],
    );
  }
}
