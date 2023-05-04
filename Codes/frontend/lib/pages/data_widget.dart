import 'storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const Color blue = Color(0xFF4285F4);
const Color red = Color(0xFFEA4335);
const Color yellow = Color(0xFFFBBC05);
const Color green = Color(0xFF34A853);

class DataWidget extends StatelessWidget {
  DataWidget({Key? key, required this.item}) : super(key: key);

  final ColoredDashboardItem item;

  final Map<String, Widget Function(ColoredDashboardItem i)> _map = {
    "post": (l) => PostWidget(),
    "search": (l) => SearchWidget(),
    "editposts": (l) => EditPostsWidget(),
    "editcomments": (l) => EditCommentsWidget(),
  };

  @override
  Widget build(BuildContext context) {
    return _map[item.data]!(item);
  }
}

class SearchWidget extends StatelessWidget {
  SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: red,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            '/addpost',
                          );
                        },
                      text: "Create Post",
                      style: const TextStyle(
                          decoration: TextDecoration.underline)),
                ])),
          ],
        ));
  }
}

class PostWidget extends StatelessWidget {
  PostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: red,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            '/search',
                          );
                        },
                      text: "Search Posts",
                      style: const TextStyle(
                          decoration: TextDecoration.underline)),
                ])),
          ],
        ));
  }
}

class EditPostsWidget extends StatelessWidget {
  EditPostsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: red,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            '/editposts',
                          );
                        },
                      text: "Edit Posts",
                      style: const TextStyle(
                          decoration: TextDecoration.underline)),
                ])),
          ],
        ));
  }
}

class EditCommentsWidget extends StatelessWidget {
  EditCommentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: red,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            '/editcomments',
                          );
                        },
                      text: "Edit Comments",
                      style: const TextStyle(
                          decoration: TextDecoration.underline)),
                ])),
          ],
        ));
  }
}
