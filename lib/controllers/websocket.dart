import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../models/chat.dart';
import '../services/connectivity.dart';
import 'authentication.dart';
import 'chat.dart';

class WebSocketController extends GetxController {
  WebSocketChannel? channel;
  var messages = <ChatModel>[].obs;
  var isWaitingForResponse = false.obs;

  final AuthController authController = Get.put(AuthController());
  final ConnectivityService _connectivityService = Get.put(ConnectivityService());

  Future<void> connectToWebSocket() async {
    if (!await _connectivityService.checkConnection()) return;

    final token = authController.token;
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://localhost:8001/ws/chat/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    channel!.stream.listen((message) {
      isWaitingForResponse.value = false;
      handleIncomingMessage(message.toString());
    }, onError: (error) {
      print('WebSocket error: $error');
      isWaitingForResponse.value = false;
    }, onDone: () {
      print('WebSocket connection closed');
      isWaitingForResponse.value = false;
    });
  }

  void handleIncomingMessage(String message) {
    try {
      final decodedMessage = json.decode(message);
      if (decodedMessage['type'] == 'error' && decodedMessage['code'] == 401) {
        Get.find<ChatController>().handleTokenExpiration();
      } else {
        messages.add(ChatModel(message: decodedMessage['message'] ?? message, sender: MessageSender.ai));
        Get.find<ChatController>().scrollToBottom(); // Scroll to bottom after receiving a message
      }
    } catch (e) {
      print('Error decoding message: $e');
      messages.add(ChatModel(message: message, sender: MessageSender.ai));
      Get.find<ChatController>().scrollToBottom(); // Scroll to bottom even if there's an error
    }
  }

  Future<void> sendMessage(String message) async {
    if (!await _connectivityService.checkConnection()) return;

    if (channel != null) {
      isWaitingForResponse.value = true;

      final jsonMessage = {'message': message};
      // Encode the JSON object to a string
      final encodedMessage = json.encode(jsonMessage);
      // Send the encoded string
      channel!.sink.add(encodedMessage);
      messages.add(ChatModel(message: message, sender: MessageSender.user));
    }
  }

  @override
  void onClose() {
    channel?.sink.close();
    super.onClose();
  }
}
