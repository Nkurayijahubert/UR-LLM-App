import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibl_test/utils/colors.dart';

import 'authentication.dart';
import 'websocket.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final chatScaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.put(AuthController());
  WebSocketController? webSocketController;

  final username = ''.obs;
  final password = ''.obs;

  final messageValue = ''.obs;
  final isLoading = true.obs;
  final isAuthenticated = false.obs;

  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  void setUsername(String value) => username.value = value;
  void setPassword(String value) => password.value = value;

  @override
  void onInit() {
    super.onInit();
    initializeChat();
  }

  Future<void> initializeChat() async {
    isLoading.value = true;
    await checkAuthenticationStatus();
    if (isAuthenticated.value) {
      await initializeWebSocket();
    } else {
      showLoginDialog();
    }
    isLoading.value = false;
  }

  Future<void> checkAuthenticationStatus() async {
    isAuthenticated.value = await authController.checkToken();
  }

  Future<void> initializeWebSocket() async {
    webSocketController = Get.put(WebSocketController());
    await webSocketController!.connectToWebSocket();
    sendSampleMessage();
  }

  void handleTokenExpiration() {
    isAuthenticated.value = false;
    Get.snackbar('Session Expired', 'Please log in again.');
    showLoginDialog();
  }

  void showLoginDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Login Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: setUsername,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: setPassword,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              'Login',
              style: TextStyle(color: colorPrimary_700),
            ),
            onPressed: () async {
              Get.back();
              isLoading.value = true;
              bool success = await authController.login(username.value, password.value);

              if (success) {
                await checkAuthenticationStatus(); // Check authentication status after login attempt
                if (isAuthenticated.value) {
                  await initializeWebSocket();
                } else {
                  Get.snackbar('Error', 'Login failed. Please try again.');
                  showLoginDialog(); // Show login dialog again if authentication failed
                }
              } else {
                Get.snackbar('Error', 'Login failed');
              }

              isLoading.value = false;
            },
          ),
        ],
      ),
    );
  }

  void setMessage(String value) => messageValue.value = value;

  Future<bool> validateForm() async {
    if (messageValue.value.isEmpty) {
      Get.snackbar('Error', "You can't send an empty message.");
      return false;
    }
    return true;
  }

  void sendMessage() {
    if (messageValue.value.isNotEmpty && webSocketController != null) {
      webSocketController!.sendMessage(messageValue.value);
      textController.clear();
      messageValue.value = '';
      scrollToBottom();
    }
  }

  void sendSampleMessage() {
    if (webSocketController != null) {
      webSocketController!.sendMessage("Hello, Langflow!");
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
