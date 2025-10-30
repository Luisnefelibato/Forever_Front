// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      login: json['login'] as String,
      password: json['password'] as String,
      remember: json['remember'] as bool? ?? true,
      deviceToken: json['device_token'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) {
  final val = <String, dynamic>{
    'login': instance.login,
    'password': instance.password,
    'remember': instance.remember,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('device_token', instance.deviceToken);
  return val;
}
