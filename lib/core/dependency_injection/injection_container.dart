import 'package:get_it/get_it.dart';
import 'package:e_learning/core/networking/supabase_service.dart';
import 'package:e_learning/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:e_learning/features/auth/data/repositories/auth_repository.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_learning/features/videos/data/data_sources/videos_remote_data_source.dart';
import 'package:e_learning/features/videos/data/repositories/videos_repository.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_cubit.dart';
import 'package:e_learning/features/playlists/data/data_sources/playlists_remote_data_source.dart';
import 'package:e_learning/features/playlists/data/repositories/playlists_repository.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // The same DataSource -> Repository -> Cubit registration as e_learning.
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(SupabaseService.client),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<AuthRemoteDataSource>()),
  );
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));

  sl.registerLazySingleton<VideosRemoteDataSource>(
    () => VideosRemoteDataSource(SupabaseService.client),
  );
  sl.registerLazySingleton<VideosRepository>(
    () => VideosRepository(sl<VideosRemoteDataSource>()),
  );
  sl.registerFactory<VideosCubit>(() => VideosCubit(sl<VideosRepository>()));

  sl.registerLazySingleton<PlaylistsRemoteDataSource>(
    () => PlaylistsRemoteDataSource(SupabaseService.client),
  );
  sl.registerLazySingleton<PlaylistsRepository>(
    () => PlaylistsRepository(sl<PlaylistsRemoteDataSource>()),
  );
  sl.registerFactory<PlaylistsCubit>(
    () => PlaylistsCubit(sl<PlaylistsRepository>()),
  );
}
