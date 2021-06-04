import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:pdteam_demo_chat/app/utils/utils.dart';

class TabConversationController extends GetxController {
  final GroupChatProvider provider;

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

  String groupName(String grpName, List<MyUser> members, {int max = 3}) {
    if (members.length <= 2) {
      final find = members
          .where((element) => element.uid != UserProvider.getCurrentUser()!.uid)
          .first;
      return find.name;
    }
    if (grpName.length > 0) {
      return grpName;
    }
    var name = '';
    if (members.length > 3) {
      for (int i = 0; i < 3; i++) {
        final item = members[i];
        final n = item.name.split(' ');
        i == members.length - 1
            ? name += n[n.length - 1]
            : name += n[n.length - 1] + ', ';
      }
      name += '+ ${members.length - 3}';
    } else {
      for (int i = 0; i < members.length; i++) {
        final item = members[i];
        final n = item.name.split(' ');
        i == members.length - 1
            ? name += n[n.length - 1]
            : name += n[n.length - 1] + ', ';
      }
    }
    return name;
  }

  String lastMess(FirebaseMessage? last) {
    if (last == null) return 'Send your first message';
    var mess = last.message;
    if(last.message.length > 10 ){
      mess = last.message.substring(0, 10) + ' ...  ';
    }
    if (last.senderUID == UserProvider.getCurrentUser()!.uid) {
      if (last.type == 1) {
        return 'You send a photo  •  ${formatDate(last.createdAt)}';
      }
      return 'You : $mess  •  ${formatDate(last.createdAt)}';
    } else {
      if (last.type == 1) {
        return '${last.senderName} send a photo  •  ${formatDate(last.createdAt)}';
      }
      return '${last.senderName} : $mess  •  ${formatDate(last.createdAt)}';
    }
  }

  @override
  void onInit() async {
    provider.getConversations().listen((event) {
      groups = event;
    }).onData((data) {
      groups = data;
      if (isLoading) isLoading = false;
    });
    super.onInit();
  }

  void logout() {
    AuthProvider().logout();
    Get.offAllNamed(Routes.login);
  }
}
