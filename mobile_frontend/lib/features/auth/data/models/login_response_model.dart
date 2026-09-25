import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/auth_response_entity.dart';
import 'user_model.dart';

class LoginResponseModel extends Equatable {
  final String token;
  final UserRole role;
  final UserModel user;

  const LoginResponseModel({
    required this.token,
    required this.role,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String? ?? '',
      role: UserRole.fromString(json['role'] as String? ?? 'employer'),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role': role.value,
      'user': user.toJson(),
    };
  }

  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      token: token,
      role: role,
      user: user.toEntity(),
    );
  }

  @override
  List<Object?> get props => [token, role, user];
}
