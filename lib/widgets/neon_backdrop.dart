import 'package:flutter/material.dart';

import '../theme/app_glow.dart';

/// Fundo com duas manchas de luz neon (canto superior direito e inferior
/// esquerdo). Os tamanhos vêm da tela (MediaQuery), sem valores fixos.
class NeonBackdrop extends StatelessWidget {
  const NeonBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final glow = AppGlow.of(context);
    final lado = MediaQuery.sizeOf(context).shortestSide;
    final opacidade = glow.escuro ? 0.22 : 0.12;

    Widget mancha(Color cor) {
      return IgnorePointer(
        child: SizedBox.square(
          dimension: lado,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cor.withValues(alpha: opacidade),
                  cor.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned(
          top: -lado * 0.35,
          right: -lado * 0.3,
          child: mancha(glow.neon),
        ),
        Positioned(
          bottom: -lado * 0.4,
          left: -lado * 0.4,
          child: mancha(glow.neonSecundario),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
