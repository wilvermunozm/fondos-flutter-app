import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../data/models/auth_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'user_provider.dart';


final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  
  AuthNotifier(this._ref) : super(AuthState.initial()) {
    _loadAuthFromStorage();
  }
  
  Future<void> _loadAuthFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getString('auth_user_id');
      final username = prefs.getString('auth_username');
      
      if (token != null && userId != null && username != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          authModel: AuthModel(
            token: token,
            userId: userId,
            username: username,
          ),
          errorMessage: null,
        );
        

        _ref.read(currentUserIdProvider.notifier).state = userId;
      }
    } catch (e) {

    }
  }
  
  Future<void> login(String username, String password) async {
    state = AuthState(
      status: AuthStatus.loading,
      authModel: null,
      errorMessage: null,
    );
    
    try {
      final repository = _ref.read(AuthRepository.provider);
      final authModel = await repository.login(username, password);
      

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authModel.token);
      await prefs.setString('auth_user_id', authModel.userId);
      await prefs.setString('auth_username', authModel.username);
      
      state = AuthState(
        status: AuthStatus.authenticated,
        authModel: authModel,
        errorMessage: null,
      );
      

      _ref.read(currentUserIdProvider.notifier).state = authModel.userId;
    } catch (e) {

      String errorMessage;
      if (e is ServerError && e.message.contains('401')) {
        errorMessage = 'Usuario o contraseña incorrectos';
      } else if (e is NetworkError) {
        errorMessage = 'No se pudo conectar al servidor. Por favor, verifica tu conexión a internet';
      } else if (e is FormatException) {
        errorMessage = 'Error al procesar la información. Por favor, inténtalo de nuevo';
      } else if (e is AppError) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo';
      }
      
      state = AuthState(
        status: AuthStatus.unauthenticated,
        authModel: null,
        errorMessage: errorMessage,
      );
    }
  }
  
  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_username');
    
    state = AuthState.initial();
    
    _ref.read(currentUserIdProvider.notifier).state = '';
  }
}

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final AuthModel? authModel;
  final String? errorMessage;
  
  AuthState({
    required this.status,
    required this.authModel,
    required this.errorMessage,
  });
  
  factory AuthState.initial() {
    return AuthState(
      status: AuthStatus.initial,
      authModel: null,
      errorMessage: null,
    );
  }
  
  bool get isAuthenticated => status == AuthStatus.authenticated;
}
