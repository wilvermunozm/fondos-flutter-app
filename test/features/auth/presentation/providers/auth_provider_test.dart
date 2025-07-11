import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amaris_fondos_flutter/features/auth/data/models/auth_model.dart';
import 'package:amaris_fondos_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:amaris_fondos_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:amaris_fondos_flutter/core/errors/app_error.dart';
import 'package:amaris_fondos_flutter/features/auth/presentation/providers/user_provider.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'auth_provider_test.mocks.dart';

class MockRef extends Mock implements Ref {}

class MockCurrentUserId extends Mock implements CurrentUserId {
  @override
  String state = '';
}

void main() {
  late MockAuthRepository mockRepository;
  late ProviderContainer container;
  late AuthNotifier notifier;
  late MockRef mockRef;

  const username = 'testuser';
  const password = 'password123';
  
  final authModel = AuthModel(
    userId: 'user123',
    token: 'test_token',
    username: username,
  );
  
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    
    mockRepository = MockAuthRepository();
    mockRef = MockRef();
    
    container = ProviderContainer(
      overrides: [
        AuthRepository.provider.overrideWithValue(mockRepository),
        currentUserIdProvider.overrideWith(() => CurrentUserId())
      ],
    );
    
    when(mockRef.read(AuthRepository.provider)).thenReturn(mockRepository);
    
    final mockCurrentUserId = MockCurrentUserId();
    when(mockRef.read(currentUserIdProvider.notifier)).thenReturn(mockCurrentUserId);
    
    notifier = AuthNotifier(mockRef);
    
    addTearDown(container.dispose);
  });
  
  group('login', () {
    test('should update state to authenticated when login is successful', () async {
      when(mockRepository.login(username, password))
          .thenAnswer((_) async => authModel);
      
      await notifier.login(username, password);
      
      verify(mockRepository.login(username, password));
      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.authModel, authModel);
      expect(notifier.state.errorMessage, isNull);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), 'test_token');
      expect(prefs.getString('auth_user_id'), 'user123');
      expect(prefs.getString('auth_username'), 'testuser');
    });
    
    test('should update state to unauthenticated with error when login fails', () async {
      when(mockRepository.login(username, password))
          .thenThrow(UnauthorizedError(message: 'Invalid credentials'));
      
      await notifier.login(username, password);
      
      verify(mockRepository.login(username, password));
      expect(notifier.state.status, AuthStatus.unauthenticated);
      expect(notifier.state.authModel, isNull);
      expect(notifier.state.errorMessage, isNotNull);
    });
  });
  
  group('logout', () {
    test('should reset state and clear SharedPreferences when logout is called', () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'test_token',
        'auth_user_id': 'user123',
        'auth_username': 'testuser',
      });
      
      notifier = AuthNotifier(mockRef);
      await Future.delayed(Duration.zero);
      
      await notifier.logout();
      
      expect(notifier.state.status, AuthStatus.initial);
      expect(notifier.state.authModel, isNull);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), isNull);
      expect(prefs.getString('auth_user_id'), isNull);
      expect(prefs.getString('auth_username'), isNull);
    });
  });
  
  group('_loadAuthFromStorage', () {
    test('should load auth state from SharedPreferences on initialization', () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'saved_token',
        'auth_user_id': 'saved_user_id',
        'auth_username': 'saved_username',
      });
      
      final newNotifier = AuthNotifier(mockRef);
      await Future.delayed(Duration.zero);
      
      expect(newNotifier.state.status, AuthStatus.authenticated);
      expect(newNotifier.state.authModel?.token, 'saved_token');
      expect(newNotifier.state.authModel?.userId, 'saved_user_id');
      expect(newNotifier.state.authModel?.username, 'saved_username');
    });
    
    test('should initialize with unauthenticated state when no data in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      
      final newNotifier = AuthNotifier(mockRef);
      await Future.delayed(Duration.zero);
      
      expect(newNotifier.state.status, AuthStatus.initial);
      expect(newNotifier.state.authModel, isNull);
    });
  });
}
