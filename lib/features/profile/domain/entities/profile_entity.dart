import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String street;
  final String zip;
  final String state;
  final String phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.zip,
    required this.state,
    required this.phone,
    this.createdAt,
    this.updatedAt,
  });

  ProfileEntity copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? street,
    String? zip,
    String? state,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street: street ?? this.street,
      zip: zip ?? this.zip,
      state: state ?? this.state,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
        lastName,
        street,
        zip,
        state,
        phone,
        createdAt,
        updatedAt,
      ];
}