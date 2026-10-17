import 'package:dartz/dartz.dart';
import 'package:e_learning/core/services/errors/failure.dart';
import 'package:e_learning/core/services/request_handler.dart';
import 'package:e_learning/features/playlists/data/data_sources/playlists_remote_data_source.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';

class PlaylistsRepository {
  const PlaylistsRepository(this._remote);

  final PlaylistsRemoteDataSource _remote;

  Future<Either<Failure, List<PlaylistModel>>> getPlaylists() =>
      requestHandler(_remote.getPlaylists);
}
