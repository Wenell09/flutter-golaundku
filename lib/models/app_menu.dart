import 'package:flutter/material.dart';

class AppMenu {
  final String title;
  final IconData icon;
  final Widget page;
  final List<String> roles;
  final Widget? fab;

  AppMenu({
    required this.title,
    required this.icon,
    required this.page,
    this.roles = const ["administrator", "staff"],
    this.fab,
  });
}
