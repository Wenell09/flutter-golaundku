import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/auth_controller.dart';
import 'package:flutter_golaundku/controller/user_controller.dart';
import 'package:flutter_golaundku/pages/main_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();

  late ValueNotifier<bool> isShowPassword;
  late TextEditingController inputName;
  late TextEditingController inputPassword;

  @override
  void initState() {
    isShowPassword = ValueNotifier<bool>(true);
    inputName = TextEditingController();
    inputPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    isShowPassword.dispose();
    inputName.dispose();
    inputPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            margin: EdgeInsets.only(top: 70, left: 70, right: 70),
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/golaundku_icons.png"),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              "Sistem Manajemen Laundry",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Username",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextField(
            controller: inputName,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              hintText: "admin/staff",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Password",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isShowPassword,
            builder: (context, value, child) => TextField(
              controller: inputPassword,
              autofillHints: [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              obscureText: value,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                hintText: "••••••",
                suffixIcon: IconButton(
                  icon: Icon(value ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    isShowPassword.value = !isShowPassword.value;
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              if (inputName.text.isEmpty || inputPassword.text.isEmpty) {
                return Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Text(
                      "Pastikan Username dan Password terisi!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              await authController.login(
                name: inputName.text,
                password: inputPassword.text,
              );
              if (authController.userId.value.isNotEmpty) {
                await userController.getUser(authController.userId.value);
                Get.offAll(() => MainPage(userId: authController.userId.value));
              }
              if (authController.errorMessage.value.isNotEmpty) {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Text(
                      authController.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() {
                return authController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Center(
                        child: Text(
                          "Sign In",
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
