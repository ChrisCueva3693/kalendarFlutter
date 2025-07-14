import 'package:flutter/material.dart';
import '../widgets/sidebar_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SidebarScaffold(
      title: 'Kalendar',
      body: Center(child: Text('¡Bienvenido a Kalendar!')),
    );
  }
}
