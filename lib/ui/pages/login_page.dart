// ui/pages/login_page.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  bool _loading = false;
  String? _error;

  void _run(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Bienvenido a Kalendar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed:
                _loading ? null : () => _run(_auth.signInWithGoogle),
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Iniciar con Google'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed:
                _loading ? null : () => _run(_auth.signInWithFacebook),
                icon: const Icon(Icons.facebook),
                label: const Text('Iniciar con Facebook'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _loading
                    ? null
                    : () async {
                  // TODO: muestra diálogo para email / contraseña
                },
                child: const Text('Email / Contraseña'),
              ),
              if (_loading) const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator()),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
