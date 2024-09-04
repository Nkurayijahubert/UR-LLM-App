enum MessageSender { user, ai }

class ChatModel {
  final String message;
  final MessageSender sender;

  ChatModel({required this.message, required this.sender});
}
