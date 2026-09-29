import 'package:flutter/material.dart';

import '../theme/app_glow.dart';

/// Card moderno: sombra suave em repouso e, com [destaque], borda + brilho
/// neon. Com [onTap] vira tocável, com ripple.
class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.destaque = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool destaque;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glow = AppGlow.of(context);
    final raio = BorderRadius.circular(20);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: raio,
        border: Border.all(
          color: destaque ? scheme.primary : scheme.outlineVariant,
          width: destaque ? 1.5 : 1,
        ),
        boxShadow:
            destaque ? glow.neonGlow(intensidade: 0.7) : glow.sombraSuave,
      ),
      child: ClipRRect(
        borderRadius: raio,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
