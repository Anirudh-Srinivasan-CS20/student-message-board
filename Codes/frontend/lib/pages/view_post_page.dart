import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:frontend/config.dart';
import 'package:frontend/pages/edit_post_page.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class viewPostPage extends StatefulWidget {
  const viewPostPage({Key? key}) : super(key: key);

  @override
  State<viewPostPage> createState() => _viewPostPageState();
}

class _viewPostPageState extends State<viewPostPage> {
  final int _pageSize = 20;
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);

  Future _fetchPage(int pageKey) async {
    List<PostModel> newPosts = await APIService.getUserPosts(
      _pageSize,
      pageKey,
    );
    final isLastPage = newPosts.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newPosts);
    } else {
      final nextPageKey = pageKey + newPosts.length;
      _pagingController.appendPage(newPosts, nextPageKey);
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
      appBar: AppBar(title: const Text("My Posts")),
      body: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, PostModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
              itemBuilder: (context, item, index) => Card(
                color: Colors.white,
                borderOnForeground: false,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.text_snippet_rounded),
                      title: HtmlWidget(
                        item.title,
                      ),
                      subtitle: HtmlWidget(
                        item.body,
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
                                builder: (context) =>
                                    editPostPage(postData: item),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            APIService.deletePost(item.id).then((value) {
                              Navigator.pop(context);
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return AlertDialog(
                              //       content: SingleChildScrollView(
                              //         child: ListBody(
                              //           children: const <Widget>[
                              //             Text('Post deleted successfully.'),
                              //           ],
                              //         ),
                              //       ),
                              //       actions: <Widget>[
                              //         TextButton(
                              //           child: const Text('OK'),
                              //           onPressed: () {
                              //             Navigator.of(context).pop();
                              //             Navigator.pushReplacementNamed(
                              //                 context, "/editposts");
                              //           },
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );
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

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = TextButton(
    onPressed: () => Navigator.pop(context, 'OK'),
    child: const Text('OK'),
  );

// Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success"),
    content: Text("Post deleted successfully."),
    actions: [
      okButton,
    ],
  );

// Show the dialog
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  // );
}
