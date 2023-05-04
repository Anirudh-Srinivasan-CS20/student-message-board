class PostModel {
  late int id,
      ownerUserId,
      lastEditorUserId,
      postTypeId,
      acceptedAnswerId,
      score,
      parentId,
      viewCount,
      answerCount,
      commentCount,
      favoriteCount;
  late String title,
      tags,
      ownerDisplayName,
      lastEditorDisplayName,
      contentLicense,
      body,
      creationDate,
      communityOwnedDate,
      closedDate,
      lastEditDate,
      lastActivityDate,
      actualDisplayName;

  PostModel({
    required this.id,
    required this.ownerUserId,
    required this.lastEditorUserId,
    required this.postTypeId,
    required this.acceptedAnswerId,
    required this.score,
    required this.parentId,
    required this.viewCount,
    required this.answerCount,
    required this.commentCount,
    required this.favoriteCount,
    required this.title,
    required this.tags,
    required this.ownerDisplayName,
    required this.lastEditorDisplayName,
    required this.contentLicense,
    required this.body,
    required this.creationDate,
    required this.communityOwnedDate,
    required this.closedDate,
    required this.lastEditDate,
    required this.lastActivityDate,
    required this.actualDisplayName,
  });

  PostModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    ownerUserId = data["owner_user_id"] ?? -1;
    lastEditorUserId = data["last_editor_user_id"] ?? -1;
    postTypeId = data["post_type_id"];
    acceptedAnswerId = data["accepted_answer_id"] ?? -1;
    score = data["score"];
    parentId = data["parent_id"] ?? -1;
    viewCount = data["view_count"] ?? 0;
    answerCount = data["answer_count"] ?? 0;
    commentCount = data["comment_count"];
    favoriteCount = data["favorite_count"] ?? 0;
    title = data["title"] ?? "(No Title)";
    tags = data["tags"] ?? "";
    ownerDisplayName = data["owner_display_name"] ?? "";
    lastEditorDisplayName = data["last_editor_display_name"] ?? "";
    contentLicense = data["content_license"];
    body = data["body"] ?? "";
    creationDate = data["creation_date"];
    communityOwnedDate = data["community_owned_date"] ?? "";
    closedDate = data["closed_date"] ?? "";
    lastEditDate = data["last_edit_date"] ?? "";
    lastActivityDate = data["last_activity_date"] ?? "";
    actualDisplayName = data["display_name"] ?? "[Deleted User]";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["id"] = id;
    data["owner_user_id"] = ownerUserId;
    data["last_editor_user_id"] = lastEditorUserId;
    data["post_type_id"] = postTypeId;
    data["accepted_answer_id"] = acceptedAnswerId;
    data["score"] = score;
    data["parent_id"] = parentId;
    data["view_count"] = viewCount;
    data["answer_count"] = answerCount;
    data["comment_count"] = commentCount;
    data["favorite_count"] = favoriteCount;
    data["title"] = title;
    data["tags"] = tags;
    data["owner_display_name"] = ownerDisplayName;
    data["last_editor_display_name"] = lastEditorDisplayName;
    data["content_license"] = contentLicense;
    data["body"] = body;
    data["creation_date"] = creationDate;
    data["community_owned_date"] = communityOwnedDate;
    data["closed_date"] = closedDate;
    data["last_edit_date"] = lastEditDate;
    data["last_activity_date"] = lastActivityDate;
    return data;
  }
}
