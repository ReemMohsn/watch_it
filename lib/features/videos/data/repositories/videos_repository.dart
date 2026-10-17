import 'package:dartz/dartz.dart';
import 'package:e_learning/core/services/errors/failure.dart';
import 'package:e_learning/core/services/request_handler.dart';
import 'package:e_learning/features/videos/data/data_sources/videos_remote_data_source.dart';
import 'package:e_learning/features/videos/data/models/video_item.dart';

class VideosRepository {
  const VideosRepository(this._remote);

  final VideosRemoteDataSource _remote;

  Future<Either<Failure, List<VideoItem>>> getVideos(String playlistId) =>
      requestHandler(() => _remote.getVideos(playlistId));

  Future<Either<Failure, void>> addVideo({
    required String title,
    required String url,
    String? playlistId,
    String? newPlaylistName,
  }) => requestHandler(
    () => _remote.addVideo(
      title: title,
      url: url,
      playlistId: playlistId,
      newPlaylistName: newPlaylistName,
    ),
  );

  Future<Either<Failure, void>> deleteVideo(String databaseId) =>
      requestHandler(() => _remote.deleteVideo(databaseId));
}
