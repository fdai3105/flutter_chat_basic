import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: ''),
      body: SafeArea(
        child: Container(
          child: Text(
            FirebaseAuth.instance.currentUser!.displayName ?? '',
          ),
        ),
      ),
    );
  }
}
