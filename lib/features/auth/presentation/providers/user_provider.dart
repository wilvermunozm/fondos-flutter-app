import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/providers/http_client_provider.dart';

part 'user_provider.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(
    baseUrl: ApiConstants.baseUrl,
    client: ref.watch(httpClientProvider),
  );
}

@riverpod
Future<UserModel> user(UserRef ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById('user001');
}

@riverpod
class CurrentUserId extends _$CurrentUserId {
  @override
  String build() {
    return 'user001';
  }
}
