// lib/ui/widgets/email_sheet.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class EmailSheet extends StatefulWidget {
  const EmailSheet({super.key});

  @override
  State<EmailSheet> createState() => _EmailSheetState();
}

class _EmailSheetState extends State<EmailSheet> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  bool _showPass = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        await _auth.signInWithEmail(
            email: _emailCtrl.text.trim(), password: _passCtrl.text);
      } else {
        await _auth.registerWithEmail(
            email: _emailCtrl.text.trim(), password: _passCtrl.text);
      }
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ✨ CAMBIO: Mensajes de error más amigables
      switch (e.code) {
        case 'invalid-email':
          _error = 'El formato del correo no es válido.';
          break;
        case 'user-not-found':
          _error = 'No se encontró un usuario con ese correo.';
          break;
        case 'wrong-password':
          _error = 'La contraseña es incorrecta.';
          break;
        case 'email-already-in-use':
          _error = 'Este correo ya está registrado.';
          break;
        default:
          _error = 'Ocurrió un error. Inténtalo de nuevo.';
      }
      setState(() {});
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // ✨ CAMBIO: Envolvemos en SingleChildScrollView para evitar overflow con el teclado.
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título
          Text(
            _isLogin ? 'Iniciar sesión' : 'Crear cuenta',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Formulario
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: 'Correo electrónico',
                    // ✨ CAMBIO: Estilo de campo de texto unificado
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                  v != null && v.contains('@') ? null : 'Correo no válido',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  autofillHints: _isLogin
                      ? [AutofillHints.password]
                      : [AutofillHints.newPassword],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                  validator: (v) =>
                  v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                ),
              ],
            ),
          ),

          // ✨ CAMBIO: Mensaje de error mejorado
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _error!,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),

          // Botón principal
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : Text(_isLogin ? 'Entrar' : 'Registrarme'),
            ),
          ),
          const SizedBox(height: 16),

          // ✨ CAMBIO: Toggle login/registro con RichText para un look más limpio
          RichText(
            text: TextSpan(
              style: textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: _isLogin
                      ? '¿No tienes cuenta? '
                      : '¿Ya tienes cuenta? ',
                ),
                TextSpan(
                  text: _isLogin ? 'Regístrate' : 'Inicia sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (!_loading) {
                        setState(() {
                          _isLogin = !_isLogin;
                          _error = null; // Limpia errores al cambiar de modo
                        });
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}