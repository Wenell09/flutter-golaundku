import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/user_controller.dart';
import 'package:flutter_golaundku/pages/login_page.dart';
import 'package:flutter_golaundku/pages/main_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) {
      Get.offAll(() => LoginPage());
      return;
    }
    await userController.getUser(userId);
    if (userController.userData.value != null) {
      Get.offAll(() => MainPage(userId: userId));
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/golaundku_icons.png", height: 150),
      ),
    );
  }
}
