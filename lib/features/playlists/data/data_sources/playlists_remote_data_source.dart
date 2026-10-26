import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/services/errors/app_exception.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaylistsRemoteDataSource {
  const PlaylistsRemoteDataSource(this._client);

  final SupabaseClient? _client;

  Future<List<PlaylistModel>> getPlaylists() async {
    final client = _requireClient();
    final playlists = <PlaylistModel>[];
    const pageSize = 100;
    var offset = 0;
    while (true) {
      final response = await client
          .from('playlists')
          .select('id, name, youtube_videos(count)')
          .order('name')
          .order('id')
          .range(offset, offset + pageSize - 1)
          .timeout(const Duration(seconds: 20));
      playlists.addAll(response.map(PlaylistModel.fromJson));
      if (response.length < pageSize) break;
      offset += pageSize;
    }
    return playlists;
  }

  Future<void> deletePlaylist(String playlistId) async {
    final client = _requireClient();
    if (client.auth.currentUser == null) {
      throw const AuthException(
        AppStrings.pleaseSignInAgainToContinue,
        code: 'session_not_found',
      );
    }
    await client
        .from('playlists')
        .delete()
        .eq('id', playlistId)
        .select('id')
        .single()
        .timeout(const Duration(seconds: 20));
  }

  SupabaseClient _requireClient() {
    final client = _client;
    if (client == null) {
      throw const AppException(
        message: AppStrings.supabaseNotConfigured,
        code: 'supabase_not_configured',
      );
    }
    return client;
  }
}
