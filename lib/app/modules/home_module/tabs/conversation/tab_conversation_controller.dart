import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/chat_provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

class TabConversationController extends GetxController {
  final ChatProvider provider;

  TabConversationController({required this.provider});

  final _isLoading = true.obs;
  final _groups = <Group>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<Group> get groups => _groups;

  set groups(value) {
    _groups.value = value;
  }

  String groupName(List<MyUser> members) {
    var name = '';
    for (int i = 0; i < members.length; i++) {
      final item = members[i];
      final n = item.name.split(' ');
      if (i == members.length - 1) {
        name += n[n.length - 1];
      } else {
        name += n[n.length - 1] + ', ';
      }
    }
    return name;
  }

  @override
  void onInit() async {
    await provider.getConversations()
      ..listen((event) {
        groups = event;
      });
    isLoading = false;
    super.onInit();
  }

  void logout() {
    AuthProvider.logout();
    Get.offAllNamed(Routes.login);
  }
}
