import '../../domain/entities/user_search_entity.dart';

class UserSearchModel extends UserSearchEntity {
  const UserSearchModel({
    required super.userId,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.createdAt,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    return UserSearchModel(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
