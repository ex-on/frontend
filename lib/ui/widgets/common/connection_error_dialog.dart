import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/connection_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ConnectionErrorDialog extends StatelessWidget {
  final void Function() onRetryPressed;
  const ConnectionErrorDialog({
    Key? key,
    required this.onRetryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = ConnectionController.to;

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(40, 40, 40, 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '인터넷 연결에 실패했어요',
            style: TextStyle(
              color: deepGrayColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: EmptyBoxCharacter(),
          ),
          GetBuilder<ConnectionController>(builder: (_) {
            if (_.loading) {
              return const CircularLoadingIndicator();
            } else {
              return ElevatedActionButton(
                buttonText: '다시 시도하기',
                onPressed: onRetryPressed,
                width: 220,
                height: 60,
              );
            }
          }),
        ],
      ),
    );
  }
}
