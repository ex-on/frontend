import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshHeader extends StatelessWidget {
  const CustomRefreshHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: 80,
      builder: (context, mode) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: LoadingIndicator(icon: true),
        );
      },
    );
  }
}
