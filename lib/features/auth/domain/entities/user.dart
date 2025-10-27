import 'package:equatable/equatable.dart';

/// User entity - Domain layer
class User extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;
  final String? gender;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;

  const User({
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

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        dateOfBirth,
        gender,
        emailVerified,
        phoneVerified,
        createdAt,
      ];

  /// Copy with method for creating modified copies
  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    bool? emailVerified,
    bool? phoneVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
