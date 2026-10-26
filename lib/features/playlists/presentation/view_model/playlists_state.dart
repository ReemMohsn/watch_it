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

class DeletePlaylistLoading extends PlaylistsSuccess {
  DeletePlaylistLoading({required super.playlists, required this.playlistId});

  final String playlistId;
}

class DeletePlaylistSuccess extends PlaylistsSuccess {
  DeletePlaylistSuccess({required super.playlists, required this.message});

  final String message;
}

class DeletePlaylistFailure extends PlaylistsSuccess {
  DeletePlaylistFailure({required super.playlists, required this.errorMessage});

  final String errorMessage;
}
