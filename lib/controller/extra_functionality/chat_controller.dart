import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_sample/Utils/Utility.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/extra_functionality/chat_message.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:mime/mime.dart';

import 'event_bus.dart';

class ChatController with ChangeNotifier {
  List<types.Message> messages = List.empty(growable: true);
  final String _tableChat = 'chatTable';
  late final AppUser _currentUser;
  late final AppUser _otherUser;
  late StreamSubscription<ChatMessageEvent> subscription;

  @override
  void dispose() {
    subscription.cancel();
    messages.clear();
    super.dispose();
  }

  ChatController(this._otherUser) {
    _currentUser = AppUser.fromJson(json.decode(PreferenceController.getString(
        PreferenceController.prefKeyUserPayload)));
    subscription = eventBus.on<ChatMessageEvent>().listen((event) {
      if (event.message.data['notificationType'] ==
          AppConstants.messageTypeText) {
        Map<String, dynamic> jsonData = Map<String, dynamic>.from(
            json.decode(event.message.data['notificationPayload']));
        ChatMessage temp = ChatMessage.fromJson(jsonData);
        types.TextMessage msg1 = types.TextMessage(
            author: types.User(
                firstName: temp.senderName,
                id: temp.senderId.toString(),
                imageUrl: temp.imageUrl),
            id: temp.id,
            text: temp.message!,
            createdAt: temp.insertedOn);
        messages.insert(0, msg1);
        notifyListeners();
      } else if (event.message.data['notificationType'] ==
          AppConstants.messageTypeImage) {
        Map<String, dynamic> jsonData = Map<String, dynamic>.from(
            json.decode(event.message.data['notificationPayload']));
        ChatMessage temp = ChatMessage.fromJson(jsonData);

        String fileName = temp.media!.location
            .substring(temp.media!.location.lastIndexOf('/') + 1);
        // fileName = fileName.substring(0, fileName.lastIndexOf('.'));
        ApiController.downloadAndSaveFile(temp.media!.location, fileName,
                isPermanentStore: true)
            .then((path) async {
          File file = File(path);
          final bytes = await file.readAsBytes();
          final image = await decodeImageFromList(bytes);
          final message = types.ImageMessage(
            author: types.User(
                id: temp.senderId.toString(),
                firstName: temp.senderName,
                imageUrl: temp.imageUrl),
            createdAt: temp.insertedOn,
            id: temp.id.toString(),
            height: image.height.toDouble(),
            name: file.path,
            size: bytes.length,
            uri: file.path,
            width: image.width.toDouble(),
          );
          messages.insert(0, message);
          notifyListeners();
        });
      } else if (event.message.data['notificationType'] ==
          AppConstants.messageTypeFile) {
        Map<String, dynamic> jsonData = Map<String, dynamic>.from(
            json.decode(event.message.data['notificationPayload']));
        ChatMessage temp = ChatMessage.fromJson(jsonData);

        String fileName = temp.media!.location
            .substring(temp.media!.location.lastIndexOf('/') + 1);
        // fileName = fileName.substring(0, fileName.lastIndexOf('.'));
        ApiController.downloadAndSaveFile(temp.media!.location, fileName,
                isPermanentStore: true)
            .then((path) async {
          File file = File(path);
          final message = types.FileMessage(
            author: types.User(
                id: temp.senderId.toString(),
                firstName: temp.senderName,
                imageUrl: temp.imageUrl),
            type: MessageType.file,
            createdAt: temp.insertedOn,
            id: temp.id.toString(),
            mimeType: lookupMimeType(path),
            name: fileName,
            size: await file.length(),
            uri: path,
          );
          messages.insert(0, message);
          notifyListeners();
        });
      }
    });
    getAll();
  }
  void send(PartialText message) async {
    final msg1 = types.TextMessage(
        author: types.User(
            firstName: _currentUser.name,
            id: _currentUser.id.toString(),
            //imageUrl: _currentUser.profileImage?? ''),
            imageUrl: _currentUser.profileImage),
        id: Utility.getRandomString(),
        text: message.text,
        createdAt: 10000);

    ChatMessage msg = ChatMessage.parseFromMessage(
      _currentUser.id,
      _otherUser.id,
      msg1,
    );
    msg.senderName = _currentUser.name;
    msg.imageUrl = _currentUser.profileImage;
    await ApiController.post(AppConstants.endpointSendMessage, json.encode(msg))
        .then((response) {
      if (response.status == 0) {
        Map<String, dynamic> jsonData =
            Map<String, dynamic>.from(json.decode(json.encode(response.data)));

        ChatMessage temp = ChatMessage.fromJson(jsonData);
        messages.insert(
            0,
            types.TextMessage(
                author: types.User(
                    firstName: _currentUser.name,
                    id: _currentUser.id.toString(),
                    imageUrl: _currentUser.profileImage),
                id: temp.id.toString(),
                text: message.text,
                createdAt: temp.insertedOn));
        notifyListeners();
      }
    });
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    messages.indexWhere((element) => element.id == message.id);
    // final updatedMessage = messages[index].copyWith(previewData: previewData);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  static Future<dynamic> addData(
      String table, Map<String, dynamic> body) async {
    try {
      final value =
          await FirebaseFirestore.instance.collection(table).add(body);
      return value;
    } catch (e) {
      return '';
    }
  }

