import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
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
              controller.selected.length > 2
                  ? IconButton(
                      onPressed: () => controller.onSubmit(),
                      icon: Icon(Icons.add),
                      color: Colors.black87,
                    )
                  : IconButton(
                      onPressed: () {
                        Get.rawSnackbar(
                          title: 'Something wrong',
                          message: 'Members must be up to 2',
                        );
                      },
                      icon: Icon(Icons.add),
                      color: Colors.grey,
                    )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Flexible(
                  child: GetX<CreateGroupChatController>(
                    builder: (_) {
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
                          SizedBox(height: 10),
                          _buildListSelected(),
                          SizedBox(height: 10),
                          _buildListUser(),
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

  Widget _buildListSelected() {
    if (controller.selected.isEmpty) {
      return Container(
        height: 90,
        child: Center(child: Text('Choose up to 2 person')),
      );
    } else {
      return Container(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.selected.length,
          itemBuilder: (context, i) {
            final item = controller.selected[i];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  if (item.uid != UserProvider.getCurrentUser().uid) {
                    controller.onSelect(item);
                  }
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        WidgetAvatar(
                          size: 60,
                          isActive: false,
                          url: item.avatar,
                        ),
                        item.uid == UserProvider.getCurrentUser().uid
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(item.name.split(' ').last),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Expanded _buildListUser() {
    final l = controller.selected;
    return Expanded(
      child: ListView.builder(
        itemCount: controller.users.length,
        itemBuilder: (context, i) {
          final item = controller.users[i];
          return ListTile(
            onTap: () => controller.onSelect(item),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            leading: WidgetAvatar(
              url: item.avatar,
              isActive: false,
            ),
            title: Text(item.name),
            trailing: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: l.contains(item) ? Colors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Colors.grey.shade200,
                ),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}
