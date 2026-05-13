import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/auth/auth_bloc.dart';
import 'package:flutter_golaundku/bloc/customer/customer_bloc.dart';
import 'package:flutter_golaundku/bloc/detail_order/detail_order_bloc.dart';
import 'package:flutter_golaundku/bloc/discount/discount_bloc.dart';
import 'package:flutter_golaundku/bloc/navigation/navigation_bloc.dart';
import 'package:flutter_golaundku/bloc/order/order_bloc.dart';
import 'package:flutter_golaundku/bloc/save_userId/save_user_id_bloc.dart';
import 'package:flutter_golaundku/bloc/service/service_bloc.dart';
import 'package:flutter_golaundku/bloc/user/user_bloc.dart';
import 'package:flutter_golaundku/config/supabase/supabase_config.dart';
import 'package:flutter_golaundku/config/theme/app_theme.dart';
import 'package:flutter_golaundku/cubit/input_order_cubit.dart';
import 'package:flutter_golaundku/pages/splash_page.dart';
import 'package:flutter_golaundku/repository/auth_repository.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';
import 'package:flutter_golaundku/repository/order_repository.dart';
import 'package:flutter_golaundku/repository/service_repository.dart';
import 'package:flutter_golaundku/repository/user_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SupabaseConfig.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(create: (context) => UserBloc(UserRepository())),
        BlocProvider(create: (context) => ServiceBloc(ServiceRepository())),
        BlocProvider(create: (context) => CustomerBloc(CustomerRepository())),
        BlocProvider(create: (context) => DiscountBloc(DiscountRepository())),
        BlocProvider(
          create: (context) => OrderBloc(
            OrderRepository(),
            CustomerRepository(),
            DiscountRepository(),
          ),
        ),
        BlocProvider(create: (context) => DetailOrderBloc(OrderRepository())),
        BlocProvider(create: (context) => InputOrderCubit()),
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => SaveUserIdBloc()..add(LoadUserId())),
      ],
      child: const MyApp(),
    ),
  );
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
