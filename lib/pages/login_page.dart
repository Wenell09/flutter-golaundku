import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/auth/auth_bloc.dart';
import 'package:flutter_golaundku/bloc/save_userId/save_user_id_bloc.dart';
import 'package:flutter_golaundku/bloc/user/user_bloc.dart';
import 'package:flutter_golaundku/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primary,
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.read<SaveUserIdBloc>().add(
                  SaveUserId(userId: state.userId),
                );
                context.read<UserBloc>().add(GetUser(userId: state.userId));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              } else if (state is AuthError) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Text(
                        "Pastikan Username dan Password sesuai!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(
                      LoginUser(
                        name: inputName.text,
                        password: inputPassword.text,
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (state is AuthLoading)
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
