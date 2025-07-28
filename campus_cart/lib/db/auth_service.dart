import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';
import 'supabase_service.dart';

class AuthService {
  static Future<AppUser?> getCurrentUser() async {
    final sessionUser = SupabaseService.client.auth.currentUser;
    if (sessionUser == null) return null;

    final response = await SupabaseService.client
        .from('users')
        .select()
        .eq('id', sessionUser.id)
        .maybeSingle();

    if (response == null) return null;
    return AppUser.fromMap(response);
  }

  static Future<AppUser?> register(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    final authRes = await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
    );

    if (authRes.user == null) return null;

    await SupabaseService.client.from('users').insert({
      'id': authRes.user!.id,
      'name': name,
      'email': email,
      'role': role.name,
    });

    return getCurrentUser();
  }

  static Future<AppUser?> login(String email, String password) async {
    await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return getCurrentUser();
  }

  static Future<void> logout() async {
    await SupabaseService.client.auth.signOut();
  }
}
