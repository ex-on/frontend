import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  static HomeNavigationController to = HomeNavigationController();
  int currentIndex = 2;

  void onIconTap(int index) {
    currentIndex = index;
    update();
  }

}
