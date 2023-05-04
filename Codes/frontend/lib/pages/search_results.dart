import 'package:flutter/material.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/shared_service.dart';
import 'package:frontend/views/widgets/post_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResults extends StatelessWidget {
  final List<TagLanguage> selectedTags;
  final List<UserLanguage> selectedUser;
  final int timeSort;
  final int upvoteSort;

  SearchResults({
    required this.selectedTags,
    required this.selectedUser,
    required this.timeSort,
    required this.upvoteSort,
  });

  final int _pageSize = 20;
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);

  Future _fetchPage(int pageKey) async {
    List<PostModel> newPosts = await APIService.searchPosts(
      selectedUser,
      selectedTags,
      timeSort,
      upvoteSort,
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
  Widget build(BuildContext context) {
    SharedService.checkSession(context);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, PostModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
              itemBuilder: (context, item, index) => PostCard(
                postData: item,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
