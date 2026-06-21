import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/auth_controller.dart';
import 'package:flutter_golaundku/controller/navigation_controller.dart';
import 'package:flutter_golaundku/controller/user_controller.dart';
import 'package:flutter_golaundku/models/app_menu.dart';
import 'package:flutter_golaundku/pages/login_page.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  final List<AppMenu> menus;
  const DrawerWidget({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final navigationController = Get.find<NavigationController>();
    final authController = Get.find<AuthController>();
    return Obx(() {
      final user = userController.userData.value;
      if (user == null) {
        return const SizedBox();
      }
      return Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.username),
              accountEmail: Text(user.role),
            ),
            Expanded(
              child: Obx(() {
                int safeIndex =
                    navigationController.currentIndex.value >= menus.length
                    ? 0
                    : navigationController.currentIndex.value;
                return NavigationDrawer(
                  selectedIndex: safeIndex,

                  onDestinationSelected: (index) {
                    navigationController.changeIndex(index);

                    Navigator.pop(context);
                  },
                  children: menus
                      .map(
                        (menu) => NavigationDrawerDestination(
                          icon: Icon(menu.icon),
                          label: Text(menu.title),
                        ),
                      )
                      .toList(),
                );
              }),
            ),
            const Divider(),
            SafeArea(
              top: false,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Keluar"),

                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      content: const Text("Apakah kamu ingin keluar?"),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Tidak"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await authController.logout();
                            navigationController.changeIndex(0);
                            Get.offAll(() => const LoginPage());
                          },
                          child: const Text("Ya"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
