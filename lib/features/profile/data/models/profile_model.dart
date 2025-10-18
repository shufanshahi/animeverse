import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.userId,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.street,
    required super.zip,
    required super.state,
    required super.phone,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      street: json['street'] ?? '',
      zip: json['zip'] ?? '',
      state: json['state'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'street': street,
      'zip': zip,
      'state': state,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      userId: entity.userId,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      street: entity.street,
      zip: entity.zip,
      state: entity.state,
      phone: entity.phone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}