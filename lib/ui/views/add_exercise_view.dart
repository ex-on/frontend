import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/ui/pages/add_exercise/add_exercise_details_page.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/ui/pages/add_exercise/select_exercise_page.dart';
import 'package:get/get.dart';

class AddExerciseView extends GetView<AddExerciseController> {
  AddExerciseView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const SelectExercisePage(),
    const AddExerciseDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddExerciseController>(
      builder: (_) {
        if (_.page < 0 || _.page >= _pages.length) {
          _.jumpToPage(0);
        }
        return Scaffold(
          backgroundColor: _.page == 1 ? Colors.white : mainBackgroundColor,
          body: _pages[_.page],
        );
      },
    );
  }
}
