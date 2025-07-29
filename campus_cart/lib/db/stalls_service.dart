import '../models/stall.dart';
import 'supabase_service.dart';

class StallsService {
  static Future<List<Stall>> getStalls() async {
    final res = await SupabaseService.client.from('stalls').select();
    return res.map<Stall>((e) => Stall.fromMap(e)).toList();
  }
}
