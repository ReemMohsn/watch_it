import 'package:e_learning/features/playlists/data/models/playlist_model.dart';

abstract class PlaylistsState {}

class PlaylistsInitial extends PlaylistsState {}

class PlaylistsLoading extends PlaylistsState {}

class PlaylistsSuccess extends PlaylistsState {
  PlaylistsSuccess({required this.playlists});

  final List<PlaylistModel> playlists;

  int get videoCount =>
      playlists.fold(0, (total, playlist) => total + playlist.videoCount);
}

class PlaylistsFailure extends PlaylistsState {
  PlaylistsFailure({required this.errorMessage});

  final String errorMessage;
}
