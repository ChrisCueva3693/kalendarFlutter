// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';         // 👈 intl
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'router.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Localización: carga datos de 'es_EC' (meses, días, etc.) ───────────
  await initializeDateFormatting('es_EC', null);

  // ── Firebase ───────────────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const KalendarApp());
}

class KalendarApp extends StatelessWidget {
  const KalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,          // color de tu AppBar
          foregroundColor: Colors.white,               // texto/blanco
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.deepPurple,         // 👈 fondo de la status bar
            statusBarIconBrightness: Brightness.light, // iconos blancos
            statusBarBrightness: Brightness.dark,      // iOS (opcional)
          ),
        ),
      ),

      // ── Localización global de la app ──────────────────────────────────
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),      // Inglés (por defecto)
        Locale('es', 'EC'),    // Español (Ecuador) – usa sólo 'es' si prefieres genérico
      ],

      // ── Navegación centralizada ────────────────────────────────────────
      onGenerateRoute: generateRoute,

      // ── Wrapper de autenticación mediante StreamBuilder ────────────────
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
