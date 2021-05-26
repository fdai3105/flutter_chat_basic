import 'package:flutter/material.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: Text("Home", style: TextStyle(
        color: Colors.black87,
      ),)),
      body: SafeArea(
        child: GetX<HomeController>(
          builder: (_) {
            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, i) {
                final item = controller.users[i];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(name: item.name, avatar: item.avatar!,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200, width: 2)
                        ),
                        child: ClipOval(
                          child: Image.network(item.avatar!,),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          Text(
                            item.email,
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
