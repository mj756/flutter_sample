import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sample/controller/extra_functionality/chat_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/preference_controller.dart';
import '../../utils/constants.dart';

class ChatRoom extends StatelessWidget {
  final AppUser otherUser;

  const ChatRoom({Key? key, required this.otherUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = AppUser.fromJson(json.decode(
        PreferenceController.getString(
            PreferenceController.prefKeyUserPayload)));
    final user = User(
      firstName: currentUser.name,
      id: currentUser.id.toString(),
      imageUrl: currentUser.profileImage,
    );
    return ChangeNotifierProvider(
        create: (context) => ChatController(otherUser),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          Image.network(otherUser.profileImage).image,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text(otherUser.name)),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Chat(
                      showUserAvatars: true,
                      dateFormat: DateFormat('dd-MM-yyyy'),
                      theme: DefaultChatTheme(
                          inputMargin: const EdgeInsets.all(5),
                          inputPadding: const EdgeInsets.all(10),
                          inputBorderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          inputBackgroundColor: Colors.blueAccent,
                          primaryColor: Colors.green,
                          secondaryColor: Colors.purple,
                          backgroundColor: Colors.white,
                          messageBorderRadius: 3.0,
                          receivedMessageBodyTextStyle:
                              CustomStyles.customTextStyle(
                                  defaultColor: AppConstants.whiteColor, isNormalFont: true),
                          sentMessageBodyTextStyle:
                              CustomStyles.customTextStyle(
                                  defaultColor: AppConstants.blackColor, isNormalFont: true),
                          inputTextStyle:
                              CustomStyles.customTextStyle(isLargeFont: true),
                          messageInsetsHorizontal: 10,
                          messageInsetsVertical: 10),
                      textMessageOptions:
                          TextMessageOptions(onLinkPressed: (value) {}),
                      onMessageTap: (context, message)async{
                        if(message.type==MessageType.image || message.type==MessageType.file)
                       await context.read<ChatController>().downloadFile(context,message.id);
                      },
                      onMessageLongPress: (context, message) {

                      },
                      l10n: const ChatL10nEn(
                        inputPlaceholder: "message",
                        emptyChatPlaceholder: "",
                        fileButtonAccessibilityLabel: "",
                        sendButtonAccessibilityLabel: "",
                        attachmentButtonAccessibilityLabel: "",
                      ),
                      messages: context.watch<ChatController>().messages,
                      isTextMessageTextSelectable: true,
                      onAttachmentPressed: () => context
                          .read<ChatController>()
                          .handleAttachmentPressed(context),
                      onPreviewDataFetched: context
                          .read<ChatController>()
                          .handlePreviewDataFetched,
                      onSendPressed: context.read<ChatController>().send,
                      user: user,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
