import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';

class AuthService {
  static final client = Supabase.instance.client;

  static Future<AppUser?> register(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    final authRes = await client.auth.signUp(email: email, password: password);

    if (authRes.user == null) return null;

    // ✅ Insert into custom users table
    await client.from('users').insert({
      'id': authRes.user!.id,
      'name': name,
      'email': email,
      'role': role.name,
    });

    return getCurrentUser();
  }

  static Future<AppUser?> login(String email, String password) async {
    final authRes = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authRes.user == null) return null;

    // ✅ Fetch from our own users table
    final userRes = await client
        .from('users')
        .select()
        .eq('id', authRes.user!.id)
        .maybeSingle();

    return userRes != null ? AppUser.fromMap(userRes) : null;
  }

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

  static Future<void> logout() async {
    await client.auth.signOut();
  }
}
