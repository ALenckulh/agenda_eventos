import 'package:flutter/material.dart';

/// Barra de vagas ocupadas: preenchimento em gradiente com brilho neon e
/// animação. Fica vermelha (error) quando não há mais vagas.
class VagasBar extends StatelessWidget {
  const VagasBar({
    super.key,
    required this.proporcao,
    required this.semVagas,
    required this.valorSemantico,
  });

  /// De 0.0 a 1.0.
  final double proporcao;
  final bool semVagas;

  /// Texto lido pelo leitor de tela, ex.: "87 de 120".
  final String valorSemantico;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final corInicio = semVagas ? scheme.error : scheme.primary;
    final corFim = semVagas ? scheme.error : scheme.tertiary;
    final raio = BorderRadius.circular(999);

    return Semantics(
      label: 'Vagas ocupadas',
      value: valorSemantico,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: raio,
          ),
          child: SizedBox(
            height: 12,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: proporcao),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, valor, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: valor,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: raio,
                        gradient: LinearGradient(colors: [corInicio, corFim]),
                        boxShadow: [
                          BoxShadow(
                            color: corInicio.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
