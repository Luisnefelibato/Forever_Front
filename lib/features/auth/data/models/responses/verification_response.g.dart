// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationResponse _$VerificationResponseFromJson(
        Map<String, dynamic> json) =>
    VerificationResponse(
      message: json['message'] as String,
      verified: json['verified'] as bool? ?? false,
      emailVerified: json['email_verified'] as bool?,
      phoneVerified: json['phone_verified'] as bool?,
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$VerificationResponseToJson(
        VerificationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'verified': instance.verified,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'expires_at': instance.expiresAt,
    };
