import 'package:equatable/equatable.dart';

/// Pure business object — no JSON, no framework types. What the domain
/// and presentation layers work with; [UserModel] adapts it to/from the API.
class UserEntity extends Equatable {
  const UserEntity({required this.id, required this.email, required this.name});

  final String id;
  final String email;
  final String name;

  @override
  List<Object?> get props => [id, email, name];
}
