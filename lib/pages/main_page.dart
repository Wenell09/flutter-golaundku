import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/navigation_controller.dart';
import 'package:flutter_golaundku/controller/user_controller.dart';
import 'package:flutter_golaundku/models/app_menu.dart';
import 'package:flutter_golaundku/pages/customer_page.dart';
import 'package:flutter_golaundku/pages/dashboard_page.dart';
import 'package:flutter_golaundku/pages/discount_page.dart';
import 'package:flutter_golaundku/pages/input_order_page.dart';
import 'package:flutter_golaundku/pages/order_list_page.dart';
import 'package:flutter_golaundku/pages/payment_page.dart';
import 'package:flutter_golaundku/pages/report_page.dart';
import 'package:flutter_golaundku/pages/service_page.dart';
import 'package:flutter_golaundku/pages/widget/drawer_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_customer_dialog_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_discount_dialog_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_service_dialog_widget.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final String userId;
  const MainPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final navigationController = Get.find<NavigationController>();
    return Obx(() {
      final user = userController.userData.value;
      if (user == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final menus = getFilteredMenus(userId, user.role, context);
      int safeIndex = navigationController.currentIndex.value >= menus.length
          ? 0
          : navigationController.currentIndex.value;
      final currentMenu = menus[safeIndex];
      return Scaffold(
        appBar: AppBar(title: Text(currentMenu.title)),
        floatingActionButton: currentMenu.fab,
        drawer: DrawerWidget(menus: menus),
        body: IndexedStack(
          index: safeIndex,
          children: menus.map((m) => m.page).toList(),
        ),
      );
    });
  }
}

List<AppMenu> getFilteredMenus(
  String userId,
  String role,
  BuildContext context,
) {
  final allMenus = [
    AppMenu(title: "Dashboard", icon: Icons.window, page: DashboardPage()),
    AppMenu(
      title: "Input Order",
      icon: Icons.add_circle,
      page: InputOrderPage(userId: userId),
    ),
    AppMenu(
      title: "Daftar Order",
      icon: Icons.assignment,
      page: OrderListPage(),
    ),
    AppMenu(title: "Pembayaran", icon: Icons.money, page: PaymentPage()),
    AppMenu(
      title: "Laporan",
      icon: Icons.bar_chart,
      page: ReportPage(),
      roles: ["administrator"],
    ),
    AppMenu(
      title: "Layanan",
      icon: Icons.dry_cleaning,
      page: ServicePage(),
      roles: ["administrator"],
      fab: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => InputServiceDialogWidget(),
        ),
        child: const Icon(Icons.add),
      ),
    ),
    AppMenu(
      title: "Pelanggan",
      icon: Icons.people,
      page: CustomerPage(),
      fab: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => InputCustomerDialogWidget(),
        ),
        child: const Icon(Icons.add),
      ),
    ),
    AppMenu(
      title: "Manajemen Diskon",
      icon: Icons.discount,
      roles: ["administrator"],
      page: DiscountPage(),
      fab: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => InputDiscountDialogWidget(),
        ),
        child: const Icon(Icons.add),
      ),
    ),
  ];
  return allMenus.where((menu) => menu.roles.contains(role)).toList();
}
