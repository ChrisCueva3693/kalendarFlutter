import 'package:flutter/material.dart';
import 'app_sidebar.dart';

class SidebarScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  // 🆕 Propiedades opcionales para FAB
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const SidebarScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppSidebar(),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
      floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
    );
  }
}
