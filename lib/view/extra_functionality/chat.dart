import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sample/controller/extra_functionality/chat_controller.dart';
import 'package:flutter_sample/model/extra_functionality/chat_message.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/preference_controller.dart';

class ChatRoom extends StatelessWidget {
  final AppUser otherUser;
  const ChatRoom({Key? key,required this.otherUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final _currentUser = AppUser.fromJson(json.decode(PreferenceController.getString(
        PreferenceController.prefKeyUserPayload)));
   final user = User(
      firstName: _currentUser.name,
      id: _currentUser.id.toString(),
      imageUrl:_currentUser.profileImage.isNotEmpty ?_currentUser.profileImage:  'https://picsum.photos/200/300',
    );

    return ChangeNotifierProvider(
        create: (context) => ChatController(otherUser),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title:   SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      backgroundImage:Image.network(otherUser.profileImage.isNotEmpty ? otherUser.profileImage:'https://picsum.photos/200/300').image,
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
                          inputBorderRadius: const BorderRadius.all(Radius.circular(5)),
                          inputBackgroundColor: Colors.blueAccent,
                          primaryColor: Colors.grey,
                          secondaryColor: Colors.blueAccent,
                          backgroundColor: Colors.white,
                          messageBorderRadius: 3.0,
                          receivedMessageBodyTextStyle:
                              CustomStyles.customTextStyle(
                                  defaultColor: CustomColors.whiteColor,
                                  isNormalFont: true),
                          sentMessageBodyTextStyle: CustomStyles.customTextStyle(
                              defaultColor: CustomColors.whiteColor,
                              isNormalFont: true),
                          inputTextStyle:
                              CustomStyles.customTextStyle(isLargeFont: true),
                          messageInsetsHorizontal: 10,
                          messageInsetsVertical: 10),
                      textMessageOptions:
                          TextMessageOptions(onLinkPressed: (value) {}),
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
                      isTextMessageTextSelectable: false,
                      onAttachmentPressed: () => context
                          .read<ChatController>()
                          .handleAttachmentPressed(context),

                      onPreviewDataFetched:
                          context.read<ChatController>().handlePreviewDataFetched,
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