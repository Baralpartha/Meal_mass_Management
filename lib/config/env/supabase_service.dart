import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Central wrapper around Supabase client.
/// All datasources use this instead of Supabase.instance.client directly.
@lazySingleton
class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;

  // ── Table helpers ────────────────────────────────────────────────────────

  SupabaseQueryBuilder from(String table) => client.from(table);

  // ── RPC helper ───────────────────────────────────────────────────────────

  Future<dynamic> rpc(
      String function, {
        Map<String, dynamic>? params,
      }) =>
      client.rpc(function, params: params);
}