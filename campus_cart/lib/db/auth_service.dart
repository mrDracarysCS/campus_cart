import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  static Future<AuthResponse> register(String email, String password) async {
    return await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> login(String email, String password) async {
    return await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await SupabaseService.client.auth.signOut();
  }
}
