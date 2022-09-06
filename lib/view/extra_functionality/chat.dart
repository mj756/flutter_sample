import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sample/controller/extra_functionality/chat_controller.dart';
import 'package:flutter_sample/model/extra_functionality/chat_message.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const user = User(
      firstName: 'milan',
      id: '100',
      imageUrl: 'https://picsum.photos/200/300',
    );

    return ChangeNotifierProvider(
        create: (context) => ChatController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const CircleAvatar(),
                      const SizedBox(
                        width: 20,
                      ),
                      const Expanded(child:  Text('Other user name')),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () async {
                              await context
                                  .read<ChatController>()
                                  .deleteAllData();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Chat(
                    showUserAvatars: true,
                    dateFormat: DateFormat('dd-MM-yyyy'),
                    theme: DefaultChatTheme(
                        inputMargin: const EdgeInsets.all(5),
                        inputPadding: const EdgeInsets.all(10),
                        inputBorderRadius: BorderRadius.zero,
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
                      if (message.type == MessageType.image) {
                        final msg =
                            ChatMessage.parseFromMessage(101, 102, message);
                      }
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
                    onMessageTap: context.read<ChatController>().onTap,
                    onPreviewDataFetched:
                        context.read<ChatController>().handlePreviewDataFetched,
                    onSendPressed: context.read<ChatController>().send,
                    user: user,
                  ),
                )
              ],
            ),
          );
        });
  }
}
