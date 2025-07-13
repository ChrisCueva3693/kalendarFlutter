import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth  = AuthService();
    final user  = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendar'),
        actions: [
          // Correo en línea, con algo de padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                email,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              // Loader opcional
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              try {
                await auth.signOut();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al cerrar sesión: $e')),
                  );
                }
              } finally {
                if (context.mounted) Navigator.of(context).pop(); // cierra loader
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text('Aquí irá tu calendario 📅')),
    );
  }
}
