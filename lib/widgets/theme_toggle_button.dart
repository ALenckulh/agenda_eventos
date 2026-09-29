import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';

/// Botão do header que alterna entre tema escuro e claro.
/// Área de toque de 48 dp e tooltip para leitores de tela.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final brilho = Theme.of(context).brightness;
    final escuro = brilho == Brightness.dark;

    return IconButton.filledTonal(
      tooltip: escuro ? 'Mudar para o tema claro' : 'Mudar para o tema escuro',
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      onPressed: () => ThemeController.instance.alternar(brilho),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animacao) => RotationTransition(
          turns: Tween<double>(begin: 0.75, end: 1).animate(animacao),
          child: FadeTransition(opacity: animacao, child: child),
        ),
        child: Icon(
          escuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey<bool>(escuro),
        ),
      ),
    );
  }
}
