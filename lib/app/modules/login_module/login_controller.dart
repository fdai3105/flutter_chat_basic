import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthProvider provider;
  final NotificationProvider ntfProvider;

  LoginController({required this.provider, required this.ntfProvider});

  void loginWithGoogle() async {
    try {
      final user = await provider.loginWithGoogle();
      if (user != null) {
        await UserProvider().saveUserToStore(user);
        Get.offNamed(Routes.home);
      }
    } catch (e) {
      Get.snackbar('Something wrong', 'Please try again');
    }
  }
}
