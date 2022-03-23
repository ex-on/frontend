import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingContentBlock extends StatelessWidget {
  const LoadingContentBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: mainBackgroundColor,
        highlightColor: Colors.white.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 83,
              height: 17,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(5),
            SizedBox(
              width: 54,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(30),
            SizedBox(
              width: 270,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(5),
            SizedBox(
              width: 93,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(25),
            SizedBox(
              width: 112,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingCommentBlock extends StatelessWidget {
  const LoadingCommentBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: mainBackgroundColor,
        highlightColor: Colors.white.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(10),
            SizedBox(
              width: 200,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(5),
            SizedBox(
              width: 54,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(25),
            SizedBox(
              width: 45,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(10),
            SizedBox(
              width: 240,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(5),
            SizedBox(
              width: 54,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(25),
            SizedBox(
              width: 44,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(10),
            SizedBox(
              width: 200,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            verticalSpacer(5),
            SizedBox(
              width: 54,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
