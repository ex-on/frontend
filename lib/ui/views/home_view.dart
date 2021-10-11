import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/pages/home/main_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const MainHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.page.value < 0 || controller.page.value >= _pages.length) {
        controller.page.value = 0;
      }
      return Scaffold(body: _pages[controller.page.value]);
    });
  }
}
