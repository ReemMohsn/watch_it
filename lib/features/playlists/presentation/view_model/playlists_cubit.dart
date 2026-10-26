import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:e_learning/features/playlists/data/repositories/playlists_repository.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  PlaylistsCubit(this._repository) : super(PlaylistsInitial());

  final PlaylistsRepository _repository;
  List<PlaylistModel> _playlists = const [];

  Future<void> getPlaylists() async {
    if (isClosed ||
        state is PlaylistsLoading ||
        state is DeletePlaylistLoading) {
      return;
    }
    emit(PlaylistsLoading());
    final response = await _repository.getPlaylists();
    if (isClosed) return;
    response.fold(
      (failure) => emit(PlaylistsFailure(errorMessage: failure.message)),
      (playlists) {
        _playlists = playlists;
        emit(PlaylistsSuccess(playlists: _playlists));
      },
    );
  }

  Future<void> deletePlaylist(String playlistId) async {
    if (isClosed ||
        state is! PlaylistsSuccess ||
        state is DeletePlaylistLoading) {
      return;
    }
    emit(DeletePlaylistLoading(playlists: _playlists, playlistId: playlistId));
    final response = await _repository.deletePlaylist(playlistId);
    if (isClosed) return;
    response.fold(
      (failure) => emit(
        DeletePlaylistFailure(
          playlists: _playlists,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        _playlists = _playlists
            .where((playlist) => playlist.id != playlistId)
            .toList();
        emit(
          DeletePlaylistSuccess(
            playlists: _playlists,
            message: AppStrings.playlistDeletedSuccessfully,
          ),
        );
      },
    );
  }
}
