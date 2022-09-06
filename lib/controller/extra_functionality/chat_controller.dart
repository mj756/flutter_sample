import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/extra_functionality/chat_media.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mime/mime.dart';
import '../../../Utils/Utility.dart';
import '../../model/extra_functionality/chat_message.dart';
import 'event_bus.dart';

class ChatController with ChangeNotifier {
  List<types.Message> messages =
        List.empty(growable: true);
  final String _tableChat = 'chatTable';
  late AppUser _currentUser;
  late AppUser _otherUser;
  late StreamSubscription<ChatMessageEvent> subscription;
  @override
  void dispose() {
    print('chat controller disposed');
    subscription.cancel();
    messages.clear();
    super.dispose();
  }


  ChatController(this._otherUser) {
    _currentUser = AppUser.fromJson(json.decode(PreferenceController.getString(
        PreferenceController.prefKeyUserPayload)));
    subscription=eventBus.on<ChatMessageEvent>().listen((event) {
      if (event.message.data['notificationType'] == Utility.MESSAGE_TYPE_TEXT) {
        Map<String, dynamic> jsonData = Map<String, dynamic>.from(
            json.decode(event.message.data['notificationPayload']));
        ChatMessage temp = ChatMessage.fromJson(jsonData);
        types.TextMessage msg1 = types.TextMessage(
            author: types.User(
                firstName: temp.senderName,
                id: temp.senderId.toString(),
                imageUrl: temp.imageUrl),
            id: Utility.getRandomString(),
            text: temp.message!,
            createdAt: temp.insertedOn.toLocal().millisecondsSinceEpoch);
        messages.insert(0, msg1);
        notifyListeners();
      }
    });
  }
  void send(PartialText message) async{
    final msg1 = types.TextMessage(
        author: types.User(
            firstName: _currentUser.name,
            id: _currentUser.id.toString(),
            //imageUrl: _currentUser.profileImage?? ''),
            imageUrl: 'https://picsum.photos/200/300'),
        id: Utility.getRandomString(),
        text: message.text,
        createdAt:
        (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor());

    ChatMessage msg =
    ChatMessage.parseFromMessage(_currentUser.id, _otherUser.id, msg1);
    msg.senderName = _currentUser.name;
   // msg.imageUrl = _currentUser.profileImage;
    msg.imageUrl = 'https://picsum.photos/200/300';

    await ApiController.sendPushChatMessage(msg.toJson(),_otherUser.token).then((value) async {
    await addData(_tableChat, msg.toJson());
    messages.insert(0, msg1);
    notifyListeners();
    });
  }
  void handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = messages.indexWhere((element) => element.id == message.id);
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
      final data = await FirebaseFirestore.instance
          .collection(_tableChat)
      // .where("SenderId", isEqualTo: 101)
      // .where("ReceiverId", isEqualTo: 102)
          .get();
      final List<DocumentSnapshot> documents = data.docs;
      if (documents.isNotEmpty) {
        documents.map((doc) => doc.data()).forEach((element) {
          ChatMessage temp =
          ChatMessage.fromJson(json.decode(json.encode(element)));
          if (temp.messageType == Utility.MESSAGE_TYPE_TEXT) {
            types.TextMessage msg1 = types.TextMessage(
                author: types.User(
                    firstName: temp.senderName,
                    id: temp.senderId.toString(),
                    imageUrl: temp.imageUrl),
                id: Utility.getRandomString(),
                text: temp.message!,
                createdAt: temp.insertedOn.toLocal().millisecondsSinceEpoch*1000);
            messages.insert(0, msg1);
          } else {

            messages.insert(0,ChatMessage.parseFromChatMessage(temp));
          }
        });
        messages.sort((a,b)=>b.createdAt!.compareTo(a.createdAt!));
      }
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
    } catch (e) {
      print(e);
    }
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
                    Navigator.pop(context);
                    await _handleImageSelection();
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: types.User(
            id: _currentUser.name.toString(),
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
      messages.insert(0, message);
      final msg = ChatMessage.init(
          uuid: Utility.getRandomString(),
          senderId: _currentUser.id,
          receiverId: 102,
          messageType: Utility.MESSAGE_TYPE_FILE,
          status: '',
          insertedOn: DateTime.now().toUtc(),
          media: ChatMedia.init(
              id: 101,
              name: _currentUser.name,
              location: result.files.single.path!,
              mimeType: lookupMimeType(result.files.single.path!)!,
              size: result.files.single.size));
      msg.senderName = _currentUser.name;
      msg.imageUrl = _currentUser.profileImage;
      addData(_tableChat, msg.toJson());
    }
  }

  Future<void> _handleImageSelection() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = types.ImageMessage(
        author: types.User(
            id: _currentUser.id
                .toString(),
            firstName: _currentUser.name,
            imageUrl: _currentUser.profileImage),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: Utility.getRandomString(),
        name: file.path,
        size: bytes.length,
        uri: file.path,
        width: image.width.toDouble(),
      );
      messages.insert(0, message);

      final msg = ChatMessage.init(
          uuid: Utility.getRandomString(),
          senderId: _currentUser.id,
          receiverId: 102,
          messageType: Utility.MESSAGE_TYPE_IMAGE,
          status: '',
          insertedOn: DateTime.now().toUtc(),
          media: ChatMedia.init(
              id: 101,
              name: _currentUser.name,
              location: result.files.single.path!,
              mimeType: lookupMimeType(result.files.single.path!)!,
              size: result.files.single.size));
      msg.senderName = _currentUser.name;
      msg.imageUrl = _currentUser.profileImage;
      addData(_tableChat, msg.toJson());
    }
  }
}
