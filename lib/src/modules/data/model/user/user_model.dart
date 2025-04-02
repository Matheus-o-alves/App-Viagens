import '../../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required int id,
    required String name,
    required String email,
    required String token,
  }) : super(id: id, name: name, email: email, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token,
      };
}
