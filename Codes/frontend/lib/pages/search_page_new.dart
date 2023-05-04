import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/pages/search_results.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/shared_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<TagLanguage> _selectedTags = [];
  late List<UserLanguage> _selectedUser = [];
  final List<String> _dropDownOptions = ['None', 'Ascending', 'Descending'];
  late int _timeSort = -1;
  late int _upvoteSort = -1;
  late List<PostModel> _posts = [];
  final int _pageSize = 20;
  late String dropdownValueTime = _dropDownOptions.first;
  late String dropdownValueUpvotes = _dropDownOptions.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedService.checkSession(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
      ),
      body: Column(
        children: <Widget>[
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlutterTagging<UserLanguage>(
              initialItems: _selectedUser,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.green.withAlpha(30),
                  hintText: 'Search User (at most one user)',
                  labelText: 'Select User',
                ),
              ),
              findSuggestions: APIService.getAllUsers,
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
                if (_selectedUser.length > 1) {
                  setState(() {
                    _selectedUser.removeLast();
                  });
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Sort by time: "),
              ),
              DropdownButton<String>(
                value: dropdownValueTime,
                items: _dropDownOptions
                    .map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (String? val) {
                  setState(() {
                    dropdownValueTime = val!;
                    _timeSort = _dropDownOptions.indexOf(val) - 1;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Sort by upvotes: "),
              ),
              DropdownButton<String>(
                value: dropdownValueUpvotes,
                items: _dropDownOptions
                    .map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (String? val) {
                  setState(() {
                    dropdownValueUpvotes = val!;
                    _upvoteSort = _dropDownOptions.indexOf(val) - 1;
                  });
                },
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResults(
                          selectedTags: _selectedTags,
                          selectedUser: _selectedUser,
                          timeSort: _timeSort,
                          upvoteSort: _upvoteSort),
                      settings: const RouteSettings(
                        name: '/results',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                tooltip: "Search!",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
