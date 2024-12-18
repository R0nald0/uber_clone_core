


abstract interface  class IAuthRepository {
  Future<String?> verifyStateUserLogged();
  Future<String?> logar(String email, String password);
  Future<String?> register(String name, String email, String password);      
  String? getIdCurrenteUserUser();
  void logout();
}
