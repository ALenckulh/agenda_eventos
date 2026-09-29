import 'package:flutter/material.dart';

import '../theme/app_glow.dart';

/// Envolve um widget com o brilho neon do tema (animado ao ligar/desligar).
class NeonGlow extends StatelessWidget {
  const NeonGlow({
    super.key,
    required this.child,
    this.ativo = true,
    this.raio = 14,
    this.intensidade = 1,
  });

  final Widget child;
  final bool ativo;
  final double raio;
  final double intensidade;

  @override
  Widget build(BuildContext context) {
    final glow = AppGlow.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raio),
        boxShadow: ativo
            ? glow.neonGlow(intensidade: intensidade)
            : const <BoxShadow>[],
      ),
      child: child,
    );
  }
}
