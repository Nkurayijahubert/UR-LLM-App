import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();
  final isConnected = true.obs;

  Future<void> init() async {
    List<ConnectivityResult> result = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(result);
    print("Connection results: ${result}");
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    isConnected.value = (result != ConnectivityResult.none);
  }

  Future<bool> checkConnection() async {
    if (!isConnected.value) {
      Get.snackbar('No Internet', 'Please check your internet connection');
      return false;
    }
    return true;
  }
}
