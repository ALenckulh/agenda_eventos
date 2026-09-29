import 'package:flutter/material.dart';

import 'screens/eventos_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() => runApp(const AgendaApp());

/// Raiz do app: o tema é definido uma única vez aqui e lido nas telas
/// com Theme.of(context). O modo começa seguindo o sistema e pode ser
/// alternado pelo botão do header.
class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, modo, child) {
        return MaterialApp(
          title: 'Agenda do Campus',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: modo,
          home: const EventosScreen(),
        );
      },
    );
  }
}
