// ui/pages/home_page.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.signOut(),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: const Center(child: Text('Aquí irá tu calendario 📅')),
    );
  }
}
