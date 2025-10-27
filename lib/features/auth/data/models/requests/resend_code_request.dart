import 'package:json_annotation/json_annotation.dart';

part 'resend_code_request.g.dart';

/// Request model for resending verification code
@JsonSerializable()
class ResendCodeRequest {
  /// Type of verification: 'email' or 'phone'
  final String type;

  ResendCodeRequest({required this.type});

  factory ResendCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$ResendCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResendCodeRequestToJson(this);
}
