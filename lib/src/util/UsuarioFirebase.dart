



class UsuarioFirebase{
  /* static Future<User?> getFirebaseUser() async {
    return await Banco.auth.currentUser;
  } */

  /* static Future<Usuario> recuperarDadosPassageiro() async{
  //  User? user = Banco.auth.currentUser;

      DocumentSnapshot snapshot = await Banco.db.collection("usuario").doc(user?.uid).get();
       User? firebaseUse = await getFirebaseUser();
      String? idUsuarioLogado =  firebaseUse?.uid;

     final email=snapshot.get("email");
     final nome=snapshot.get("nome");
     final tipoUsuario= snapshot.get("tipoUsuario");
     final idUsuario =idUsuarioLogado!;

    /*   Usuario usuario =Usuario(
        idUsuario: idUsuario,
        email: email,
        latitude: 0,
        longitude: 0,
        nome: nome,
        senha: '',
        tipoUsuario: tipoUsuario
      ); */
    
     // return usuario;
  } */
 /*  static atualizarPosicaoUsuario(String idRequisicao,String campoAtulizar,double lat ,double long) async{

    Usuario usuarioMot = await UsuarioFirebase.recuperarDadosPassageiro();
     usuarioMot.copyWith(latitude: lat);
     usuarioMot.copyWith(longitude: long);

     Banco.db.collection('requisicao')
        .doc(idRequisicao)
        .update({
          campoAtulizar : usuarioMot.toMapUp()
    });

  }
  
 static Future<DocumentSnapshot> getDadosRequisicao(id) async {
    DocumentSnapshot snapshot = await Banco.db.collection("requisicao").doc(id).get();
    return snapshot;
  } */

}