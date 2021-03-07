import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class TaskController extends GetxController {
  Rx<List<TaskModel>> taskList = Rx<List<TaskModel>>();

  List<TaskModel> get tasks => taskList.value;

  @override
  void onInit() {
    String uid = Get.find<AuthController>().user.uid;
    taskList.bindStream(FirebaseDatabase().taskStream(uid));
  }
}
