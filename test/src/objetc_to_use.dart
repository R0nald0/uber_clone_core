import 'package:decimal/decimal.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
 
sealed class ObjetcToUse {
   static final mapRequest =  [
  {
    'id': 'REQ0000000000000001',
    'bairro': 'Centro',
    'valorCorrida': 23.50,
    'status': 'Concluído',
    'passageiroNome': 'João Silva',
    'motoristaNome': 'Maria Oliveira',
    'request_date': '2025-06-02 14:30:00',
    'payment_type': 'Cartão de Crédito',
  },
  {
    'id': 'REQ0000000000000002',
    'bairro': 'Bela Vista',
    'valorCorrida': 42.75,
    'status': 'Cancelado',
    'passageiroNome': 'Ana Costa',
    'motoristaNome': 'Carlos Lima',
    'request_date': '2025-06-01 09:15:00',
    'payment_type': 'Dinheiro',
  },
  {
    'id': 'REQ0000000000000003',
    'bairro': 'Jardins',
    'valorCorrida': 35.20,
    'status': 'Em Andamento',
    'passageiroNome': 'Pedro Souza',
    'motoristaNome': 'Fernanda Rocha',
    'request_date': '2025-06-03 19:00:00',
    'payment_type': 'Pix',
  },
];

      
}
  

/* Usuario usuario1 = Usuario(
    idUsuario: 'u001',
    email: 'joao@email.com',
    nome: 'João Silva',
    tipoUsuario: 'passageiro',
    senha: 'senha123',
    latitude: -23.5505,
    longitude: -46.6333,
    idRequisicaoAtiva: null,
    balance: Decimal.parse('150.75'),
  ); */

  Usuario usuario2 = Usuario(
    idUsuario: 'u002',
    email: 'maria@email.com',
    nome: 'Maria Oliveira',
    tipoUsuario: 'motorista',
    senha: 'senha456',
    latitude: -22.9068,
    longitude: -43.1729,
    idRequisicaoAtiva: 'req987',
    balance: Decimal.parse('0.0'),
  );