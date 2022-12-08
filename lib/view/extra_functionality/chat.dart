import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sample/constant/constants.dart';
import 'package:flutter_sample/controller/extra_functionality/chat_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                      inputOptions: InputOptions(
                          sendButtonVisibilityMode:
                              SendButtonVisibilityMode.always),
                      showUserAvatars: false,
                      dateFormat: DateFormat('dd-MM-yyyy hh:mm:ss'),
                      theme: DefaultChatTheme(
                          inputTextColor: Colors.black,
                          sendButtonIcon: Icon(
                            Icons.send,
                            size: 25,
                            color: Colors.green,
                          ),
                          attachmentButtonIcon: Icon(
                            Icons.perm_media,
                            size: 25,
                            color: Colors.green,
                          ),
                          inputMargin: const EdgeInsets.all(5),
                          inputPadding: const EdgeInsets.all(10),
                          inputBorderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          inputBackgroundColor: Colors.white,
                          primaryColor: Colors.lightGreen,
                          secondaryColor: Colors.white,
                          backgroundColor: Color(0XFF191919),
                          messageBorderRadius: 3.0,
                          receivedMessageBodyTextStyle:
                              CustomStyles.customTextStyle(
                                  defaultColor: AppConstants.blackColor,
                                  isNormalFont: true),
                          sentMessageBodyTextStyle:
                              CustomStyles.customTextStyle(
                                  defaultColor: AppConstants.blackColor,
                                  isNormalFont: true),
                          inputTextStyle: CustomStyles.customTextStyle(
                              defaultColor: Colors.red, isLargeFont: true),
                          messageInsetsHorizontal: 10,
                          messageInsetsVertical: 10),
                      textMessageOptions:
                          TextMessageOptions(onLinkPressed: (value) {}),
                      onMessageTap: (context, message) async {
                        if (message.type == MessageType.image ||
                            message.type == MessageType.file)
                          await context
                              .read<ChatController>()
                              .downloadFile(context, message.id);
                      },
                      onMessageLongPress: (context, message) {},
                      l10n: const ChatL10nEn(
                        inputPlaceholder: "",
                        emptyChatPlaceholder: "",
                        fileButtonAccessibilityLabel: "",
                        sendButtonAccessibilityLabel: "Send",
                        attachmentButtonAccessibilityLabel: "",
                      ),
                      messages: context.watch<ChatController>().messages,
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
