import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_golaundku/config/supabase/supabase_config.dart';
import 'package:flutter_golaundku/config/theme/app_theme.dart';
import 'package:flutter_golaundku/controller/auth_controller.dart';
import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:flutter_golaundku/controller/discount_controller.dart';
import 'package:flutter_golaundku/controller/input_order_controller.dart';
import 'package:flutter_golaundku/controller/navigation_controller.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/controller/service_controller.dart';
import 'package:flutter_golaundku/controller/user_controller.dart';
import 'package:flutter_golaundku/pages/splash_page.dart';
import 'package:flutter_golaundku/repository/auth_repository.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';
import 'package:flutter_golaundku/repository/order_repository.dart';
import 'package:flutter_golaundku/repository/service_repository.dart';
import 'package:flutter_golaundku/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SupabaseConfig.init();
  Get.put(AuthRepository());
  Get.put(UserRepository());
  Get.put(ServiceRepository());
  Get.put(CustomerRepository());
  Get.put(DiscountRepository());
  Get.put(OrderRepository());
  Get.put(AuthController(Get.find<AuthRepository>()));
  Get.put(UserController(Get.find<UserRepository>()));
  Get.put(ServiceController(Get.find<ServiceRepository>()));
  Get.put(CustomerController(Get.find<CustomerRepository>()));
  Get.put(DiscountController(Get.find<DiscountRepository>()));
  Get.put(
    OrderController(
      Get.find<OrderRepository>(),
      Get.find<CustomerRepository>(),
      Get.find<DiscountRepository>(),
    ),
  );
  Get.put(InputOrderController());
  Get.put(NavigationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoLaundKu',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: SplashPage(),
    );
  }
}
