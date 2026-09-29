import 'package:flutter/material.dart';

/// Linha com ícone e texto.
/// - Sem [rotulo]: versão compacta (usada nos cards da lista).
/// - Com [rotulo]: versão de detalhe (rótulo pequeno + valor em destaque).
class InfoLinha extends StatelessWidget {
  const InfoLinha({
    super.key,
    required this.icone,
    required this.valor,
    this.rotulo,
    this.maxLines,
  });

  final IconData icone;
  final String valor;
  final String? rotulo;

  /// Limita as linhas do valor (com reticências). Nulo = sem limite.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final overflow = maxLines == null ? null : TextOverflow.ellipsis;

    if (rotulo == null) {
      return Row(
        children: [
          Icon(icone, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              valor,
              maxLines: maxLines,
              overflow: overflow,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 24, color: scheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo!,
                style: text.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                maxLines: maxLines,
                overflow: overflow,
                style: text.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
