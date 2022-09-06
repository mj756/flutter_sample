import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
EventBus eventBus = EventBus();
class ChatMessageEvent {
  RemoteMessage message;
  ChatMessageEvent(this.message);
}