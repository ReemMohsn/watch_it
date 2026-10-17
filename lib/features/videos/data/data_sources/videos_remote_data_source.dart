import 'package:e_learning/core/common/utils/youtube_url.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/services/errors/app_exception.dart';
import 'package:e_learning/features/videos/data/models/video_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideosRemoteDataSource {
  const VideosRemoteDataSource(this._client);

  final SupabaseClient? _client;

  Future<List<VideoItem>> getVideos(String playlistId) async {
    final client = _requireClient();
    final videos = <VideoItem>[];
    const pageSize = 100;
    var offset = 0;
    while (true) {
      final response = await client
          .from('youtube_videos')
          .select('id, youtube_id, title, playlist_id, thumbnail_url')
          .eq('playlist_id', playlistId)
          .order('position')
          .order('created_at')
          .order('id')
          .range(offset, offset + pageSize - 1)
          .timeout(const Duration(seconds: 20));
      videos.addAll(response.map(VideoItem.fromJson));
      if (response.length < pageSize) break;
      offset += pageSize;
    }
    return videos;
  }

  Future<void> addVideo({
    required String title,
    required String url,
    String? playlistId,
    String? newPlaylistName,
  }) async {
    final client = _requireClient();
    if (client.auth.currentUser == null) {
      throw const AuthException(
        AppStrings.pleaseSignInAgainToContinue,
        code: 'session_not_found',
      );
    }
    final id = YoutubeUrl.videoId(url);
    if (id == null) {
      throw const AppException(
        message: AppStrings.invalidYoutubeUrl,
        code: 'invalid_youtube_url',
      );
    }
    final newName = newPlaylistName?.trim();
    if ((playlistId == null && (newName == null || newName.isEmpty)) ||
        (playlistId != null && newName != null)) {
      throw const AppException(
        message: AppStrings.choosePlaylist,
        code: 'playlist_required',
      );
    }
    // The SQL function saves the new playlist and video in one transaction.
    await client
        .rpc(
          'add_youtube_video',
          params: {
            'p_youtube_id': id,
            'p_title': title.trim().isEmpty ? 'فيديو جديد' : title.trim(),
            'p_playlist_id': playlistId,
            'p_new_playlist_name': newName,
          },
        )
        .timeout(const Duration(seconds: 20));
  }

  Future<void> deleteVideo(String databaseId) async {
    final client = _requireClient();
    if (client.auth.currentUser == null) {
      throw const AuthException(
        AppStrings.pleaseSignInAgainToContinue,
        code: 'session_not_found',
      );
    }
    await client
        .from('youtube_videos')
        .delete()
        .eq('id', databaseId)
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
