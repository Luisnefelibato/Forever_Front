import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

/// Request model for user registration
@JsonSerializable(includeIfNull: false)
class RegisterRequest {
  @JsonKey(includeIfNull: false)
  final String? email;
  @JsonKey(includeIfNull: false)
  final String? phone;
  final String password;
  
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  RegisterRequest({
    this.email,
    this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
