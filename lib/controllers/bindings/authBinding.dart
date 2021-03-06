import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
