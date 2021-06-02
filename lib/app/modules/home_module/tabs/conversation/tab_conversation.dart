import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/conversation/tab_conversation_controller.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/widgets/widgets.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class ConversationTab extends GetView<TabConversationController> {
  const ConversationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetAppBar(
        title: 'Chats',
        actions: [
          IconButton(
            onPressed: () => controller.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: GetX<TabConversationController>(
          builder: (_) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: controller.groups.length,
                itemBuilder: (context, i) {
                  final item = controller.groups[i];
                  final grpName = controller.groupName(item.members);
                  return ListTile(
                    onTap: () => Get.toNamed(Routes.chat, arguments: {
                      'uID': item.uid,
                      'name': grpName,
                      'avatar': '',
                      'isActive': false,
                      'isFromContact': false,
                    }),
                    leading: WidgetAvatarChat(members: item.members),
                    title: Text(item.name.length < 1 ? grpName : item.name),
                    subtitle: Text(controller.lastMess(item.lastMessage)),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: _buildFloatButton(),
    );
  }

  FloatingActionButton _buildFloatButton() {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(Routes.createGroupChat),
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }
}
