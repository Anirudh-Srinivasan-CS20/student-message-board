import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:frontend/helper/common.dart';
import 'package:frontend/pages/post_page.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/views/widgets/post_stats.dart';
import 'package:frontend/views/widgets/post_time_stamp.dart';
import 'package:frontend/views/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:simple_tags/simple_tags.dart';

class PostCard extends StatelessWidget {
  final PostModel postData;

  const PostCard({required this.postData});

  @override
  Widget build(BuildContext context) {
    final double aspectRatio = isLandscape(context) ? 16 / 2 : 16 / 3;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return PostPage(postData: postData);
        }));
      },
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Card(
          elevation: 2,
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            child: InheritedPostModel(
              postData: postData,
              child: Column(
                children: <Widget>[
                  _Post(),
                  const Divider(color: Colors.grey),
                  _PostDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(children: <Widget>[_PostTitleSummaryAndTime()]),
    );
  }
}

class _PostTitleSummaryAndTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context)!.postData;
    final TextStyle? titleTheme = Theme.of(context).textTheme.titleLarge;
    final String title = postData.title;

    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                HtmlWidget(
                  title,
                ),
              ],
            ),
            const PostTimeStamp(alignment: Alignment.centerRight),
          ],
        ),
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context)!.postData;
    final String tags = postData.tags;
    final List<String> tagList =
        (tags != "") ? tags.substring(1, tags.length - 1).split('><') : [];
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(postData.actualDisplayName),
              ),
              SimpleTags(
                content: tagList,
                wrapSpacing: 4,
                wrapRunSpacing: 4,
                tagContainerPadding: const EdgeInsets.all(6),
                // tagIcon: const Icon(
                //   Icons.tag,
                //   size: 12,
                // ),
                tagTextStyle: const TextStyle(color: Colors.lightGreen),
                tagContainerDecoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PostStats(),
        ),
      ],
    );
  }
}
