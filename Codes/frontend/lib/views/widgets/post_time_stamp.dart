import 'package:flutter/material.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/views/presentation/themes.dart';
import 'package:frontend/views/widgets/inherited_widgets/inherited_post_model.dart';

class PostTimeStamp extends StatelessWidget {
  final Alignment alignment;

  const PostTimeStamp({
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context)!.postData;
    final TextStyle timeTheme = TextThemes.dateStyle;

    return Container(
      width: double.infinity,
      alignment: alignment,
      child: Text(postData.creationDate, style: timeTheme),
    );
  }
}
