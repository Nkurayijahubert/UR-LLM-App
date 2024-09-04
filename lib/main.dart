import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibl_test/services/connectivity.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ConnectivityService
  final connectivityService = ConnectivityService();
  await connectivityService.init();
  Get.put(connectivityService);

  // Initialize other controllers
  // Get.put(AuthController());

  runApp(const MyApp());
}
