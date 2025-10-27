import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// Request model for user login
@JsonSerializable()
class LoginRequest {
  /// Can be email, phone, or username
  final String login;
  
  final String password;
  
  final bool remember;
  
  @JsonKey(name: 'device_token')
  final String? deviceToken;

  LoginRequest({
    required this.login,
    required this.password,
    this.remember = true,
    this.deviceToken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
