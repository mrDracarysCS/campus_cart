import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/models/app_user.dart';

class AuthService {
  static final client = Supabase.instance.client;

  /// ✅ REGISTER USER
  static Future<AppUser?> register(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    // ✅ Correct signUp API
    final authRes = await client.auth.signUp(
      email: email,
      password: password,
    );

    if (authRes.user == null) {
      return null;
    }

    // ✅ Insert extra fields into custom users table
    await client.from('users').insert({
      'id': authRes.user!.id,
      'name': name,
      'email': email,
      'role': role.name, // student/vendor
    });

    return getCurrentUser();
  }

  /// ✅ LOGIN USER
  static Future<AppUser?> login(String email, String password) async {
    final authRes = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authRes.user == null) {
      return null;
    }

    return getCurrentUser();
  }

  /// ✅ LOGOUT USER
  static Future<void> logout() async {
    await client.auth.signOut();
  }

  /// ✅ GET CURRENT USER DATA
  static Future<AppUser?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    final response =
        await client.from('users').select().eq('id', user.id).maybeSingle();

    if (response == null) return null;

    return AppUser.fromMap(response);
  }
}
