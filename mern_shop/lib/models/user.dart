enum UserRole { customer, admin }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatarUrl;
  final String? phone;
  final String? bio;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.customer,
    this.avatarUrl,
    this.phone,
    this.bio,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id:        json['_id'] ?? json['id'] ?? '',
      name:      json['name'] ?? '',
      email:     json['email'] ?? '',
      role:      json['role'] == 'admin' ? UserRole.admin : UserRole.customer,
      avatarUrl: json['avatarUrl'] ?? '',
      phone:     json['phone'] ?? '',
      bio:       json['bio'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
    String? bio,
  }) =>
      AppUser(
        id:        id,
        name:      name ?? this.name,
        email:     email ?? this.email,
        role:      role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        phone:     phone ?? this.phone,
        bio:       bio ?? this.bio,
        createdAt: createdAt,
      );
}
