import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/models/comment_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/views/widgets/comment_stats.dart';
import 'package:frontend/views/widgets/inherited_widgets/inherited_post_model.dart';
import 'dart:html' as html;

class CommentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
        future:
            APIService.getComments(InheritedPostModel.of(context)!.postData.id),
        builder: (context, snapshot) {
          Widget ret;
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            ret = Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ExpansionTile(
                leading: const Icon(Icons.comment),
                trailing: Text(snapshot.data?.length.toString() ?? "0"),
                title: const Text("Comments"),
                children: List<Widget>.generate(
                  snapshot.data?.length ?? 0,
                  (int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MarkdownBody(
                        shrinkWrap: true,
                        selectable: true,
                        data: snapshot.data![index].text,
                        onTapLink: (text, href, title) =>
                            html.window.open(href!, '_blank'),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              snapshot.data![index].actualDisplayName,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CommentStats(
                              commentData: snapshot.data![index],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            ret = const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Loading Comments..."),
            );
          }
          return ret;
        });
  }
}
