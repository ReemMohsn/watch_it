import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/features/videos/data/models/video_item.dart';
import 'package:e_learning/features/videos/data/repositories/videos_repository.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit(this._repository) : super(VideosInitial());

  final VideosRepository _repository;
  List<VideoItem> _videos = const [];

  Future<void> getVideos(String playlistId) async {
    if (isClosed || state is VideosLoading || state is DeleteVideoLoading)
      return;
    emit(VideosLoading());
    final response = await _repository.getVideos(playlistId);
    if (isClosed) return;
    response.fold(
      (failure) => emit(VideosFailure(errorMessage: failure.message)),
      (videos) {
        _videos = videos;
        emit(VideosSuccess(videos: _videos));
      },
    );
  }

  Future<void> addVideo({
    required String title,
    required String url,
    String? playlistId,
    String? newPlaylistName,
  }) async {
    if (isClosed || state is AddVideoLoading) return;
    emit(AddVideoLoading());
    final response = await _repository.addVideo(
      title: title,
      url: url,
      playlistId: playlistId,
      newPlaylistName: newPlaylistName,
    );
    if (isClosed) return;
    response.fold(
      (failure) => emit(AddVideoFailure(errorMessage: failure.message)),
      (_) => emit(AddVideoSuccess(message: AppStrings.videoAddedSuccessfully)),
    );
  }

  Future<void> deleteVideo(String databaseId) async {
    if (isClosed || state is! VideosSuccess || state is DeleteVideoLoading)
      return;
    emit(DeleteVideoLoading(videos: _videos, videoId: databaseId));
    final response = await _repository.deleteVideo(databaseId);
    if (isClosed) return;
    response.fold(
      (failure) => emit(
        DeleteVideoFailure(videos: _videos, errorMessage: failure.message),
      ),
      (_) {
        _videos = _videos
            .where((video) => video.databaseId != databaseId)
            .toList();
        emit(
          DeleteVideoSuccess(
            videos: _videos,
            message: AppStrings.videoDeletedSuccessfully,
          ),
        );
      },
    );
  }
}
