import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:frontend/models/comment_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class editCommentPage extends StatefulWidget {
  final CommentModel commentData;
  const editCommentPage({
    required this.commentData,
  });

  @override
  State<editCommentPage> createState() => EditCommentPageState();
}

class EditCommentPageState extends State<editCommentPage> {
  TextEditingController controller = TextEditingController();
  late String body = widget.commentData.text;
  late int id = widget.commentData.id;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ui.Text('Edit Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            MarkdownTextInput(
              (String value) => setState(() => body = value),
              widget.commentData.text,
              label: 'Description',
              maxLines: 10,
              actions: MarkdownType.values,
              controller: controller,
              textStyle: const TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const ui.Text("Save"),
                onPressed: () {
                  APIService.updateComment(
                    id,
                    body,
                    -1,
                  ).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
