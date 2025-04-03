import 'package:flutter_test/flutter_test.dart';

import 'package:onfly_viagens_app/src/exports.dart';

void main() {
  late AuthRemoteDataSource authRemoteDataSource;

  setUp(() {
    authRemoteDataSource = AuthRemoteDataSource();
  });

  group('AuthRemoteDataSource', () {
    test('deve retornar um UserModel quando as credenciais estiverem corretas', () async {

      const email = 'teste@onfly.com';
      const password = '123456';


      final result = await authRemoteDataSource.login(email, password);

      expect(result, isA<UserModel>());
      expect(result.id, 1);
      expect(result.name, 'Matheus Alves');
      expect(result.email, 'teste@onfly.com');
      expect(result.token, 'fake-token-123');
    });

    test('deve lançar ServerException quando as credenciais estiverem incorretas', () async {
      const email = 'email_incorreto@onfly.com';
      const password = 'senha_incorreta';

      expect(
        () => authRemoteDataSource.login(email, password),
        throwsA(
          isA<ServerException>()
            .having((e) => e.message, 'message', 'Credenciais inválidas')
            .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('deve lançar ServerException quando a senha está incorreta', () async {
      const email = 'teste@onfly.com';
      const password = 'senha_incorreta';

      expect(
        () => authRemoteDataSource.login(email, password),
        throwsA(
          isA<ServerException>()
            .having((e) => e.message, 'message', 'Credenciais inválidas')
            .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('deve lançar ServerException quando o email está incorreto', () async {
      const email = 'email_incorreto@onfly.com';
      const password = '123456';

      expect(
        () => authRemoteDataSource.login(email, password),
        throwsA(
          isA<ServerException>()
            .having((e) => e.message, 'message', 'Credenciais inválidas')
            .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });
}