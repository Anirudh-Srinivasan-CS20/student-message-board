import 'package:flutter/material.dart';
import 'package:frontend/models/post_model.dart';

class InheritedPostModel extends InheritedWidget {
  final PostModel postData;
  final Widget child;

  InheritedPostModel({
    required this.postData,
    required this.child,
  }) : super(child: child);

  static InheritedPostModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPostModel>();
  }

  @override
  bool updateShouldNotify(InheritedPostModel oldWidget) {
    return true;
  }
}
