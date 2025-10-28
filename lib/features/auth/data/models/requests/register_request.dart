import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

/// Request model for user registration
@JsonSerializable()
class RegisterRequest {
  final String? email;
  final String? phone;
  final String password;
  
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth; // Format: YYYY-MM-DD

  RegisterRequest({
    this.email,
    this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
