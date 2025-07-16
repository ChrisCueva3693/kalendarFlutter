import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para la barra de estado
import '../widgets/sidebar_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // ✨ CAMBIO: Envolvemos el Scaffold para controlar la UI del sistema
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // Cambia el color de la barra de estado (donde está la hora)
        statusBarColor: theme.colorScheme.primary,
        // Cambia el color de los íconos de la barra de estado (reloj, wifi, etc.)
        statusBarIconBrightness: Brightness.light, // O Brightness.dark
      ),
      child: SidebarScaffold(
        title: 'Kalendar',
        body: SingleChildScrollView(
          // Permite hacer scroll si el contenido es muy largo
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Sección de Bienvenida ---
              Image.asset(
                'assets/icons/app_icon.png', // Usa el ícono de tu app
                height: 120,
              ),
              const SizedBox(height: 24),
              Text(
                '¡Bienvenido a Kalendar!',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Tu asistente personal para que nunca olvides tus momentos especiales. Organiza tus citas y eventos de forma fácil y elegante.',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 40),

              // --- Sección de Características ---
              _FeatureHighlight(
                icon: Icons.add_circle_outline,
                title: 'Crea Eventos Fácilmente',
                description:
                'Añade nuevas citas, reuniones o recordatorios en segundos.',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              _FeatureHighlight(
                icon: Icons.notifications_active_outlined,
                title: 'Recibe Recordatorios',
                description:
                'Te notificaremos para que siempre llegues a tiempo.',
                color: Colors.orange.shade700,
              ),
              const SizedBox(height: 24),
              _FeatureHighlight(
                icon: Icons.favorite_border,
                title: 'No Olvides lo Importante',
                description:
                'Guarda cumpleaños, aniversarios y fechas especiales.',
                color: Colors.pink.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para mostrar las características de forma ordenada
class _FeatureHighlight extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureHighlight({
    required this.icon,
    required this.title,
    required this.description,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}