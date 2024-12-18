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

}


