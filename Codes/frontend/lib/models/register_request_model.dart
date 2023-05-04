class RegisterRequestModel {
  RegisterRequestModel({
    required this.username,
    required this.location,
    required this.aboutMe,
  });

  late final String username;
  late final String location;
  late final String aboutMe;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    location = json['location'];
    aboutMe = json['aboutMe'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['location'] = location;
    data['aboutMe'] = aboutMe;
    return data;
  }
}
