import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/models/app_user.dart';

class AuthService {
  static final client = Supabase.instance.client;

  /// ✅ Register a new user
  static Future<AppUser?> register(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    final authRes = await client.auth.signUp(email: email, password: password);

    if (authRes.user == null) return null;

    await client.from('users').insert({
      'id': authRes.user!.id,
      'name': name,
      'email': email,
      'role': role.name,
    });

    return getCurrentUser();
  }

  /// ✅ Login existing user
  static Future<AppUser?> login(String email, String password) async {
    final authRes = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authRes.user == null) return null;

    return getCurrentUser();
  }

  /// ✅ Logout user
  static Future<void> logout() async {
    await client.auth.signOut();
  }

  /// ✅ Get the currently logged-in user
  static Future<AppUser?> getCurrentUser() async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;

    final userRes = await client
        .from('users')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    return userRes != null ? AppUser.fromMap(userRes) : null;
  }
}
