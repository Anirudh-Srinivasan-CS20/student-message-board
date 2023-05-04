import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/pages/add_comment_page.dart';
import 'package:frontend/views/widgets/post_stats.dart';
import 'package:frontend/views/widgets/comments_list.dart';
import 'package:frontend/views/widgets/post_time_stamp.dart';
import 'package:frontend/views/widgets/inherited_widgets/inherited_post_model.dart';

class PostPageKeys {
  static final ValueKey wholePage = ValueKey("wholePage");
  static final ValueKey bannerImage = ValueKey("bannerImage");
  static final ValueKey summary = ValueKey("summary");
  static final ValueKey mainBody = ValueKey("mainBody");
}

class PostPage extends StatelessWidget {
  final PostModel postData;

  const PostPage({required this.postData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HtmlWidget(
          postData.title,
          textStyle: const TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addCommentPage(
                  postData: postData,
                ),
                settings: const RouteSettings(
                  name: '/addcomment',
                ),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: InheritedPostModel(
        postData: postData,
        child: SingleChildScrollView(
          child: _NonImageContents(),
        ),
      ),
    );
  }
}

class _NonImageContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Summary(key: PostPageKeys.summary),
          const PostTimeStamp(),
          const SizedBox(height: 8.0),
          PostStats(),
          CommentsList(),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: HtmlWidget(
        InheritedPostModel.of(context)!.postData.body,
      ),
      // child: TeXView(
      //   child: TeXViewColumn(
      //     children: [
      //       TeXViewDocument(
      //         InheritedPostModel.of(context)!.postData.body,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
