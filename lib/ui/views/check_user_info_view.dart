import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CheckUserInfoView extends StatelessWidget {
  const CheckUserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (RegisterInfoController.to.userInfoExists) {
      // return HomeVie
    }
    return const LoadingIndicator();
  }
}
