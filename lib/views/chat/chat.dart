import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ibl_test/utils/colors.dart';

import '../../controllers/chat.dart';
import '../../models/chat.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(), permanent: true);

    return Obx(() => Scaffold(
        key: controller.chatScaffoldKey,
        appBar: AppBar(
          leadingWidth: 45,
          titleSpacing: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            "Chat",
            style: TextStyle(fontSize: 18),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : !controller.isAuthenticated.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(child: Text('Please log in to access the chat.')),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => controller.showLoginDialog(),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: colorPrimary_700),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.webSocketController?.messages.length ?? 0,
                          itemBuilder: (context, index) {
                            final message = controller.webSocketController!.messages[index];
                            if (message.sender == MessageSender.user) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: colorPrimary_200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          message.message,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 16.0, bottom: 8.0),
                                      child: Icon(
                                        Icons.person,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                                      child: Icon(
                                        Icons.computer,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          message.message,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      if (controller.webSocketController?.isWaitingForResponse.value ?? false)
                        const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [Text("AI is thinking ..."), Expanded(child: LinearProgressIndicator())],
                            )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.textController,
                                onChanged: controller.setMessage,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () async {
                                if (await controller.validateForm()) {
                                  controller.sendMessage();
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )));
  }
}
