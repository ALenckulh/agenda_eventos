import 'package:flutter/material.dart';

/// Ícone representativo de cada categoria.
IconData iconeDaCategoria(String categoria) {
  switch (categoria) {
    case 'Palestra':
      return Icons.mic_none;
    case 'Oficina':
      return Icons.build_outlined;
    case 'Esporte':
      return Icons.sports_soccer_outlined;
    case 'Cultura':
      return Icons.theater_comedy_outlined;
    default:
      return Icons.event_outlined;
  }
}

/// Etiqueta pequena (categoria, "Inscrito", "Esgotado"), em fonte
/// monoespaçada para o visual "tech". Sempre recebe um par de cores com
/// contraste (fundo + texto do mesmo papel).
class EventoBadge extends StatelessWidget {
  const EventoBadge({
    super.key,
    required this.rotulo,
    required this.icone,
    required this.fundo,
    required this.texto,
  });

  final String rotulo;
  final IconData icone;
  final Color fundo;
  final Color texto;

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.labelMedium;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 16, color: texto),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                rotulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: estilo?.copyWith(
                  color: texto,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
