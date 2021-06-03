import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

import 'create_group_chat_controller.dart';

class CreateGroupChatPage extends GetView<CreateGroupChatController> {
  @override
  Widget build(BuildContext context) {
    return GetX<CreateGroupChatController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: WidgetAppBar(
            title: 'Create group chat',
            actions: [
              controller.selected.length > 1
                  ? IconButton(
                onPressed: () => controller.onSubmit(),
                icon: Icon(Icons.add),
                color: Colors.black87,
              )
                  : IconButton(
                onPressed: (){},
                icon: Icon(Icons.add),
                color: Colors.grey ,
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Flexible(
                  child: GetX<CreateGroupChatController>(
                    builder: (_) {
                      final se = controller.selected;
                      return Column(
                        children: [
                          WidgetField(
                            controller: controller.textCtrl,
                            hint: 'Enter group name',
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                          ),
                          controller.listUser.isEmpty
                              ? SizedBox()
                              : Container(
                            height: 60,
                            margin: EdgeInsets.only(bottom: 20),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: controller.listUser.length,
                              itemBuilder: (context, i) {
                                final item = controller.listUser[i];
                                return WidgetAvatar(
                                  isActive: false,
                                  url: item.avatar,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.users.length,
                              itemBuilder: (context, i) {
                                final item = controller.users[i];
                                return ListTile(
                                  onTap: () {
                                    controller.listSelect(item);
                                    controller.onSelect(item.uid, item.deviceToken);
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
