import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User data model from API
@JsonSerializable()
class UserModel {
  final String id;
  final String? email;
  final String? phone;
  
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  
  final String? gender;
  
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  
  @JsonKey(name: 'created_at')
  final String createdAt;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    this.emailVerified = false,
    this.phoneVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Create from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      phone: user.phone,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      emailVerified: user.emailVerified,
      phoneVerified: user.phoneVerified,
      createdAt: user.createdAt.toIso8601String(),
    );
  }

  String get fullName => '$firstName $lastName';
}
