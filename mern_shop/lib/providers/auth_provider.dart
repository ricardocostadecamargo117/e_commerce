import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  String? _avatarLocalPath; // holds local file path for picked image

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  String? get avatarLocalPath => _avatarLocalPath;

  // ── Login ──────────────────────────────────────────────────────────────────
  String? login(String email, String password) {
    final found = mockUserDb.firstWhere(
      (u) =>
          u['email'].toString().toLowerCase() ==
              email.trim().toLowerCase() &&
          u['password'] == password,
      orElse: () => {},
    );

    if (found.isEmpty) return 'E-mail ou senha incorretos.';

    _user = AppUser(
      id: found['id'],
      name: found['name'],
      email: found['email'],
      role: found['role'],
      phone: found['phone'],
      bio: found['bio'],
      createdAt: DateTime.now(),
    );
    _avatarLocalPath = null;
    notifyListeners();
    return null;
  }

  // ── Register ───────────────────────────────────────────────────────────────
  String? register(String name, String email, String password) {
    final exists = mockUserDb.any(
        (u) => u['email'].toString().toLowerCase() == email.trim().toLowerCase());
    if (exists) return 'Este e-mail já está em uso.';

    final id = const Uuid().v4();
    final newUser = {
      'id': id,
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'role': UserRole.customer,
      'phone': '',
      'bio': '',
    };
    mockUserDb.add(newUser);

    _user = AppUser(
      id: id,
      name: name.trim(),
      email: email.trim().toLowerCase(),
      role: UserRole.customer,
      phone: '',
      bio: '',
      createdAt: DateTime.now(),
    );
    _avatarLocalPath = null;
    notifyListeners();
    return null;
  }

  // ── Update Profile ─────────────────────────────────────────────────────────
  void updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? avatarPath,
  }) {
    if (_user == null) return;
    _user = _user!.copyWith(
      name: name,
      phone: phone,
      bio: bio,
    );
    if (avatarPath != null) _avatarLocalPath = avatarPath;

    // Update mock db
    final idx = mockUserDb.indexWhere((u) => u['id'] == _user!.id);
    if (idx >= 0) {
      if (name != null) mockUserDb[idx]['name'] = name;
      if (phone != null) mockUserDb[idx]['phone'] = phone;
      if (bio != null) mockUserDb[idx]['bio'] = bio;
    }
    notifyListeners();
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  void logout() {
    _user = null;
    _avatarLocalPath = null;
    notifyListeners();
  }
}
