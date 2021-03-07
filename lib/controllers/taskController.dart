import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class TaskController extends GetxController {
  var _taskList = Rx<List<TaskModel>>();

  List<TaskModel> get tasks => _taskList.value;

  @override
  void onInit() {
    String uid = Get.find<AuthController>().user.uid;

    _taskList = Rx<List<TaskModel>>();

    //this is the stream that is being downloaded from firebase
    _taskList.bindStream(FirebaseDatabase().taskStream(uid));

    super.onInit();
  }
}
