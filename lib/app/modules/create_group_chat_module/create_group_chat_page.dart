import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

import 'create_group_chat_controller.dart';

class CreateGroupChatPage extends GetView<CreateGroupChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetAppBar(
        title: 'Create group chat',
        actions: [
          IconButton(
            onPressed: () => controller.onSubmit(),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // WidgetInputField(
            //   controller: controller.textCtrl,
            //   hint: 'Enter group name',
            // ),
            Flexible(
              child: GetX<CreateGroupChatController>(
                builder: (_) {
                  final se = controller.selected;
                  return ListView.builder(
                    itemCount: controller.users.length,
                    itemBuilder: (context, i) {
                      final item = controller.users[i];
                      return ListTile(
                        onTap: () {
                          controller.onSelect(item.uid);
                        },
                        leading: WidgetAvatar(
                          url: item.avatar,
                          isActive: false,
                        ),
                        title: Text(item.name),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: se.contains(item.uid)
                                ? Colors.grey
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
