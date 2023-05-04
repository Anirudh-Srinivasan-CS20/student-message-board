import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:frontend/models/post_model.dart';
import 'package:frontend/pages/post_page.dart';
import 'package:frontend/services/api_service.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class addCommentPage extends StatefulWidget {
  final PostModel postData;
  const addCommentPage({
    required this.postData,
  });

  @override
  State<addCommentPage> createState() => AddCommentPageState();
}

class AddCommentPageState extends State<addCommentPage> {
  TextEditingController controller = TextEditingController();
  late String body = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ui.Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            MarkdownTextInput(
              (String value) => setState(() => body = value),
              body,
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
                child: const ui.Text("Post"),
                onPressed: () {
                  APIService.updateComment(
                    -1,
                    body,
                    widget.postData.id,
                  ).then((value) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostPage(
                          postData: widget.postData,
                        ),
                      ),
                    );
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
