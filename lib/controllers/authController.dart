import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();

  String get user => _firebaseUser.value?.email;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  void createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
    } catch (e) {
      Get.snackbar("Error signing up for an account", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } catch (e) {
      Get.snackbar("Error signing in", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
