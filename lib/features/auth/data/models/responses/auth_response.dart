import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response.g.dart';

/// Response model for authentication (login, register, social auth)
@JsonSerializable()
class AuthResponse {
  final String token;
  final UserModel user;
  final String? message;
  
  @JsonKey(name: 'is_new_user')
  final bool? isNewUser;

  AuthResponse({
    required this.token,
    required this.user,
    this.message,
    this.isNewUser,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
