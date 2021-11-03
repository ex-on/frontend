import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/pages/add_excercise/select_excercise_page.dart';
import 'package:exon_app/ui/pages/home/main_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const MainHomePage(),
    const SelectExcercisePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.jumpToPage(0);
    }
    return _pages[controller.page];
  }
}
