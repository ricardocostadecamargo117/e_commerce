import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  String? _avatarLocalPath;
  bool _loading = false;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  String? get avatarLocalPath => _avatarLocalPath;
  bool get loading => _loading;

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<String?> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await ApiService.post('/auth/login', {
        'email': email.trim(),
        'password': password,
      });

      // Salva o token JWT para as próximas requisições
      ApiService.setToken(data['token']);

      _user = AppUser(
        id: data['_id'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        role: data['role'] == 'admin' ? UserRole.admin : UserRole.customer,
        phone: data['phone'] ?? '',
        bio: data['bio'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        createdAt: DateTime.parse(
            data['createdAt'] ?? DateTime.now().toIso8601String()),
      );

      _avatarLocalPath = null;
      _loading = false;
      notifyListeners();
      return null; // null = sucesso
    } catch (e) {
      _loading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────
  Future<String?> register(String name, String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await ApiService.post('/auth/register', {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      });

      ApiService.setToken(data['token']);

      _user = AppUser(
        id: data['_id'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        role: UserRole.customer,
        phone: data['phone'] ?? '',
        bio: data['bio'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        createdAt: DateTime.now(),
      );

      _loading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  // ── Update Profile ─────────────────────────────────────────────────────────
  Future<String?> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? avatarPath,
  }) async {
    try {
      final data = await ApiService.put('/users/profile', {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (bio != null) 'bio': bio,
      });

      _user = _user?.copyWith(
        name: data['name'],
        phone: data['phone'],
        bio: data['bio'],
      );

      if (avatarPath != null) _avatarLocalPath = avatarPath;

      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  void logout() {
    _user = null;
    _avatarLocalPath = null;
    ApiService.clearToken();
    notifyListeners();
  }
}
