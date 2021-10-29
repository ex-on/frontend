import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_excercise_controller.dart';
import 'package:exon_app/ui/pages/add_excercise/add_excercise_details_page.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/ui/pages/add_excercise/select_excercise_page.dart';
import 'package:get/get.dart';

class AddExcerciseView extends GetView<AddExcerciseController> {
  AddExcerciseView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const SelectExcercisePage(),
    const AddExcerciseDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddExcerciseController>(
      builder: (_) {
        if (_.page < 0 || _.page >= _pages.length) {
          _.jumpToPage(0);
        }
        return Scaffold(backgroundColor: Colors.white, body: _pages[_.page]);
      },
    );
  }
}
