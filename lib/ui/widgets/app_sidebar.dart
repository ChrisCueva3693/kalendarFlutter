import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture:
            const CircleAvatar(child: Icon(Icons.person)),
            accountName: Text(user?.displayName ?? 'Usuario'),
            accountEmail: Text(user?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Calendario'),
            onTap: () => _nav(context, '/calendar'),
          ),
          ListTile(
            leading: const Icon(Icons.add_box_outlined),
            title: const Text('Agregar evento'),
            onTap: () => _nav(context, '/add-event'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Información'),
            onTap: () => _nav(context, '/info'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              Navigator.pop(context); // 1️⃣ cierra el Drawer

              // 2️⃣ Loader opcional
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                const Center(child: CircularProgressIndicator()),
              );

              try {
                await auth.signOut(); // 3️⃣ cierra sesión
              } finally {
                if (!context.mounted) return;

                Navigator.of(context).pop(); // 4️⃣ quita el loader

                // 5️⃣ vuelve a la primera ruta (donde vive tu StreamBuilder)
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Navegación interna que sustituye la página actual y no crece el stack.
  void _nav(BuildContext context, String route) {
    Navigator.pop(context); // cierra el Drawer
    Navigator.pushReplacementNamed(context, route);
  }
}
