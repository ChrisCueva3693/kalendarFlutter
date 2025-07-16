import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../widgets/email_sheet.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.85),
              colorScheme.primaryContainer,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Logo y Título ──────────────────────────────────────────
                Image.asset(
                  'assets/icons/app_icon.png',
                  height: 96,
                ),
                const SizedBox(height: 16),
                Text(
                  'Kalendar',
                  style: textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organiza tu día a día.',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.9),
                  ),
                ),

                // ✨ AJUSTE: Spacer con más peso para empujar la tarjeta hacia abajo, pero no del todo.
                const Spacer(flex: 2),

                // ── Card de autenticación ──────────────────────────────────
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Bienvenido',
                          style: textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        // Google Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            onPressed: _loading
                                ? null
                                : () => _run(_auth.signInWithGoogle),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/google_logo.png',
                                  height: 22,
                                ),
                                const SizedBox(width: 12),
                                const Text('Continuar con Google'),
                              ],
                            ),
                          ),
                        ),

                        // Email / password
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            // ✨ CORRECCIÓN AQUÍ
                            onPressed: _loading
                                ? null
                                : () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              // Se establece el color de fondo y la forma
                              backgroundColor: theme.cardColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24)),
                              ),
                              builder: (_) => const EmailSheet(),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Email y contraseña'),
                          ),
                        ),

                        // Loader & errores
                        if (_loading) ...[
                          const SizedBox(height: 20),
                          const CircularProgressIndicator(),
                        ],
                        if (_error != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            _error!,
                            style: TextStyle(color: colorScheme.error),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // ✨ AJUSTE: Spacer con menos peso para dejar un poco de espacio abajo.
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}