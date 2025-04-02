import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRepository remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserEntity> login(String email, String password) {
    return remote.login(email, password);
  }
}
