import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedContentPreviewBuilder extends StatelessWidget {
  final int index;
  const SavedContentPreviewBuilder({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        var isPost = _.savedData[index]['post_data'] != null;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: (index % 2 == 0) ? null : Colors.white,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                if (_.savedData[index]['post_data'] != null) {
                  var id = _.savedData[index]['post_data']['id'];
                  _.getPost(id);
                  _.getPostCount(id);
                  _.getPostComments(id);
                  Get.toNamed('/community/post', arguments: id);
                } else if (_.savedData[index]['qna_data'] != null) {
                  var id = _.savedData[index]['qna_data']['id'];
                  _.getQna(id);
                  _.getQnaCount(id);
                  _.getQnaAnswers(id);
                  Get.toNamed('/community/qna');
                }
              },
              child: SizedBox(
                height: 100,
                width: context.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              isPost
                                  ? _.savedData[index]['post_data']['title']
                                  : _.savedData[index]['qna_data']['title'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: darkPrimaryColor,
                              ),
                            ),
                          ),
                          Text(
                            isPost
                                ? _.savedData[index]['post_data']
                                    ['creation_date']
                                : _.savedData[index]['qna_data']
                                    ['creation_date'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              letterSpacing: -1,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Flexible(
                          child: Text(
                            isPost
                                ? _.savedData[index]['post_data']['content']
                                : _.savedData[index]['qna_data']['content'],
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: deepGrayColor,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: deepGrayColor,
                                radius: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  _.postContentList[index]['user_data']
                                      ['username'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const LikeIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  _.postContentList[index]['count']
                                          ['count_likes']
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ),
                              horizontalSpacer(10),
                              const CommentIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  _.postContentList[index]['count']
                                          ['count_comments']
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
