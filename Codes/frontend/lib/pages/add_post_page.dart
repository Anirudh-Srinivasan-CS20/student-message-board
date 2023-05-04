import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:frontend/services/api_service.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class addPostPage extends StatefulWidget {
  const addPostPage({Key? key}) : super(key: key);

  @override
  State<addPostPage> createState() => _addPostPageState();
}

class _addPostPageState extends State<addPostPage> {
  HtmlEditorController titleController = HtmlEditorController();
  HtmlEditorController bodyController = HtmlEditorController();
  late String title = "", tags = "", body = "";

  @override
  void initState() {
    super.initState();
  }

  late List<TagLanguage> _selectedTags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ui.Text('Create New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: HtmlEditor(
                controller: titleController, //required
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: "Title",
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.belowEditor),
                otherOptions: const OtherOptions(
                  height: 100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: HtmlEditor(
                controller: bodyController, //required
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: "What are the details of your problem?",
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.belowEditor),
                otherOptions: const OtherOptions(
                  height: 250,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterTagging<TagLanguage>(
                initialItems: _selectedTags,
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.green.withAlpha(30),
                    hintText: 'Search Tags (upto five tags)',
                    labelText: 'Select Tags',
                  ),
                ),
                findSuggestions: APIService.getAllSearchParams,
                configureSuggestion: (lang) {
                  return SuggestionConfiguration(
                    title: Text(lang.name),
                    additionWidget: const Chip(
                      avatar: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      label: Text('Add New Tag'),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                configureChip: (lang) {
                  return ChipConfiguration(
                    label: Text(lang.name),
                    backgroundColor: Colors.green,
                    labelStyle: const TextStyle(color: Colors.white),
                    deleteIconColor: Colors.white,
                  );
                },
                onChanged: () {
                  if (_selectedTags.length > 5) {
                    setState(() {
                      _selectedTags.removeLast();
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const ui.Text("Post your question"),
              onPressed: () async {
                tags = '';
                if (_selectedTags.isNotEmpty) {
                  for (var i = 0; i < _selectedTags.length; i++) {
                    tags += '<${_selectedTags[i].name}>';
                  }
                }
                await bodyController.getText().then((value) async {
                  body = value;
                  await titleController.getText().then((value) {
                    title = value;
                  });
                });
                APIService.updatePost(-1, title, body, tags).then((value) {
                  Navigator.pop(context);
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       content: SingleChildScrollView(
                  //         child: ListBody(
                  //           children: const <Widget>[
                  //             Text('Post created successfully.'),
                  //           ],
                  //         ),
                  //       ),
                  //       actions: <Widget>[
                  //         TextButton(
                  //           child: const Text('OK'),
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //             Navigator.pushReplacementNamed(context, "/editposts");
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
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
  );

// Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success"),
    content: Text("Question posted successfully."),
    actions: [
      okButton,
    ],
  );

// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
