enum TypesPayment {
  PIX('Pix'),
  MONEY('Dinheiro'),
  BITCOIN("Bitcoin"),
  CREDIT_CARD("Cartão de Crédito");

  final String name;

  const TypesPayment(this.name);

  static TypesPayment findByName(String status){
     return switch(status){
         'Pix' => TypesPayment.PIX,
         'Bitcoin' =>TypesPayment.MONEY,
         'Dinheiro' =>TypesPayment.BITCOIN,
         'Cartão de Crédito' =>TypesPayment.CREDIT_CARD,

        _ => TypesPayment.MONEY
      };

 }

}


