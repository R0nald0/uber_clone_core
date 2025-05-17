enum RequestState {
  nao_chamado(name: "Não Chamado",value: 'nao_chamado'),
  aguardando(name: "Aguardando Motorista",value: 'aguardando'),
  a_caminho( name :'A caminho',value: 'a_caminho'),
  em_viagem(name: 'Em viagem',value: 'em_viagem'),
  finalizado(name: 'Finalizido',value: 'finalizado'),
  pagamento_confirmado(name: 'Pagamento confirmado',value:'pagamento_confirmado'),
  cancelado(name: 'Cancelado',value: 'cancelado');

  final String name;
  final String value;
  const RequestState({required this.name,required this.value});

 RequestState findByName(String status){
     return switch(status){
        'nao_chamado' => RequestState.nao_chamado,
        'aguardando' => RequestState.aguardando,
        'a_caminho' => RequestState.a_caminho,
        'em_viagem' => RequestState.em_viagem,
        'finalizado' => RequestState.finalizado,
        'pagamento_confirmado' => RequestState.pagamento_confirmado,
        'cancelado' => RequestState.cancelado,
        _ => RequestState.nao_chamado
      };

 }


}