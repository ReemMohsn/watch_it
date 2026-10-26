import 'package:e_learning/core/config/supabase_config.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  const SupabaseService._();

  static Future<void> init() async {
    if (SupabaseConfig.url.isEmpty || SupabaseConfig.key.isEmpty) return;
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.key,
        authOptions: FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          detectSessionInUri: kIsWeb,
        ),
      );
    } catch (_) {
      // Data requests report configuration errors through requestHandler.
    }
  }

  static SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
}
