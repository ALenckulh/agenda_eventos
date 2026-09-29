import 'package:flutter/material.dart';

import '../data/eventos_mock.dart';
import '../theme/app_glow.dart';
import '../widgets/evento_badge.dart';
import '../widgets/glow_card.dart';
import '../widgets/info_linha.dart';
import '../widgets/neon_backdrop.dart';
import '../widgets/neon_glow.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/vagas_bar.dart';

/// Tela 2: detalhes do evento, barra de vagas e botão de inscrição
/// fixo na base da tela (zona do polegar).
class EventoDetalheScreen extends StatefulWidget {
  const EventoDetalheScreen({
    super.key,
    required this.evento,
    required this.inscritoInicial,
    required this.onInscricaoChanged,
  });

  final Evento evento;
  final bool inscritoInicial;

  /// Avisa a lista assim que a inscrição muda, para o card já estar
  /// atualizado quando o usuário voltar (inclusive pelo gesto do sistema).
  final ValueChanged<bool> onInscricaoChanged;

  @override
  State<EventoDetalheScreen> createState() => _EventoDetalheScreenState();
}

class _EventoDetalheScreenState extends State<EventoDetalheScreen> {
  /// Limite de leitura em telas largas (não é largura fixa de conteúdo).
  static const double _larguraMaxima = 640;

  late bool _inscrito = widget.inscritoInicial;
  bool _carregando = false;

  int get _ocupadas => widget.evento.inscritos + (_inscrito ? 1 : 0);
  int get _restantes => widget.evento.vagas - _ocupadas;

  void _avisar(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _inscrever() async {
    setState(() => _carregando = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _carregando = false;
      _inscrito = true;
    });
    widget.onInscricaoChanged(true);
    _avisar('Inscrição confirmada em "${widget.evento.nome}".');
  }

  Future<void> _cancelar() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar inscrição?'),
        content: Text(
          'Você vai liberar sua vaga em "${widget.evento.nome}". '
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Manter inscrição'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancelar inscrição'),
          ),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;

    setState(() => _inscrito = false);
    widget.onInscricaoChanged(false);
    _avisar('Inscrição cancelada.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final evento = widget.evento;
    final pad = MediaQuery.sizeOf(context).width >= 600 ? 24.0 : 16.0;
    final esgotado = !_inscrito && evento.lotado;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Detalhes do evento'),
        actions: [
          const ThemeToggleButton(),
          SizedBox(width: pad - 4),
        ],
      ),
      body: NeonBackdrop(
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _larguraMaxima),
              child: ListView(
                padding: EdgeInsets.all(pad),
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      EventoBadge(
                        rotulo: evento.categoria,
                        icone: iconeDaCategoria(evento.categoria),
                        fundo: scheme.secondaryContainer,
                        texto: scheme.onSecondaryContainer,
                      ),
                      if (_inscrito)
                        EventoBadge(
                          rotulo: 'Inscrito',
                          icone: Icons.check_circle_outline,
                          fundo: scheme.primaryContainer,
                          texto: scheme.onPrimaryContainer,
                        ),
                      if (esgotado)
                        EventoBadge(
                          rotulo: 'Esgotado',
                          icone: Icons.block,
                          fundo: scheme.errorContainer,
                          texto: scheme.onErrorContainer,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(evento.nome, style: text.headlineSmall),
                  const SizedBox(height: 20),
                  GlowCard(
                    destaque: _inscrito,
                    child: Column(
                      children: [
                        InfoLinha(
                          icone: Icons.event_outlined,
                          rotulo: 'Data',
                          valor: evento.dataCompleta,
                        ),
                        const SizedBox(height: 16),
                        InfoLinha(
                          icone: Icons.schedule_outlined,
                          rotulo: 'Horário',
                          valor: evento.horario,
                        ),
                        const SizedBox(height: 16),
                        InfoLinha(
                          icone: Icons.place_outlined,
                          rotulo: 'Local',
                          valor: evento.local,
                        ),
                        const SizedBox(height: 16),
                        InfoLinha(
                          icone: Icons.person_outline,
                          rotulo: 'Responsável',
                          valor: evento.responsavel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Sobre o evento', style: text.titleMedium),
                  const SizedBox(height: 8),
                  Text(evento.descricao, style: text.bodyLarge),
                  const SizedBox(height: 24),
                  _construirVagas(context),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _construirBarraInferior(context, pad, esgotado),
    );
  }

  Widget _construirVagas(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final vagas = widget.evento.vagas;
    final semVagas = _restantes <= 0;
    final proporcao = (_ocupadas / vagas).clamp(0.0, 1.0);

    final String restantesTexto;
    if (semVagas) {
      restantesTexto = 'Sem vagas restantes';
    } else if (_restantes == 1) {
      restantesTexto = 'Resta 1 vaga';
    } else {
      restantesTexto = 'Restam $_restantes vagas';
    }

    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vagas', style: text.titleMedium),
          const SizedBox(height: 12),
          VagasBar(
            proporcao: proporcao,
            semVagas: semVagas,
            valorSemantico: '$_ocupadas de $vagas',
          ),
          const SizedBox(height: 12),
          Text(
            '$_ocupadas de $vagas vagas ocupadas',
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(
            restantesTexto,
            style: text.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: semVagas ? scheme.error : scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBarraInferior(
    BuildContext context,
    double pad,
    bool esgotado,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final glow = AppGlow.of(context);

    final Widget botao;
    if (_inscrito) {
      botao = OutlinedButton(
        onPressed: _cancelar,
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.error,
          side: BorderSide(color: scheme.error),
        ),
        child: const Text('Cancelar inscrição'),
      );
    } else if (_carregando) {
      botao = const FilledButton(
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(width: 12),
            Text('Inscrevendo...'),
          ],
        ),
      );
    } else {
      botao = FilledButton(
        onPressed: esgotado ? null : _inscrever,
        child: const Text('Inscrever-se'),
      );
    }

    final comBrilho = !_inscrito && !_carregando && !esgotado;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: glow.sombra.withValues(alpha: glow.escuro ? 0.5 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 12),
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _larguraMaxima),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (esgotado) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.block, size: 18, color: scheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'Vagas esgotadas',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: scheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  NeonGlow(ativo: comBrilho, child: botao),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
