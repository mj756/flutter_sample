import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_sample/Utils/Utility.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:mime/mime.dart';

import 'chat_media.dart';

class ChatMessage {
  late String id;
  late String senderId;
  late String senderName;
  late String imageUrl;
  late String receiverId;
  late String messageType;
  late String status;
  String? message;
  late int insertedOn;
  bool isDelivered = false;
  bool isRead = false;
  bool isDeleted = false;
  ChatMedia? media;

  ChatMessage();

  ChatMessage.init({
    required this.id,
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

  static ChatMessage parseFromMessage(
      String senderId, String receiverId, types.Message message,
      {bool isUtcTime = true}) {
    ChatMessage chatMessage = ChatMessage();

    chatMessage.id = message.id;
    chatMessage.senderId = senderId;
    chatMessage.receiverId = receiverId;
    chatMessage.status = getStringFromStatus(message.status);
    chatMessage.insertedOn = message.createdAt!;
    if (message is types.TextMessage) {
      /// Text message parsing
      chatMessage.messageType = AppConstants.messageTypeText;
      chatMessage.message = message.text;
    } else if (message is types.ImageMessage) {
      /// Image message parsing
      chatMessage.messageType = AppConstants.messageTypeImage;
      chatMessage.media = ChatMedia.init(
          id: Random().nextInt(10000),
          name: message.name,
          location: message.uri,
          mimeType: lookupMimeType(message.uri) ?? "image/jpeg",
          size: int.parse(message.size.toString()));
    } else if (message is types.FileMessage) {
      /// File message parsing
      chatMessage.messageType = AppConstants.messageTypeFile;
    }
    return chatMessage;
  }

  static types.Message parseFromChatMessage(ChatMessage chatMessage) {
    if (chatMessage.messageType == AppConstants.messageTypeImage &&
        chatMessage.media != null) {
      /// Image message parsing
      return types.ImageMessage.fromPartial(
        author: types.User(id: chatMessage.senderId, imageUrl: ""),
        id: chatMessage.id,
        status: getStatusFromString(chatMessage.status),
        createdAt: chatMessage.insertedOn,
        partialImage: types.PartialImage(
          name: chatMessage.media!.name,
          uri: chatMessage.media!.location,
          size: chatMessage.media!.size,
        ),
      );
    } else if (chatMessage.messageType == AppConstants.messageTypeFile &&
        chatMessage.media != null) {
      /// File message parsing
      return types.FileMessage.fromPartial(
        author: types.User(id: chatMessage.senderId.toString(), imageUrl: ""),
        id: chatMessage.id,
        status: getStatusFromString(chatMessage.status),
        createdAt: chatMessage.insertedOn,
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
      id: chatMessage.id,
      status: getStatusFromString(chatMessage.status),
      createdAt: chatMessage.insertedOn,
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

  ChatMessage.fromJson(Map<String, dynamic> json, {bool isUtcTime = true}) {

    id = (json['id'] as int).toString();

    senderId = (json['senderId'] as int).toString();
    senderName = json['senderName'] as String;
    imageUrl = json['imageUrl'] as String;
    receiverId = (json['receiverId'] as int).toString();
    messageType = json['messageType'] as String;
    status = json['status'] as String;
    message = Utility.utf8Decode(json['message'] as String?);
    insertedOn = json['insertedOn'] as int;
    isDelivered = true;
    isRead = true;
    isDeleted = false;

    media = ChatMessage._mediaFromJson(json['media']);
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> test = {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageType': messageType,
      'status': status,
      'message': message,
      'insertedOn': insertedOn,
      'isDelivered': true,
      'isRead': true,
      'isDeleted': false,
      'media': ChatMessage._mediaToJson(media),
      'senderName': senderName,
      'imageUrl': imageUrl
    };
    return test;
  }

  static int getEpochTime(DateTime date, {bool needToConvert = true}) {
    if (needToConvert) {
      int value = date.isUtc
          ? (date.toLocal().millisecondsSinceEpoch)
          : (date.millisecondsSinceEpoch);
      return value;
    }
    return date.millisecondsSinceEpoch;
  }

  static DateTime getEpochToDate(int epochTime, bool isUtc) {
    return DateTime.fromMillisecondsSinceEpoch(epochTime * 1000, isUtc: isUtc);
  }
}
