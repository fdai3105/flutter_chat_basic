import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart' as Models;
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';

class TabUserController extends GetxController {
  final UserProvider provider;

  TabUserController({required this.provider});

  final _isLoading = true.obs;
  final _users = <Models.MyUser>[].obs;

  get users => _users;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  set users(value) {
    _users.value = value;
  }

  @override
  void onInit() {
    provider.getListUsers().listen((event) {
      users = event;
    }).onDone(() {
      if (isLoading) {
        isLoading = false;
      }
    });
    isLoading = false;
    super.onInit();
  }
}
