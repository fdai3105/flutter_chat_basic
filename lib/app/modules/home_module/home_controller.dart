import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';

class HomeController extends GetxController {
  final UserProvider provider;

  HomeController({required this.provider});

  final _isLoading = true.obs;
  final _users = <MyUser>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<MyUser> get users => _users.value;

  set users(value) {
    _users.value = value;
  }

  @override
  void onInit() async {
    provider.getListUsers().listen((event) {
      users = event;
    });
    isLoading = false;
    super.onInit();
  }
}
