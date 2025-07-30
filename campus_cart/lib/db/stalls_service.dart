import 'package:supabase_flutter/supabase_flutter.dart';

class StallService {
  static final _client = Supabase.instance.client;

  // ✅ Fetch stalls owned by a vendor
  static Future<List<Map<String, dynamic>>> fetchVendorStalls(
    String ownerId,
  ) async {
    final response = await _client
        .from('stalls')
        .select()
        .eq('owner_id', ownerId)
        .order('id', ascending: true);

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  // ✅ Create a new stall
  static Future<bool> createStall({
    required String name,
    String? description,
    required String ownerId,
  }) async {
    final response = await _client.from('stalls').insert({
      'name': name,
      'description': description ?? '',
      'owner_id': ownerId,
    }).select();

    return response != null && response.isNotEmpty;
  }
}
