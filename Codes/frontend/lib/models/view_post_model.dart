class ViewPostModel {
  late int id;
  late String title, tags, text;

  ViewPostModel({
    required this.id,
    required this.title,
    required this.tags,
    required this.text,
  });

  ViewPostModel.fromJson(Map<String, dynamic> data) {
    id = int.parse(data["id"]);
    title = data["title"];
    tags = data["tags"];
    text = data["text"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["id"] = id.toString();
    data["title"] = title;
    data["tags"] = tags;
    data["text"] = text;
    return data;
  }
}
