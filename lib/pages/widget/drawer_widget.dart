import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/auth/auth_bloc.dart';
import 'package:flutter_golaundku/bloc/navigation/navigation_bloc.dart';
import 'package:flutter_golaundku/bloc/save_userId/save_user_id_bloc.dart';
import 'package:flutter_golaundku/bloc/user/user_bloc.dart';
import 'package:flutter_golaundku/models/app_menu.dart';
import 'package:flutter_golaundku/pages/login_page.dart';

class DrawerWidget extends StatelessWidget {
  final List<AppMenu> menus;
  const DrawerWidget({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(state.userData.name),
                  accountEmail: Text(state.userData.role),
                ),
                Expanded(
                  child: BlocBuilder<NavigationBloc, NavigationState>(
                    builder: (context, navState) {
                      return NavigationDrawer(
                        selectedIndex: navState.currentIndex >= menus.length
                            ? 0
                            : navState.currentIndex,
                        onDestinationSelected: (index) {
                          context.read<NavigationBloc>().add(ChangePage(index));
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
                    },
                  ),
                ),
                const Divider(),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLogoutSuccess) {
                      context.read<SaveUserIdBloc>().add(
                        SaveUserId(userId: ""),
                      );
                    }
                  },
                  child: SafeArea(
                    top: false,
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text("Keluar"),
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text("Apakah kamu ingin keluar?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tidak"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(LogoutUser());
                                    context.read<NavigationBloc>().add(
                                      ChangePage(0),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text("Ya"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
