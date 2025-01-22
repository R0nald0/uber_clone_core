import 'package:flutter/material.dart';

mixin DialogLoader<e extends StatefulWidget> on State<e> {
  void showLoaderDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (contextDialog) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void hideLoader() {
    Navigator.pop(context);
  }
  
  void dialogLocationPermissionDenied(VoidCallback onPositiveButton) {
    showDialog(
        context: context,
        builder: (alertContext) {
          return AlertDialog(
            content: const Text(
                'Perciasamos da sua localizaão para realizar a melhor rota para sua viagem'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Não Permitir')),
              TextButton(
                  onPressed: () {
                    onPositiveButton();
                    Navigator.pop(context);
                  },
                  child: const Text('Permitir'))
            ],
          );
        });
  }

  void dialogLocationPermissionDeniedForeve(VoidCallback onPositiveButton) {
    showDialog(
        context: context,
        builder: (alertContext) {
          return AlertDialog(
            content: const Text(
                'Perciasamos da sua localizaão para realizar a melhor rota para sua viagem  assim voc^poderá ter uma melhor experiência ao utlilizar o Uber'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Não Permitir')),
              TextButton(
                  onPressed: () {
                    onPositiveButton();
                    Navigator.pop(context);
                  },
                  child: const Text('Configurações'))
            ],
          );
        });
  }

  void callSnackBar(String erro) {
    final snackBar = SnackBar(content: Text(erro),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

   void callInfoSnackBar(String info) {
    final snackBar = SnackBar(content: Text(info),backgroundColor: Colors.black,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showTripDialogValues(String price,VoidCallback onPositiveButton){
    
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (alertContext) {
           final theme = Theme.of(alertContext);
          return AlertDialog(
            titlePadding: const EdgeInsets.all(16),

            title:  Center(child: Text('Viagem Finalizada',
             style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) ,
            )) ,
            content: RichText(
              text:  TextSpan(
                style: theme.textTheme.labelLarge,
                text: 'Valor da viagem ',
                children: [
                   TextSpan(text: 'R\$ $price',style: theme.textTheme.bodyLarge
                         ?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          ))
                ] 
              )
              ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:  Text('Tive um problema',
                  style: theme.textTheme.bodyMedium?.copyWith(
                     color: Colors.red.shade800,
                     fontWeight: FontWeight.bold
                  )
                  )),
              ElevatedButton(
                onPressed: (){
                  onPositiveButton();
                }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                overlayColor: Colors.white12
              ),
              child:const Text('Encerrar',
              style: TextStyle(color: Colors.white),
              ))
            ],
          );
        });
  }
}