  Future<void> getAll() async {
    try {
      await ApiController.post(
              AppConstants.endpointGetMessage,
              json.encode(
                  {'senderId': _currentUser.id, 'receiverId': _otherUser.id}))
          .then((response) {
        if (response.status == 0) {
          final result = json.decode(json.encode(response.data));

          for (int i = 0; i < result.length; i++) {
            print(
                'date value=>${json.decode(json.encode(result[i]))['insertedOn']}');
            ChatMessage temp =
                ChatMessage.fromJson(json.decode(json.encode(result[i])));
            if (temp.messageType == AppConstants.messageTypeText) {
              types.TextMessage msg1 = types.TextMessage(
                  author: types.User(
                      firstName: temp.senderName,
                      id: temp.senderId.toString(),
                      imageUrl: temp.imageUrl),
                  id: temp.id.toString(),
                  text: temp.message!,
                  createdAt: temp.insertedOn);
              messages.insert(0, msg1);
            } else {
              messages.insert(0, ChatMessage.parseFromChatMessage(temp));
            }
          }
          notifyListeners();
        } else {}
      });
      return;

      /*  final data = await FirebaseFirestore.instance
          .collection(_tableChat)
          // .where("SenderId", isEqualTo: 101)
          // .where("ReceiverId", isEqualTo: 102)
          .get();
      final List<DocumentSnapshot> documents = data.docs;
      if (documents.isNotEmpty) {
        documents.map((doc) => doc.data()).forEach((element) {
          ChatMessage temp =
              ChatMessage.fromJson(json.decode(json.encode(element)));
          if (temp.messageType == AppConstants.messageTypeText) {
            types.TextMessage msg1 = types.TextMessage(
                author: types.User(
                    firstName: temp.senderName,
                    id: temp.senderId.toString(),
                    imageUrl: temp.imageUrl),
                id: Utility.getRandomString(),
                text: temp.message!,
                createdAt: temp.insertedOn);
            messages.insert(0, msg1);
          } else {
            messages.insert(0, ChatMessage.parseFromChatMessage(temp));
          }
        });
        messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      } else {}
      */
    } catch (e) {}
    notifyListeners();
  }

  Future<void> deleteAllData() async {
    try {
      FirebaseFirestore.instance.collection(_tableChat).get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {}
    notifyListeners();
  }

  void handleAttachmentPressed(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    await _handleImageSelection(context);
                    Navigator.pop(context);
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleFileSelection() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowCompression: false);

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: types.User(
            id: _currentUser.id.toString(),
            firstName: _currentUser.name,
            imageUrl: _currentUser.profileImage),
        type: MessageType.file,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: Utility.getRandomString(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      /* final msg = ChatMessage.init(
          id: Utility.getRandomString(),
          senderId: _currentUser.id,
          receiverId: _otherUser.id,
          messageType: AppConstants.messageTypeFile,
          status: '',
          insertedOn: ChatMessage.getEpochTime(DateTime.now().toUtc()),
          media: ChatMedia.init(
              id: 101,
              name: _currentUser.name,
              location: result.files.single.path!,
              mimeType: lookupMimeType(result.files.single.path!)!,
              size: result.files.single.size));
      msg.senderName = _currentUser.name;
      msg.imageUrl = _currentUser.profileImage;*/

      Map<String, String> msgDetail = <String, String>{};
      msgDetail['senderId'] = _currentUser.id;
      msgDetail['receiverId'] = _otherUser.id;
      msgDetail['messageType'] = AppConstants.messageTypeFile;
      msgDetail['message'] = 'hello';

      await ApiController.postFormData(AppConstants.endpointSendMessage,
              result.files.single.path!, msgDetail)
          .then((response) {
        if (response.status == 0) {
          messages.insert(0, message);
          notifyListeners();
        }
      });

      // addData(_tableChat, msg.toJson());
    }
  }

  Future<void> _handleImageSelection(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowCompression: false);

    if (result != null) {
      File file = File(result.files.single.path!);

      if ((await file.length() / 1024) > 500) {
        Utility.showSnackBar(context, 'File size must be less than 500kb');
        return;
      }

      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = types.ImageMessage(
        author: types.User(
            id: _currentUser.id.toString(),
            firstName: _currentUser.name,
            imageUrl: _currentUser.profileImage),
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        id: Utility.getRandomString(),
        height: image.height.toDouble(),
        name: file.path,
        size: bytes.length,
        uri: file.path,
        width: image.width.toDouble(),
      );

      Map<String, String> msgDetail = <String, String>{};
      msgDetail['senderId'] = _currentUser.id;
      msgDetail['receiverId'] = _otherUser.id;
      msgDetail['messageType'] = AppConstants.messageTypeImage;
      msgDetail['message'] = 'hello';
      /*
      final msg = ChatMessage.init(
          id: Utility.getRandomString(),
          senderId: _currentUser.id,
          receiverId: _otherUser.id,
          messageType: messageTypeImage,
          status: '',
          insertedOn: ChatMessage.getEpochTime(DateTime.now().toUtc()),
          media: ChatMedia.init(
              id: 101,
              name: _currentUser.name,
              location: result.files.single.path!,
              mimeType: lookupMimeType(result.files.single.path!)!,
              size: result.files.single.size));
      msg.senderName = _currentUser.name;
      msg.imageUrl = _currentUser.profileImage;*/
      await ApiController.postFormData(AppConstants.endpointSendMessage,
              result.files.single.path!, msgDetail)
          .then((response) {
        if (response.status == 0) {
          messages.insert(0, message);
          notifyListeners();
        }
      });

      //  addData(_tableChat, msg.toJson());
    }
  }

  Future<void> downloadFile(BuildContext context, String msgId) async {
    final fileUrl = json
        .decode(json.encode(messages[
            messages.indexWhere((element) => element.id == msgId)]))['uri']
        .toString();
    await ApiController.downloadAndSaveFile(
            fileUrl, fileUrl.substring(fileUrl.lastIndexOf('/') + 1),
            isPermanentStore: true)
        .then((value) {
      Utility.showSnackBar(context, 'file downloaded', isSuccess: true);
    });
  }
}
