import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';


class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [id, name, email, role];
}
