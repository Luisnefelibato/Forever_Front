import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

/// Request model for code verification (email or phone)
@JsonSerializable()
class VerifyCodeRequest {
  /// 6-digit verification code
  final String code;

  VerifyCodeRequest({required this.code});

  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}
