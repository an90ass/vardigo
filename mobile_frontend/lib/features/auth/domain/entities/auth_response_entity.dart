import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import 'user_entity.dart';


class AuthResponseEntity extends Equatable {
  final String token;
  final UserRole role;
  final UserEntity user;

  const AuthResponseEntity({
    required this.token,
    required this.role,
    required this.user,
  });

  @override
  List<Object?> get props => [token, role, user];
}
