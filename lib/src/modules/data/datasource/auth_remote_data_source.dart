import 'dart:async';

import '../../../core/core.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_data_source.dart';
import '../model/user/user_model.dart';

class AuthRemoteDataSource implements AuthRepository {
  @override
  Future<UserEntity> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'teste@onfly.com' && password == '123456') {
      return const UserModel(
        id: 1,
        name: 'Matheus Alves',
        email: 'teste@onfly.com',
        token: 'fake-token-123',
      );
    } else {
      throw ServerException(
        message: 'Credenciais inválidas',
        statusCode: 401,
      );
    }
  }
}
