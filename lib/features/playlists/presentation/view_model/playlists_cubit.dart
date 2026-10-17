import 'package:e_learning/features/playlists/data/repositories/playlists_repository.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  PlaylistsCubit(this._repository) : super(PlaylistsInitial());

  final PlaylistsRepository _repository;

  Future<void> getPlaylists() async {
    if (isClosed || state is PlaylistsLoading) return;
    emit(PlaylistsLoading());
    final response = await _repository.getPlaylists();
    if (isClosed) return;
    response.fold(
      (failure) => emit(PlaylistsFailure(errorMessage: failure.message)),
      (playlists) => emit(PlaylistsSuccess(playlists: playlists)),
    );
  }
}
