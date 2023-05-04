import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/models/comment_model.dart';
import 'package:frontend/pages/edit_comment_page.dart';
import 'package:frontend/pages/edit_post_page.dart';
import 'package:frontend/services/api_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class viewCommentPage extends StatefulWidget {
  const viewCommentPage({Key? key}) : super(key: key);

  @override
  State<viewCommentPage> createState() => _viewCommentPageState();
}

class _viewCommentPageState extends State<viewCommentPage> {
  final int _pageSize = 20;
  final PagingController<int, CommentModel> _pagingController =
      PagingController(firstPageKey: 0);

  Future _fetchPage(int pageKey) async {
    List<CommentModel> newComments = await APIService.getUserComments(
      _pageSize,
      pageKey,
    );
    final isLastPage = newComments.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newComments);
    } else {
      final nextPageKey = pageKey + newComments.length;
      _pagingController.appendPage(newComments, nextPageKey);
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Comments")),
      body: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, CommentModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<CommentModel>(
              itemBuilder: (context, item, index) => Card(
                color: Colors.white,
                borderOnForeground: false,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.text_snippet_rounded),
                      subtitle: MarkdownBody(
                        data: item.text,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Edit'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => editCommentPage(
                                  commentData: item,
                                ),
                                settings: const RouteSettings(
                                  name: '/editcomments',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            APIService.deleteComment(item.id).then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
