import 'package:get/get.dart';
import '../views/chat/chat.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.chat,
      page: () => const Chat(),
    ),
  ];
}
