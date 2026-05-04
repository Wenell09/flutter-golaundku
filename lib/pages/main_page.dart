import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/navigation/navigation_bloc.dart';
import 'package:flutter_golaundku/pages/customer_page.dart';
import 'package:flutter_golaundku/pages/dashboard_page.dart';
import 'package:flutter_golaundku/pages/discount_page.dart';
import 'package:flutter_golaundku/pages/input_order_page.dart';
import 'package:flutter_golaundku/pages/materials_page.dart';
import 'package:flutter_golaundku/pages/order_list_page.dart';
import 'package:flutter_golaundku/pages/payment_page.dart';
import 'package:flutter_golaundku/pages/report_page.dart';
import 'package:flutter_golaundku/pages/service_page.dart';
import 'package:flutter_golaundku/pages/widget/drawer_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_customer_dialog_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_discount_dialog_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_material_dialog_widget.dart';
import 'package:flutter_golaundku/pages/widget/input_service_dialog_widget.dart';

class MainPage extends StatelessWidget {
  final String userId;
  const MainPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: getAppBar(state.currentIndex),
          floatingActionButton: getFAB(context, state.currentIndex),
          drawer: const DrawerWidget(),
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              DashboardPage(),
              InputOrderPage(userId: userId),
              OrderListPage(),
              PaymentPage(),
              ReportPage(),
              ServicePage(),
              MaterialsPage(),
              CustomerPage(),
              DiscountPage(),
            ],
          ),
        );
      },
    );
  }
}

PreferredSizeWidget getAppBar(int index) {
  switch (index) {
    case 0:
      return AppBar(title: const Text("Dashboard"));
    case 1:
      return AppBar(title: const Text("Input Order"));
    case 2:
      return AppBar(title: const Text("Daftar Order"));
    case 3:
      return AppBar(title: const Text("Pembayaran"));
    case 4:
      return AppBar(title: const Text("Laporan"));
    case 5:
      return AppBar(title: const Text("Layanan"));
    case 6:
      return AppBar(title: const Text("Stok Barang"));
    case 7:
      return AppBar(title: const Text("Pelanggan"));
    case 8:
      return AppBar(title: const Text("Diskon"));
    default:
      return AppBar(title: const Text("App"));
  }
}

Widget? getFAB(BuildContext context, int index) {
  switch (index) {
    case 0:
      return null;
    case 1:
      return null;
    case 2:
      return null;
    case 3:
      return null;
    case 4:
      return null;
    case 5:
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InputServiceDialogWidget(),
          );
        },
        child: Icon(Icons.add),
      );
    case 6:
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InputMaterialDialogWidget(),
          );
        },
        child: Icon(Icons.add),
      );
    case 7:
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InputCustomerDialogWidget(),
          );
        },
        child: Icon(Icons.add),
      );
    case 8:
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InputDiscountDialogWidget(),
          );
        },
        child: Icon(Icons.add),
      );
    default:
      return null;
  }
}
