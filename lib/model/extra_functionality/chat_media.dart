class ChatMedia {
  late int id;
  late String name;
  late String location;
  late String mimeType;
  late int size;
  bool isDownloading = false;
  bool isDownloaded = false;

  ChatMedia() {
    id = 0;
    size = 0;
    name = '';
    location = '';
    mimeType = '';
    isDownloaded = false;
    isDownloading = false;
  }

  ChatMedia.init({
    required this.id,
    required this.name,
    required this.location,
    required this.mimeType,
    required this.size,
  });

  static List<ChatMedia> fromJsonList(List<dynamic>? jsonValue) {
    List<ChatMedia> mediaList = List.empty(growable: true);
    if (jsonValue != null) {
      for (var value in jsonValue) {
        mediaList.add(ChatMedia.fromJson(value));
      }
    }
    return mediaList;
  }

  ChatMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    location = json['location'] as String;
    mimeType = json['mimeType'] as String;
    size = json['size'] as int;
    isDownloading = json['IsDownloading'] as bool? ?? false;
    isDownloaded = json['IsDownloaded'] as bool? ?? false;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
      'mimeType': mimeType,
      'size': size,
      'isDownloading': isDownloading,
      'isDownloaded': isDownloaded,
    };
  }
}
