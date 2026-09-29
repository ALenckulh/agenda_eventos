import 'package:flutter/material.dart';

/// Efeitos visuais do app (glow neon, sombras, gradiente), todos derivados
/// do ColorScheme. Vive no tema, então as telas só fazem AppGlow.of(context).
@immutable
class AppGlow extends ThemeExtension<AppGlow> {
  const AppGlow({
    required this.neon,
    required this.neonSecundario,
    required this.sombra,
    required this.escuro,
  });

  factory AppGlow.from(ColorScheme scheme) => AppGlow(
        neon: scheme.primary,
        neonSecundario: scheme.tertiary,
        sombra: scheme.shadow,
        escuro: scheme.brightness == Brightness.dark,
      );

  static AppGlow of(BuildContext context) =>
      Theme.of(context).extension<AppGlow>()!;

  final Color neon;
  final Color neonSecundario;
  final Color sombra;
  final bool escuro;

  /// Gradiente da marca (primária -> terciária).
  LinearGradient get gradiente => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [neon, neonSecundario],
      );

  /// Brilho neon em duas camadas (halo próximo + halo difuso).
  List<BoxShadow> neonGlow({double intensidade = 1}) => [
        BoxShadow(
          color: neon.withValues(alpha: (escuro ? 0.45 : 0.30) * intensidade),
          blurRadius: 14,
        ),
        BoxShadow(
          color: neon.withValues(alpha: (escuro ? 0.25 : 0.16) * intensidade),
          blurRadius: 32,
          spreadRadius: 2,
        ),
      ];

  /// Sombra suave de elevação para cards em repouso.
  List<BoxShadow> get sombraSuave => [
        BoxShadow(
          color: sombra.withValues(alpha: escuro ? 0.45 : 0.10),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  AppGlow copyWith({
    Color? neon,
    Color? neonSecundario,
    Color? sombra,
    bool? escuro,
  }) =>
      AppGlow(
        neon: neon ?? this.neon,
        neonSecundario: neonSecundario ?? this.neonSecundario,
        sombra: sombra ?? this.sombra,
        escuro: escuro ?? this.escuro,
      );

  @override
  AppGlow lerp(ThemeExtension<AppGlow>? other, double t) {
    if (other is! AppGlow) return this;
    return AppGlow(
      neon: Color.lerp(neon, other.neon, t)!,
      neonSecundario: Color.lerp(neonSecundario, other.neonSecundario, t)!,
      sombra: Color.lerp(sombra, other.sombra, t)!,
      escuro: t < 0.5 ? escuro : other.escuro,
    );
  }
}
