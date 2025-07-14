import 'package:flutter/material.dart';
import 'ui/pages/sidebar/calendar_page.dart';
import 'ui/pages/sidebar/add_event_page.dart';
import 'ui/pages/sidebar/info_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/login_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/calendar':
      return MaterialPageRoute(builder: (_) => const CalendarPage());
    case '/add-event':
      return MaterialPageRoute(builder: (_) => const AddEventPage());
    case '/info':
      return MaterialPageRoute(builder: (_) => const InfoPage());
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    default:
      return MaterialPageRoute(builder: (_) => const HomePage());
  }
}
