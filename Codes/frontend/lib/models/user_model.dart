class UserModel {
  late int id, accountId, reputation, views, downVotes, upVotes;
  late String displayName,
      location,
      profileImageUrl,
      websiteUrl,
      aboutMe,
      creationDate,
      lastAccessDate;

  UserModel({
    required this.id,
    required this.accountId,
    required this.reputation,
    required this.views,
    required this.downVotes,
    required this.upVotes,
    required this.displayName,
    required this.location,
    required this.profileImageUrl,
    required this.websiteUrl,
    required this.aboutMe,
    required this.creationDate,
    required this.lastAccessDate,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    accountId = data["account_id"];
    reputation = data["reputation"];
    views = data["views"];
    downVotes = data["down_votes"];
    upVotes = data["up_votes"];
    displayName = data["display_name"];
    location = data["location"] ?? '';
    profileImageUrl = data["profile_image_url"] ?? '';
    websiteUrl = data["website_url"] ?? '';
    aboutMe = data["about_me"] ?? '';
    creationDate = data["creation_date"];
    lastAccessDate = data["last_access_date"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["id"] = id;
    data["account_id"] = accountId;
    data["reputation"] = reputation;
    data["views"] = views;
    data["down_votes"] = downVotes;
    data["up_votes"] = upVotes;
    data["display_name"] = displayName;
    data["location"] = location;
    data["profile_image_url"] = profileImageUrl;
    data["website_url"] = websiteUrl;
    data["about_me"] = aboutMe;
    data["creation_date"] = creationDate;
    data["last_access_date"] = lastAccessDate;
    return data;
  }
}
