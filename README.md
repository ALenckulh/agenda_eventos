# Agenda do Campus

App Flutter com 2 telas e dados mock: o estudante vê os eventos da semana, filtra por categoria, abre os detalhes e se inscreve.

## Persona

**Beatriz, 20 anos, 4ª fase de Sistemas de Informação.** Abre o app andando entre um bloco e outro, com uma mão só, no intervalo de 15 minutos. Costuma descobrir os eventos tarde e perder as vagas. Como está sempre com pressa, quer ver o que acontece no campus sem precisar procurar. Está acostumada com interfaces de ferramentas de tecnologia (IDEs, GitHub, dashboards) e gosta delas em modo escuro.
- **Dor:** não sabe o que está rolando na semana e só percebe que um evento esgotou quando já é tarde.
- **Objetivo:** achar um evento do interesse dela e garantir a vaga em poucos toques.

## Decisão de interface por causa da persona

Como a Beatriz usa o app com uma mão só, o botão "Inscrever-se" fica fixo na parte de baixo da tela de detalhe, ao alcance do polegar, e o status ("Inscrito" / "Esgotado") aparece direto no card para ela não precisar abrir cada evento.

Outras decisões:
- **Visual "tech"** (fundo escuro com brilho neon, fonte monoespaçada nas etiquetas, ícone de terminal) porque a persona é do curso de Sistemas de Informação e já convive com esse tipo de interface.
- **Botão de tema no header**: ela alterna entre escuro e claro conforme o ambiente (sol forte no pátio, biblioteca à noite).
- **Card "Próximo evento"** no topo da lista, para quem tem só 15 minutos ver de imediato o que vem a seguir.

## Fluxo

1. **Lista de eventos:** filtra por categoria (Todos, Palestra, Oficina, Esporte, Cultura). A lista vira grade de 1, 2 ou 3 colunas conforme a largura (`LayoutBuilder`).
2. **Toque no card:** abre o detalhe do evento.
3. **Inscrever-se:** carregamento de ~1 s e depois um SnackBar de confirmação.
4. **Cancelar inscrição:** pede confirmação em um diálogo antes de cancelar.
5. **Voltar:** o card na lista já mostra o status atualizado (com borda neon). Evento lotado (`e5`) fica com o botão desabilitado e o aviso "Vagas esgotadas".

## Decisões de design

- **Tema único** em `lib/theme/app_theme.dart`: `ColorScheme.fromSeed` (variante vibrante) com seed violeta elétrico, temas claro e escuro. A seed é a única cor escrita à mão; as telas usam `Theme.of(context)`.
- **Efeitos no tema:** `lib/theme/app_glow.dart` é uma `ThemeExtension` com glow neon, sombra suave e gradiente, todos derivados do `ColorScheme`. As telas leem com `AppGlow.of(context)`, então continuam sem cor fixa e os efeitos se adaptam ao modo claro/escuro (mais intensos no escuro).
- **Modo de tema:** começa seguindo o sistema (`ThemeMode.system`) e o botão do header passa a controlar manualmente (`lib/theme/theme_controller.dart`).
- **Componentes no tema:** `cardTheme`, `filledButtonTheme`, `outlinedButtonTheme`, `chipTheme`, `appBarTheme`, `dialogTheme` e `snackBarTheme`. O `textTheme` é ajustado com `copyWith`.
- **Contraste:** sempre pares do mesmo papel (`primaryContainer`/`onPrimaryContainer`, `errorContainer`/`onErrorContainer` etc.). O status nunca depende só de cor: há texto e ícone.
- **Responsividade:** sem larguras fixas de conteúdo. Os cards de uma linha da grade têm a mesma altura via `IntrinsicHeight`, então continuam corretos com fonte ampliada. Textos longos usam `maxLines` + `ellipsis`.
- **Padding adaptativo:** 16 dp no celular e 24 dp em telas largas (`MediaQuery.sizeOf`).
- **Acessibilidade:** alvos de toque de no mínimo 48 dp, tooltip no botão de tema, `Semantics` descritivo nos cards, tamanho de fonte do sistema respeitado.

## Estrutura

```
lib/
├── main.dart
├── theme/
│   ├── app_theme.dart         # ColorScheme.fromSeed + ThemeData
│   ├── app_glow.dart          # ThemeExtension: neon, sombras, gradiente
│   └── theme_controller.dart  # modo claro/escuro (system + manual)
├── data/eventos_mock.dart
├── screens/
│   ├── eventos_screen.dart
│   └── evento_detalhe_screen.dart
└── widgets/
    ├── evento_badge.dart        # etiqueta (categoria / Inscrito / Esgotado)
    ├── info_linha.dart          # linha ícone + texto
    ├── glow_card.dart           # card com sombra e borda neon
    ├── neon_glow.dart           # halo neon animado
    ├── neon_backdrop.dart       # fundo com manchas de luz
    ├── vagas_bar.dart           # barra de vagas em gradiente
    └── theme_toggle_button.dart # botão de tema do header
```
