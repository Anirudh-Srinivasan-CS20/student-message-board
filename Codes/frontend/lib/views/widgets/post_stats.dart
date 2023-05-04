import 'package:flutter/material.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/views/widgets/inherited_widgets/inherited_post_model.dart';

class PostStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context)!.postData;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _ShowStat(
          icon: Icons.arrow_upward_outlined,
          number: postData.score,
          color: Colors.blueAccent,
        ),
        _ShowStat(
          icon: Icons.remove_red_eye,
          number: postData.viewCount,
          color: Colors.green,
        ),
      ],
    );
  }
}

class _ShowStat extends StatelessWidget {
  final IconData icon;
  final int number;
  final Color color;

  const _ShowStat({
    required this.icon,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Icon(icon, color: color),
        ),
        Text(number.toString()),
      ],
    );
  }
}
