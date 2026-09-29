/// Modelo de evento e dados fictícios da Agenda de Eventos do Campus.
class Evento {
  const Evento({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.dataHora,
    required this.local,
    required this.responsavel,
    required this.descricao,
    required this.vagas,
    required this.inscritos,
  });

  final String id;
  final String nome;
  final String categoria; // Palestra, Oficina, Esporte, Cultura
  final DateTime dataHora;
  final String local;
  final String responsavel;
  final String descricao;
  final int vagas;
  final int inscritos;

  /// Evento sem vagas para novos inscritos.
  bool get lotado => inscritos >= vagas;
}

const _diasSemana = [
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
  'Domingo',
];

const _mesesCurtos = [
  'jan',
  'fev',
  'mar',
  'abr',
  'mai',
  'jun',
  'jul',
  'ago',
  'set',
  'out',
  'nov',
  'dez',
];

const _mesesLongos = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

/// Formatações em português, sem depender de pacotes externos.
extension EventoFormatacao on Evento {
  /// Ex.: "Seg, 5 out"
  String get dataCurta {
    final dia = _diasSemana[dataHora.weekday - 1].substring(0, 3);
    return '$dia, ${dataHora.day} ${_mesesCurtos[dataHora.month - 1]}';
  }

  /// Ex.: "Segunda-feira, 5 de outubro"
  String get dataCompleta {
    final dia = _diasSemana[dataHora.weekday - 1];
    final sufixo = dataHora.weekday <= 5 ? '-feira' : '';
    return '$dia$sufixo, ${dataHora.day} de ${_mesesLongos[dataHora.month - 1]}';
  }

  /// Ex.: "19h" ou "18h30"
  String get horario {
    final minutos = dataHora.minute;
    if (minutos == 0) return '${dataHora.hour}h';
    return '${dataHora.hour}h${minutos.toString().padLeft(2, '0')}';
  }
}

final List<Evento> eventosMock = [
  Evento(
    id: 'e1',
    nome: 'IA Generativa no Dia a Dia',
    categoria: 'Palestra',
    dataHora: DateTime(2026, 10, 5, 19),
    local: 'Auditório Central',
    responsavel: 'Profa. Marina Costa',
    descricao:
        'Como ferramentas de IA estão mudando o desenvolvimento de software.',
    vagas: 120,
    inscritos: 87,
  ),
  Evento(
    id: 'e2',
    nome: 'Oficina de Flutter: do zero ao APK',
    categoria: 'Oficina',
    dataHora: DateTime(2026, 10, 6, 14),
    local: 'Laboratório 3',
    responsavel: 'Prof. André Lima',
    descricao: 'Mão na massa: crie e publique seu primeiro app.',
    vagas: 30,
    inscritos: 28,
  ),
  Evento(
    id: 'e3',
    nome: 'Torneio de Vôlei Interfases',
    categoria: 'Esporte',
    dataHora: DateTime(2026, 10, 7, 18, 30),
    local: 'Ginásio',
    responsavel: 'Atlética',
    descricao: 'Monte seu time e represente sua fase!',
    vagas: 64,
    inscritos: 40,
  ),
  Evento(
    id: 'e4',
    nome: 'Sarau Cultural',
    categoria: 'Cultura',
    dataHora: DateTime(2026, 10, 8, 20),
    local: 'Praça de Convivência',
    responsavel: 'DCE',
    descricao: 'Música, poesia e apresentações dos estudantes.',
    vagas: 200,
    inscritos: 95,
  ),
  Evento(
    id: 'e5',
    nome: 'Carreira em UX Design',
    categoria: 'Palestra',
    dataHora: DateTime(2026, 10, 9, 10),
    local: 'Sala 204',
    responsavel: 'Convidada: Júlia Reis',
    descricao: 'O que faz um UX designer e como entrar na área.',
    vagas: 60,
    inscritos: 60,
  ),
  Evento(
    id: 'e6',
    nome: 'Git e GitHub para Iniciantes',
    categoria: 'Oficina',
    dataHora: DateTime(2026, 10, 10, 16),
    local: 'Laboratório 1',
    responsavel: 'Monitoria de ES',
    descricao: 'Commits, branches e pull requests sem medo.',
    vagas: 25,
    inscritos: 12,
  ),
];
