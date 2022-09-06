import 'dart:convert';
import 'dart:math';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mime/mime.dart';
import '../../Utils/Utility.dart';
import 'chat_media.dart';

class ChatMessage {
  late String uuid;
  late int senderId;
  late String senderName;
  late String imageUrl;
  late int receiverId;
  late String messageType;
  late String status;

  String? message;
  late DateTime insertedOn;
  bool isDelivered = false;
  bool isRead = false;
  bool isDeleted = false;
  ChatMedia? media;


  ChatMessage();

  ChatMessage.init({
    required this.uuid,
    required this.senderId,
    required this.receiverId,
    required this.messageType,
    required this.status,
    this.message,
    required this.insertedOn,
    this.isDelivered = false,
    this.isRead = false,
    this.isDeleted = false,
    this.media,
  });

  static List<ChatMessage> fromJsonList(List<dynamic>? jsonValue) {
    List<ChatMessage> chatMessageList = List.empty(growable: true);
    if (jsonValue != null) {
      for (var value in jsonValue) {
        chatMessageList.add(ChatMessage.fromJson(value));
      }
    }
    return chatMessageList;
  }

  static String? _mediaToJson(ChatMedia? media) =>
      media != null ? jsonEncode(media.toJson()) : null;

  static ChatMedia? _mediaFromJson(Object? json) {
    if (json != null) {
      if (json is Map<String, dynamic>) {
        return ChatMedia.fromJson(json);
      } else if (json is String) {
        return ChatMedia.fromJson(jsonDecode(json));
      }
    }

    return null;
  }

  static ChatMessage parseFromMessage(int senderId, int receiverId,
      types.Message message) {
    ChatMessage chatMessage = ChatMessage();

    chatMessage.uuid = message.id;
    chatMessage.senderId = senderId;
    chatMessage.receiverId = receiverId;
    chatMessage.status = getStringFromStatus(message.status);
    chatMessage.insertedOn = Utility.getEpochToDate(message.createdAt!).toUtc();
    if (message is types.TextMessage) {
      /// Text message parsing
      chatMessage.messageType = Utility.MESSAGE_TYPE_TEXT;
      chatMessage.message = message.text;
    } else if (message is types.ImageMessage) {
      /// Image message parsing
      chatMessage.messageType = Utility.MESSAGE_TYPE_IMAGE;
      chatMessage.media = ChatMedia.init(
          id: Random().nextInt(10000),
          name: message.name,
          location: message.uri,
          mimeType: lookupMimeType(message.uri) ?? "image/jpeg",
          size: int.parse(message.size.toString()));
    } else if (message is types.FileMessage) {
      /// File message parsing
      chatMessage.messageType = Utility.MESSAGE_TYPE_FILE;
      chatMessage.media = ChatMedia.init(
          id: Random().nextInt(10000),
          name: message.name,
          location: message.uri,
          mimeType: lookupMimeType(message.uri) ?? "image/jpeg",
          size: int.parse(message.size.toString()));
    }

    return chatMessage;
  }

  static types.Message parseFromChatMessage(ChatMessage chatMessage) {
    if (chatMessage.messageType == Utility.MESSAGE_TYPE_IMAGE &&
        chatMessage.media != null) {
      /// Image message parsing
      return types.ImageMessage.fromPartial(
        author: types.User(id: chatMessage.senderId.toString(), imageUrl: ""),
        id: chatMessage.uuid,
        status: getStatusFromString(chatMessage.status),
        createdAt:
        Utility.getEpochTime(Utility.parseToLocal(chatMessage.insertedOn))*1000,
        partialImage: types.PartialImage(
          name: chatMessage.media!.name,
          uri: chatMessage.media!.location,
          size: chatMessage.media!.size,
        ),
      );
    } else if (chatMessage.messageType == Utility.MESSAGE_TYPE_FILE &&
        chatMessage.media != null) {
      /// File message parsing
      return types.FileMessage.fromPartial(
        author: types.User(id: chatMessage.senderId.toString(), imageUrl: ""),
        id: chatMessage.uuid,
        status: getStatusFromString(chatMessage.status),
        createdAt:
        Utility.getEpochTime(Utility.parseToLocal(chatMessage.insertedOn))*1000,
        partialFile: types.PartialFile(
          name: chatMessage.media!.name,
          uri: chatMessage.media!.location,
          size: chatMessage.media!.size,
          mimeType: chatMessage.media!.mimeType,
        ),
      );
    }

    /// Text message parsing
    return types.TextMessage.fromPartial(
      author: types.User(id: chatMessage.senderId.toString(), imageUrl: ""),
      id: chatMessage.uuid,
      status: getStatusFromString(chatMessage.status),
      createdAt:
      Utility.getEpochTime(Utility.parseToLocal(chatMessage.insertedOn))*1000,
      partialText: types.PartialText(text: chatMessage.message ?? ''),
    );
  }

  static types.Status? getStatusFromString(String? stringStatus) {
    for (final status in types.Status.values) {
      if (status.toString() == 'Status.$stringStatus') {
        return status;
      }
    }
    return null;
  }

  static String getStringFromStatus(types.Status? status) {
    return status != null ? status.toString().split(".")[1] : "";
  }


  ChatMessage.fromJson(Map<String, dynamic> json) {
    uuid = json['Uuid'] as String;
    senderId = json['SenderId'] as int;
    senderName = json['SenderName'] as String;
    imageUrl= json['ImageUrl'] as String;
    receiverId = json['ReceiverId'] as int;
    messageType = json['MessageType'] as String;
    status = json['Status'] as String;
    message = Utility.utf8Decode(json['Message'] as String?);
    insertedOn = DateTime.parse(json['InsertedOn'] as String);
    isDelivered = Utility.boolFromJson(json['IsDelivered']);
    isRead = Utility.boolFromJson(json['IsRead']);
    isDeleted = Utility.boolFromJson(json['IsDeleted']);
    media = ChatMessage._mediaFromJson(json['Media']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> test =
    {
      'Uuid': '',
      'SenderId': senderId,
      'ReceiverId': receiverId,
      'MessageType': messageType,
      'Status': status,
      'Message': message,
      'InsertedOn': insertedOn.toIso8601String(),
      'IsDelivered': Utility.boolToJson(isDelivered),
      'IsRead': Utility.boolToJson(isRead),
      'IsDeleted': Utility.boolToJson(isDeleted),
      'Media': ChatMessage._mediaToJson(media),
      'SenderName':senderName,
      'ImageUrl': imageUrl
    };
    return test;
  }
}
