import 'package:flutter/material.dart';
import 'app_sidebar.dart';

class SidebarScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const SidebarScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppSidebar(),
      body: body,
    );
  }
}
