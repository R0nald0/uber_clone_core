import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_core/src/core/module/payment_controller.dart';
import 'package:uber_clone_core/src/core/types_payment.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:validatorless/validatorless.dart';
    
class PaymentPage extends StatefulWidget {
  final String paymentType;
  const PaymentPage({super.key,required this.paymentType});
  
  @override
  State createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with DialogLoader {
  final _formKey = GlobalKey<FormState>();
  final _valueEC = TextEditingController();
  final _emailEC = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
  

    final PaymentPage(:paymentType) = widget;
    return  Container(
        padding: const EdgeInsets.all(18),
        height: context.heightPercent(.6),
        width: double.infinity,
        child: Form(
         key: _formKey,  
         child: switch(TypesPayment.findByName(widget.paymentType)) {
      TypesPayment.CREDIT_CARD =>creditCardPayment(context, paymentType) ,
      TypesPayment.PIX =>pixPayment(context, paymentType),
      TypesPayment.MONEY=>boletoPayment(context, paymentType),
      TypesPayment.BITCOIN => bitcoinPayment(context, paymentType)      
      },
        )
    );
    
  }
  

  Column creditCardPayment(BuildContext context, String paymentType) {
     final paymentController  = context.get<PaymentController>();
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          paymentType,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500),
        ),
        TextFormField(
          controller: _valueEC,
          keyboardType: TextInputType.number,
          validator: Validatorless.multiple([
            Validatorless.required(
                'Digite um valor válido para transção'),
            Validatorless.number('Valor precisa ser números'),
          ]),
          decoration: const InputDecoration(
              label: Text("Valor da Transação"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(56)),
            onPressed: () {
                switch(_formKey.currentState?.validate()) {
                  case false ||null:
                      callSnackBar('verifique os dados e tente novamente');                            
                  case true:
                    Navigator.pop(context);
                    paymentController.createIntentPayment(_valueEC.text, TypesPayment.CREDIT_CARD);
                    
                }
            },
            child: const Text("CONFIRMAR"))
      ],
    );
  }

  Column pixPayment(BuildContext context, String paymentType) {
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          paymentType,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500),
        ),
        
        TextFormField(
          controller: _valueEC,
          keyboardType: TextInputType.number,
          validator: Validatorless.multiple([
            Validatorless.required(
                'Digite um valor válido para transção'),
            Validatorless.number('Valor precisa ser números'),
          ]),
          decoration: const InputDecoration(
              label: Text("Valor da Transação"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        TextFormField(
          controller: _emailEC,
          keyboardType: TextInputType.emailAddress,
          validator: Validatorless.multiple([
            Validatorless.required('Campo de email obrigátorio'),
            Validatorless.email('E-mail inválido'),
          ]),
          decoration: const InputDecoration(
              label: Text("Chave do Destinátario"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(56)),
            onPressed: () {
                switch(_formKey.currentState?.validate()) {
                  case false ||null:
                      callSnackBar('verifique os dados e tente novamente');                            
                  case true:
                     //chamar controller
                   
                }
            },
            child: const Text("CONFIRMAR"))
      ],
    );
  }
  
  Column bitcoinPayment(BuildContext context, String paymentType) {
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          paymentType,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500),
        ),
        TextFormField(
          controller: _valueEC,
          keyboardType: TextInputType.number,
          validator: Validatorless.multiple([
            Validatorless.required(
                'Digite um valor válido para transção'),
            Validatorless.number('Valor precisa ser números'),
          ]),
          decoration: const InputDecoration(
              label: Text("Valor da Transação"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        TextFormField(
          controller: _emailEC,
          keyboardType: TextInputType.emailAddress,
          validator: Validatorless.multiple([
            Validatorless.required('Campo de email obrigátorio'),
            Validatorless.email('E-mail inválido'),
          ]),
          decoration: const InputDecoration(
              label: Text("Email da Destinátario"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(56)),
            onPressed: () {
                switch(_formKey.currentState?.validate()) {
                  case false ||null:
                      callSnackBar('verifique os dados e tente novamente');                            
                  case true:
                     //chamar controller
                   
                }
            },
            child: const Text("CONFIRMAR COMPRA"))
      ],
    );
  }
  Column boletoPayment(BuildContext context, String paymentType) {
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          paymentType,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500),
        ),
        TextFormField(
          controller: _valueEC,
          keyboardType: TextInputType.number,
          validator: Validatorless.multiple([
            Validatorless.required(
                'Digite um valor válido para transção'),
            Validatorless.number('Valor precisa ser números'),
          ]),
          decoration: const InputDecoration(
              label: Text("Valor da Transação"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        TextFormField(
          controller: _emailEC,
          keyboardType: TextInputType.emailAddress,
          validator: Validatorless.multiple([
            Validatorless.required('Campo de email obrigátorio'),
            Validatorless.email('E-mail inválido'),
          ]),
          decoration: const InputDecoration(
              label: Text("Email da Destinátario"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(56)),
            onPressed: () {
                switch(_formKey.currentState?.validate()) {
                  case false ||null:
                      callSnackBar('verifique os dados e tente novamente');                            
                  case true:
                     //chamar controller
                   
                }
            },
            child: const Text("CONFIRMAR"))
      ],
    );
  }
}