import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthProvider provider;

  LoginController({required this.provider});

  void loginWithGoogle() async {
    final user = await provider.loginWithGoogle();
    if (user != null) {
      UserProvider().saveUserToStore(user);
      Get.offNamed(Routes.home);
    }
  }
}
