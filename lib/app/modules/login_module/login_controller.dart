import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AuthProvider provider;
  bool? isLogin = false;

  LoginController({required this.provider, this.isLogin});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void loginWithGoogle() async {
    final user = await provider.loginWithGoogle();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (user == null) {
      Get.snackbar('Something wrong', 'Something wrong idk');
    } else {
      UserProvider().saveUserToStore(user);
      isLogin = true;
      _prefs.setBool('isLogin', isLogin!);
      Get.toNamed(Routes.home);
    }
  }
}
