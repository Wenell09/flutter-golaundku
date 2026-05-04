import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/save_userId/save_user_id_bloc.dart';
import 'package:flutter_golaundku/bloc/user/user_bloc.dart';
import 'package:flutter_golaundku/pages/login_page.dart';
import 'package:flutter_golaundku/pages/main_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SaveUserIdBloc, SaveUserIdState>(
          listener: (context, state) {
            if (state is SaveUserLoaded) {
              context.read<UserBloc>().add(GetUser(userId: state.userId));
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MainPage(userId: state.userData.userId),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.local_laundry_service, size: 100),
              Text("GoLaundKu", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
