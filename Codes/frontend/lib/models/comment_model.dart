class CommentModel {
  late int id, postId, userId, score;
  late String contentLicense,
      actualDisplayName,
      userDisplayName,
      text,
      creationDate;

  CommentModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.score,
    required this.contentLicense,
    required this.userDisplayName,
    required this.actualDisplayName,
    required this.text,
    required this.creationDate,
  });

  CommentModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    userId = data["user_id"] ?? -1;
    score = data["score"];
    contentLicense = data["content_license"];
    text = data["text"];
    userDisplayName = data["user_display_name"] ?? "";
    creationDate = data["creation_date"];
    actualDisplayName = data["display_name"] ?? "[Deleted User]";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["id"] = id;
    data["user_id"] = userId;
    data["score"] = score;
    data["content_license"] = contentLicense;
    data["text"] = text;
    data["user_display_name"] = userDisplayName;
    data["creation_date"] = creationDate;
    return data;
  }
}
