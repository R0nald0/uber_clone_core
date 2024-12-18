

abstract class IAuthService {
    Future<String?> verifyStateUserLogged();
    Future<bool> register(String name, String email, password,String tipoUsuario);
    Future<bool> login(String email, password);
    Future<bool> logout();

} 