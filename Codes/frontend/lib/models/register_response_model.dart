import 'dart:convert';

RegisterResponseModel registerResponseJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.message,
    required this.data,
  });

  late final String message;
  late final Data data;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = Data.fromJson(json['data']);
    // data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.toJson();
    // _data['data'] = data!.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.username,
    required this.location,
    required this.aboutMe,
    required this.date,
    required this.id,
  });

  late final String username;
  late final String location;
  late final String aboutMe;
  late final String date;
  late final String id;

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    location = json['location'];
    aboutMe = json['aboutMe'];
    date = json['date'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['location'] = location;
    _data['aboutMe'] = aboutMe;
    _data['date'] = date;
    _data['id'] = id;
    return _data;
  }
}
