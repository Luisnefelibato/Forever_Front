import 'package:json_annotation/json_annotation.dart';

part 'verification_response.g.dart';

/// Response model for verification operations
@JsonSerializable()
class VerificationResponse {
  final String message;
  final bool verified;
  
  @JsonKey(name: 'email_verified')
  final bool? emailVerified;
  
  @JsonKey(name: 'phone_verified')
  final bool? phoneVerified;
  
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  VerificationResponse({
    required this.message,
    this.verified = false,
    this.emailVerified,
    this.phoneVerified,
    this.expiresAt,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationResponseToJson(this);
}
