import 'package:flutter/material.dart';
import 'package:frontend/models/comment_model.dart';

class CommentStats extends StatelessWidget {
  final CommentModel commentData;

  CommentStats({
    required this.commentData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _ShowStat(
          icon: Icons.arrow_drop_up,
          number: commentData.score,
          color: Colors.blueAccent,
        ),
        Text(
          commentData.creationDate,
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
