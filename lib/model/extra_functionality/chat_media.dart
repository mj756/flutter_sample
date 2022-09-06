class ChatMedia {
  late int id;
  late String name;
  late String location;
  late String mimeType;
  late int size;
  int? duration;
  List<double>? waveForm;
  bool isDownloading = false;
  bool isDownloaded = false;

  ChatMedia();

  ChatMedia.init(
      {required this.id,
        required this.name,
        required this.location,
        required this.mimeType,
        required this.size,
        this.duration,
        this.waveForm});

  static List<ChatMedia> fromJsonList(List<dynamic>? jsonValue) {
    List<ChatMedia> mediaList = List.empty(growable: true);
    if (jsonValue != null) {
      for (var value in jsonValue) {
        mediaList.add(ChatMedia.fromJson(value));
      }
    }
    return mediaList;
  }

  ChatMedia.fromJson(Map<String, dynamic> json){
    id = json['Id'] as int;
    name = json['Name'] as String;
    location = json['Location'] as String;
    mimeType = json['MimeType'] as String;
    size = json['Size'] as int;
    duration = json['Duration'] as int?;
    waveForm = (json['WaveForm'] as List<dynamic>?)
        ?.map((e) => (e as num).toDouble())
        .toList();
    isDownloading = json['IsDownloading'] as bool? ?? false;
    isDownloaded = json['IsDownloaded'] as bool? ?? false;
  }

  Map<String, dynamic> toJson()  {
    return <String, dynamic>{
      'Id': id,
      'Name': name,
      'Location': location,
      'MimeType': mimeType,
      'Size': size,
      'Duration': duration,
      'WaveForm': waveForm,
      'IsDownloading': isDownloading,
      'IsDownloaded': isDownloaded,
    };
  }
}
