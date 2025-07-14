import 'package:flutter/material.dart';
import '../../widgets/sidebar_scaffold.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SidebarScaffold(
      title: 'Información',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado con icono y nombre ────────────────────────────────
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withOpacity(.12),
                child: Icon(Icons.calendar_month,
                    size: 48, color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Kalendar',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Center(
              child: Text(
                'Tu gestor personal de eventos',
                style: textTheme.titleMedium,
              ),
            ),

            const SizedBox(height: 32),

            // ── ¿Qué hace la app? ───────────────────────────────────────────
            Text(
              '¿Qué hace Kalendar?',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _AppFeature(
              icon: Icons.event_available,
              text:
              'Organiza cumpleaños, actividades, tareas y cualquier evento en un calendario visual intuitivo.',
            ),
            const _AppFeature(
              icon: Icons.notifications_active_outlined,
              text:
              'Recibe notificaciones inteligentes antes de que ocurra cada evento — ¡adiós a los olvidos!',
            ),
            const _AppFeature(
              icon: Icons.auto_mode_outlined,
              text: 'Interfaz limpia, fluida facil de usar.',
            ),
            const _AppFeature(
              icon: Icons.cloud_sync_outlined,
              text: 'Sincronización en la nube: tus eventos, en tu dispositivo Movil.',
            ),

            const SizedBox(height: 32),

            // ── Detalles de la aplicación ───────────────────────────────────
            Text(
              'Detalles de la aplicación',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Docente a cargo'),
                subtitle: const Text('Darwin Caina'),   // cámbiala según tu release
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.people_alt_outlined),
                title: const Text('Desarrolladores'),
                subtitle: const Text('Cueva,Aguilar,Almeida,Apolo'),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Materia'),
                subtitle: const Text('Dispositvos Moviles'),
              ),
            ),

            const SizedBox(height: 40),

            // ── Mensaje final ───────────────────────────────────────────────
            Center(
              child: Text(
                '¡Gracias por usar Kalendar! ✨',
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pequeño helper para no repetir estilo de cada beneficio/feature.
class _AppFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AppFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
