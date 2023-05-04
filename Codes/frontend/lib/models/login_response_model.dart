import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.data,
  });

  late final int data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = data;
    return _data;
  }
}
