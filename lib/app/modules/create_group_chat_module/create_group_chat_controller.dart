import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

class CreateGroupChatController extends GetxController {
  final UserProvider provider;
  final ChatProvider chatProvider;

  CreateGroupChatController({
    required this.provider,
    required this.chatProvider,
  });

  final _isLoading = true.obs;
  final _users = <MyUser>[].obs;
  final _selected = <String>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<MyUser> get users => _users;

  set users(value) {
    _users.value = value;
  }

  List<String> get selected => _selected;

  set selected(value) {
    _selected.value = value;
  }

  @override
  void onInit() async {
    users = await provider.getUsers();
    isLoading = false;
    super.onInit();
  }

  void onSelect(String uid) {
    if (selected.contains(uid)) {
      selected.removeWhere((element) => element == uid);
    } else {
      selected.add(uid);
    }
  }

  Future onSubmit() async {
    await chatProvider.createGroupChat(selected);
    Get.back();
  }
}
