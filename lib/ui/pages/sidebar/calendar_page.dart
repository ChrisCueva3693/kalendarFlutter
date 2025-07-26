import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/sidebar_scaffold.dart';
import 'event_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // ── estado de UI ──────────────────────────────────────────────
  late final ValueNotifier<List<MyEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _loading = true;
  String? _error;

  // ── eventos por fecha ────────────────────────────────────────
  final Map<DateTime, List<MyEvent>> _events = {};

  List<MyEvent> _getEventsForDay(DateTime day) =>
      _events[_stripTime(day)] ?? [];

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(const []);
    _fetchEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _loading = false;
        _error = 'Sesión no válida';
      });
      return;
    }

    final url =
    Uri.parse('https://parking-club.com/kalendar/api/events/uid/$uid');

    try {
      final res = await http.get(url);
      if (res.statusCode != 200) throw Exception('Error ${res.statusCode}');

      final List data = jsonDecode(res.body);
      _events.clear();

      for (final e in data) {
        final date = DateTime.parse(e['eventDate']); // yyyy-MM-dd
        final key = _stripTime(date);
        _events.putIfAbsent(key, () => []);
        _events[key]!.add(MyEvent(e['title']));
      }

      _selectedEvents.value = _getEventsForDay(_selectedDay!);
      setState(() {
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  // ── UI ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SidebarScaffold(
      title: 'Calendario',
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-event'),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 56, color: Colors.red),
            const SizedBox(height: 8),
            Text('Error:\n$_error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
          ],
        ),
      )
          : Column(
        children: [
          TableCalendar<MyEvent>(
            locale: 'es_EC',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              markersAlignment: Alignment.bottomCenter,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
              _selectedEvents.value = _getEventsForDay(selected);
            },
            onFormatChanged: (f) =>
                setState(() => _calendarFormat = f),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchEvents,
              child: ValueListenableBuilder<List<MyEvent>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 80),
                        Center(child: Text('Sin eventos')),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    itemCount: value.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (_, index) => Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.event,
                            color: theme.colorScheme.primary),
                        title: Text(value[index].title,
                            style:
                            theme.textTheme.titleMedium),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
