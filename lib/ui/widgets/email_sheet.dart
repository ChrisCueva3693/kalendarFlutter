import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class EmailSheet extends StatefulWidget {          // ← SIN “_”
  const EmailSheet({super.key});

  @override
  State<EmailSheet> createState() => _EmailSheetState();
}

class _EmailSheetState extends State<EmailSheet> {
  final _auth = AuthService();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _isLogin = true;              // alterna login / registro
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() { _loading = true; _error = null; });
    try {
      if (_isLogin) {
        await _auth.signInWithEmail(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      } else {
        await _auth.registerWithEmail(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      }
      if (context.mounted) Navigator.of(context).pop(); // cierra el sheet
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24, bottom: padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_isLogin ? 'Iniciar sesión' : 'Crear cuenta',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Correo'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
          ),
          if (_error != null) Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(_isLogin ? 'Entrar' : 'Registrarme'),
          ),
          TextButton(
            onPressed: _loading
                ? null
                : () => setState(() => _isLogin = !_isLogin),
            child: Text(_isLogin
                ? '¿No tienes cuenta? Regístrate'
                : '¿Ya tienes cuenta? Inicia sesión'),
          )
        ],
      ),
    );
  }
}
