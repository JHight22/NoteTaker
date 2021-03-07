import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/userController.dart';
import 'package:notetaker/models/user.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();

  User get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  void createUser(String name, String email, String password) async {
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      //This creates a user in the database
      UserModel _user = UserModel(
        id: _authResult.user.uid,
        name: name,
        email: _authResult.user.email,
      );

      if (await FirebaseDatabase().createNewUser(_user)) {
        //user created successfully
        Get.find<UserController>().user = _user;
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Can't sign you up for an account, try again", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void loginUser(String email, String password) async {
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);

      Get.find<UserController>().user =
          await FirebaseDatabase().getUser(_authResult.user.uid);
    } catch (e) {
      Get.snackbar("Can't sign in, try again", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOutUser() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
    } catch (e) {
      Get.snackbar("Can't sign out, try again.", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
