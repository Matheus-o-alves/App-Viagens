import 'package:equatable/equatable.dart';

abstract class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, email, token];
}
