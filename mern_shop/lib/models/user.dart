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

  AppUser copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
    String? bio,
  }) =>
      AppUser(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        phone: phone ?? this.phone,
        bio: bio ?? this.bio,
        createdAt: createdAt,
      );
}

// Mock user database
final List<Map<String, dynamic>> mockUserDb = [
  {
    'id': 'admin_001',
    'name': 'Admin',
    'email': 'admin@mernshop.com',
    'password': 'admin123',
    'role': UserRole.admin,
    'phone': '+55 11 9999-0001',
    'bio': 'Administrador da plataforma MERN Shop.',
  },
  {
    'id': 'user_001',
    'name': 'João Silva',
    'email': 'joao@email.com',
    'password': '123456',
    'role': UserRole.customer,
    'phone': '+55 11 9999-0002',
    'bio': '',
  },
];
