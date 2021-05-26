import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_controller.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: 'Login'),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            onPressed: () {
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network("https://raw.githubusercontent.com/sbis04/flutterfire-samples/google-sign-in/assets/google_logo.png", height: 35.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
