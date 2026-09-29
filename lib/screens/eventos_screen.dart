import 'package:flutter/material.dart';

import '../data/eventos_mock.dart';
import '../theme/app_glow.dart';
import '../widgets/evento_badge.dart';
import '../widgets/glow_card.dart';
import '../widgets/info_linha.dart';
import '../widgets/neon_backdrop.dart';
import '../widgets/neon_glow.dart';
import '../widgets/theme_toggle_button.dart';
import 'evento_detalhe_screen.dart';

/// Tela 1: lista de eventos com filtro por categoria.
/// A lista vira grade (1, 2 ou 3 colunas) conforme a largura disponível.
class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  static const _categorias = [
    'Todos',
    'Palestra',
    'Oficina',
    'Esporte',
    'Cultura',
  ];
  static const double _espaco = 16;

  final Set<String> _inscritos = {};
  String _categoriaAtual = 'Todos';

  List<Evento> get _todosOrdenados =>
      [...eventosMock]..sort((a, b) => a.dataHora.compareTo(b.dataHora));

  List<Evento> get _filtrados => _todosOrdenados
      .where((e) => _categoriaAtual == 'Todos' || e.categoria == _categoriaAtual)
      .toList();

  /// Breakpoints: <600 = 1 coluna, 600–839 = 2, >=840 = 3.
  int _colunasPara(double largura) {
    if (largura >= 840) return 3;
    if (largura >= 600) return 2;
    return 1;
  }

  void _abrirDetalhe(Evento evento) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventoDetalheScreen(
          evento: evento,
          inscritoInicial: _inscritos.contains(evento.id),
          onInscricaoChanged: (inscrito) {
            setState(() {
              if (inscrito) {
                _inscritos.add(evento.id);
              } else {
                _inscritos.remove(evento.id);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final pad = MediaQuery.sizeOf(context).width >= 600 ? 24.0 : 16.0;
    final eventos = _filtrados;
    final proximo = _todosOrdenados.first;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: pad,
        title: Row(
          children: [
            _construirLogo(context),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Agenda do Campus',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          const ThemeToggleButton(),
          SizedBox(width: pad - 4),
        ],
      ),
      body: NeonBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final colunas = _colunasPara(constraints.maxWidth);
              final linhas = (eventos.length / colunas).ceil();

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(pad, 20, pad, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eventos da semana', style: text.headlineSmall),
                          const SizedBox(height: 4),
                          Text(
                            eventos.length == 1
                                ? '1 evento encontrado'
                                : '${eventos.length} eventos encontrados',
                            style: text.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _construirDestaque(context, proximo),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              for (final categoria in _categorias)
                                _construirChip(context, categoria),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (eventos.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _construirVazio(context),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(pad, 4, pad, pad),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, indice) => _construirLinha(
                            context,
                            eventos,
                            indice * colunas,
                            colunas,
                          ),
                          childCount: linhas,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _construirLogo(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return NeonGlow(
      raio: 10,
      intensidade: 0.8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.terminal, size: 20, color: scheme.onPrimary),
        ),
      ),
    );
  }

  Widget _construirChip(BuildContext context, String categoria) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final selecionado = categoria == _categoriaAtual;

    return ChoiceChip(
      label: Text(categoria),
      selected: selecionado,
      selectedColor: scheme.primaryContainer,
      backgroundColor: scheme.surfaceContainerLow,
      side: BorderSide(
        color: selecionado ? scheme.primary : scheme.outlineVariant,
        width: selecionado ? 1.5 : 1,
      ),
      labelStyle: text.labelLarge?.copyWith(
        color: selecionado ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
        fontWeight: selecionado ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) => setState(() => _categoriaAtual = categoria),
    );
  }

  /// Banner com o próximo evento, com borda em gradiente e brilho neon.
  Widget _construirDestaque(BuildContext context, Evento evento) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final glow = AppGlow.of(context);

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: 'Próximo evento: ${evento.nome}. '
          '${evento.dataCurta}, ${evento.horario}. ${evento.local}.',
      onTap: () => _abrirDetalhe(evento),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: glow.gradiente,
          borderRadius: BorderRadius.circular(20),
          boxShadow: glow.neonGlow(intensidade: 0.7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.5),
            child: Material(
              color: scheme.surfaceContainerLow,
              child: InkWell(
                onTap: () => _abrirDetalhe(evento),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bolt, size: 18, color: scheme.primary),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'PRÓXIMO EVENTO',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: text.labelMedium?.copyWith(
                                      color: scheme.primary,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              evento.nome,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            InfoLinha(
                              icone: Icons.event_outlined,
                              valor: '${evento.dataCurta} · ${evento.horario}',
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            InfoLinha(
                              icone: Icons.place_outlined,
                              valor: evento.local,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.arrow_forward, color: scheme.primary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Uma linha da grade. IntrinsicHeight iguala a altura dos cards da linha
  /// sem fixar altura, então funciona com qualquer tamanho de fonte.
  Widget _construirLinha(
    BuildContext context,
    List<Evento> eventos,
    int inicio,
    int colunas,
  ) {
    final filhos = <Widget>[];
    for (var c = 0; c < colunas; c++) {
      if (c > 0) filhos.add(const SizedBox(width: _espaco));
      final i = inicio + c;
      filhos.add(
        Expanded(
          child: i < eventos.length
              ? _construirCard(context, eventos[i])
              : const SizedBox.shrink(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: _espaco),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: filhos,
        ),
      ),
    );
  }

  Widget _construirCard(BuildContext context, Evento evento) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final inscrito = _inscritos.contains(evento.id);
    final esgotado = !inscrito && evento.lotado;
    final restantes = evento.vagas - evento.inscritos - (inscrito ? 1 : 0);

    final String vagasTexto;
    if (restantes <= 0) {
      vagasTexto = 'Sem vagas';
    } else if (restantes == 1) {
      vagasTexto = '1 vaga restante';
    } else {
      vagasTexto = '$restantes vagas restantes';
    }

    final descricao = StringBuffer()
      ..write('${evento.categoria}: ${evento.nome}. ')
      ..write('${evento.dataCurta}, ${evento.horario}. ')
      ..write('${evento.local}. $vagasTexto.');
    if (inscrito) descricao.write(' Você está inscrito.');
    if (esgotado) descricao.write(' Vagas esgotadas.');

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: descricao.toString(),
      onTap: () => _abrirDetalhe(evento),
      child: GlowCard(
        destaque: inscrito,
        onTap: () => _abrirDetalhe(evento),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                if (inscrito)
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
            Text(
              evento.nome,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InfoLinha(
              icone: Icons.event_outlined,
              valor: '${evento.dataCurta} · ${evento.horario}',
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            InfoLinha(
              icone: Icons.place_outlined,
              valor: evento.local,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            InfoLinha(
              icone: Icons.group_outlined,
              valor: vagasTexto,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirVazio(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            'Nenhum evento nesta categoria',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() => _categoriaAtual = 'Todos'),
            child: const Text('Ver todos os eventos'),
          ),
        ],
      ),
    );
  }
}
