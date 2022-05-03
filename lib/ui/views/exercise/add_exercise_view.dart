import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_plan_controller.dart';
import 'package:exon_app/ui/pages/exercise/add_exercise_details_page.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/ui/pages/exercise/select_exercise_page.dart';
import 'package:get/get.dart';

class AddExerciseView extends GetView<ExercisePlanController> {
  AddExerciseView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const SelectExercisePage(),
    const AddExerciseDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExercisePlanController>(
      builder: (_) {
        if (_.page < 0 || _.page >= _pages.length) {
          _.jumpToPage(0);
        }
        return Scaffold(
          backgroundColor: mainBackgroundColor,
          body: SafeArea(
            child: _.isUpdate ? _pages[1] : _pages[_.page],
          ),
        );
      },
    );
  }
}
