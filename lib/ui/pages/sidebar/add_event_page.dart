import 'package:flutter/material.dart';
import '../../widgets/sidebar_scaffold.dart';

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SidebarScaffold(
      title: 'Agregar evento',
      body: const Center(child: Text('Formulario para crear un evento')),
    );
  }
}
