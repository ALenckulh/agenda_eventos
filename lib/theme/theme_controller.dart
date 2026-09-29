import 'package:flutter/material.dart';

/// Guarda o ThemeMode do app. Começa seguindo o sistema (ThemeMode.system)
/// e passa a ser manual quando o usuário toca no botão do header.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.system);

  static final ThemeController instance = ThemeController._();

  /// Alterna para o oposto do brilho que está sendo exibido agora.
  void alternar(Brightness brilhoAtual) {
    value = brilhoAtual == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
