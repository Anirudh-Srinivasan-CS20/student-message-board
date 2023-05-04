import 'dart:async';
import 'dart:convert';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:frontend/models/comment_model.dart';
import 'package:frontend/models/post_model.dart';
import 'shared_service.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/login_request_model.dart';
import 'package:frontend/models/login_response_model.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    var url = Uri.http(Config.apiURL, Config.loginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return true;
    }
    return false;
  }

  static Future<UserModel> getCurrentUser() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    int id = await SessionManager().get("id");
    var url = Uri.http(Config.apiURL, "/users/$id");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    Map<String, dynamic> map = Map.from(json.decode(response.body)[0]);
    return UserModel.fromJson(map);
  }

  static Future<UserModel> getUser(int id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var url = Uri.http(Config.apiURL, "/users/$id");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    Map<String, dynamic> map = Map.from(json.decode(response.body)[0]);
    return UserModel.fromJson(map);
  }

  static Future<bool> createUser(
    String name,
    String loc,
    String about,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var url = Uri.http(Config.apiURL, "/createuser");

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "name": name,
        "location": loc,
        "about_me": about,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<List<CommentModel>> getComments(int id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    var url = Uri.http(Config.apiURL, "/post/$id/comments");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    Iterable it = json.decode(response.body);
    List<CommentModel> comments =
        List<CommentModel>.from(it.map((e) => CommentModel.fromJson(e)));
    return comments;
  }

  // Obtain ALL tags
  static FutureOr<List<TagLanguage>> getAllSearchParams(String query) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var url = Uri.http(Config.apiURL, "/tagsearch");

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({"part": query}),
    );
    Iterable it = json.decode(response.body);
    List<TagLanguage> listRet =
        List<TagLanguage>.from(it.map((e) => TagLanguage.fromJson(e)));
    return listRet;
  }

  // Obtain ALL matching users
  static FutureOr<List<UserLanguage>> getAllUsers(String query) async {
    if (query.length <= 2) return <UserLanguage>[];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var url = Uri.http(Config.apiURL, "/usersearch");

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode({"part": query}));
    Iterable it = json.decode(response.body);
    List<UserLanguage> listRet =
        List<UserLanguage>.from(it.map((e) => UserLanguage.fromJson(e)));
    return listRet;
  }

  // Obtain ALL matching questions and return them in order
  static Future<List<PostModel>> searchPosts(
    List<UserLanguage> user,
    List<TagLanguage> tags,
    int timeOrder,
    int upvoteOrder,
    int lim,
    int off,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var url = Uri.http(Config.apiURL, "/postsearch");
    String uname = (user.isNotEmpty) ? user[0].name : "";
    List<String> tagname = tags.map((e) => (e.name)).toList();
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "uname": uname,
          "tags": tagname,
          "timesort": timeOrder,
          "upsort": upvoteOrder,
          "limit": lim,
          "offset": off,
        },
      ),
    );
    Iterable it = json.decode(response.body);
    List<PostModel> result =
        List<PostModel>.from(it.map((e) => PostModel.fromJson(e)));
    return result;
  }

  static Future<dynamic> deleteComment(int id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    var url = Uri.http(Config.apiURL, "/deletecomment/$id");

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<dynamic> updateComment(
    int commentId,
    String text,
    int postId,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    var url = Uri.http(Config.apiURL, "/updatecomment");
    await SessionManager().get("id").then(
      (value) async {
        var response = await client.put(
          url,
          headers: requestHeaders,
          body: jsonEncode({
            "text": text,
            "user_id": value,
            "post_id": postId,
            "id": commentId,
          }),
        );
        if (response.statusCode == 200) {
          return true;
        }
        return false;
      },
    );
  }

  static Future<dynamic> deletePost(int id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    var url = Uri.http(Config.apiURL, "/deletepost/$id");

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<dynamic> updatePost(
    int id,
    String title,
    String body,
    String tags,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    var url = Uri.http(Config.apiURL, "/updatepost");
    int userid = await SessionManager().get("id");

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "title": title,
        "body": body,
        "tags": tags,
        "owner_user_id": userid,
        "post_id": id,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<List<PostModel>> getUserPosts(int pageSize, int pageKey) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    int id = await SessionManager().get("id");

    var url = Uri.http(Config.apiURL, "/users/$id/posts");

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "offset": pageKey,
        "limit": pageSize,
      }),
    );

    Iterable it = json.decode(response.body);
    List<PostModel> result =
        List<PostModel>.from(it.map((e) => PostModel.fromJson(e)));
    return result;
  }

  static Future<List<CommentModel>> getUserComments(
      int pageSize, int pageKey) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    int id = await SessionManager().get("id");

    var url = Uri.http(Config.apiURL, "/users/$id/comments");

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "offset": pageKey,
        "limit": pageSize,
      }),
    );

    Iterable it = json.decode(response.body);
    List<CommentModel> result =
        List<CommentModel>.from(it.map((e) => CommentModel.fromJson(e)));
    return result;
  }

  static Future<int> getNumPosts() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    // int id = await SessionManager().get("id");

    var url = Uri.http(Config.apiURL, "/countposts");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    Iterable it = json.decode(response.body);
    return int.parse(it.first["count"]);
  }
}

/// Tag Language Class
class TagLanguage extends Taggable {
  ///
  late String name;

  /// Creates Language
  TagLanguage({
    required this.name,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
  }''';

  TagLanguage.fromJson(Map<String, dynamic> data) {
    name = data["name"];
  }
}

// User Language Class
class UserLanguage extends Taggable {
  ///
  late String name;

  /// Creates Language
  UserLanguage({
    required this.name,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
  }''';

  UserLanguage.fromJson(Map<String, dynamic> data) {
    name = data["name"];
  }
}
