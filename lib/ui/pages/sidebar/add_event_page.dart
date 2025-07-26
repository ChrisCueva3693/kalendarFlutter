import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/sidebar_scaffold.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();

  DateTime? _pickedDate;
  bool _loading = false;
  String? _error;

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate() || _pickedDate == null) {
      setState(() => _error = 'Completa todos los campos');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _error = 'Sesión no válida');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final body = jsonEncode({
      'title': _titleCtrl.text.trim(),
      'eventDate': _pickedDate!.toIso8601String().substring(0, 10), // yyyy-MM-dd
      'uid': uid,
    });

    try {
      final res = await http.post(
        Uri.parse('https://parking-club.com/kalendar/api/events'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento agregado con éxito 🎉')),
        );
        _formKey.currentState!.reset();
        setState(() => _pickedDate = null);
      } else {
        throw Exception('Error ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SidebarScaffold(
      title: 'Agregar evento',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Título ─────────────────────────────────────
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título del evento',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),

              // ── Selector de fecha ─────────────────────────
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _pickedDate == null
                      ? 'Seleccionar fecha'
                      : _pickedDate!.toLocal().toString().substring(0, 10),
                ),
                trailing: const Icon(Icons.edit_calendar),
                tileColor: theme.colorScheme.surfaceVariant,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () async {
                  final today = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: today,
                    firstDate: DateTime(today.year - 1),
                    lastDate: DateTime(today.year + 5),
                    locale: const Locale('es', 'EC'),
                  );
                  if (picked != null) setState(() => _pickedDate = picked);
                },
              ),
              const SizedBox(height: 30),

              // ── Botón Guardar ─────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: _loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Guardar evento'),
                  onPressed: _loading ? null : _saveEvent,
                ),
              ),

              // ── Mensajes ──────────────────────────────────
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
