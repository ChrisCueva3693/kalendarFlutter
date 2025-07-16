import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/sidebar_scaffold.dart';
import 'event_model.dart';
import 'package:flutter/services.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // ──────────────────────────────────────────────────────────────────────
  late final ValueNotifier<List<MyEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<MyEvent>> _events = {
    // Ejemplo de eventos hard-codeados
    DateTime.utc(2025, 7, 14): [const MyEvent('Reunión de equipo')],
    DateTime.utc(2025, 7, 20): [
      const MyEvent('Entrega del proyecto'),
      const MyEvent('Cumpleaños de Ana')
    ],
  };

  List<MyEvent> _getEventsForDay(DateTime day) =>
      _events[DateTime.utc(day.year, day.month, day.day)] ?? [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SidebarScaffold(
      title: 'Calendario',
      body: Column(
        children: [
          TableCalendar<MyEvent>(
            locale: 'es_EC',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day), // subraya seleccionado
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              todayDecoration:
              BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
              selectedDecoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
              _selectedEvents.value = _getEventsForDay(selected);
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<MyEvent>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return const Center(child: Text('Sin eventos'));
                }
                return ListView.separated(
                  itemCount: value.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (_, index) => ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(value[index].title),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
