import 'package:e_learning/core/dependency_injection/injection_container.dart';
import 'package:e_learning/features/videos/data/models/video_item.dart';
import 'package:e_learning/features/videos/presentation/views/main_home_view.dart';
import 'package:e_learning/features/videos/presentation/views/video_player_view.dart';
import 'package:e_learning/features/auth/presentation/views/login_view.dart';
import 'package:e_learning/features/auth/presentation/views/forgot_password_view.dart';
import 'package:e_learning/features/auth/presentation/views/reset_password_view.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_cubit.dart';
import 'package:e_learning/features/videos/presentation/views/add_video_view.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_cubit.dart';
import 'package:e_learning/features/videos/presentation/views/playlist_videos_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => sl<PlaylistsCubit>()..getPlaylists(),
            child: const MainHomeView(),
          ),
        );
      case Routes.video:
        final video = settings.arguments;
        if (video is VideoItem) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => VideoPlayerView(video: video),
          );
        }
        return _notFound(settings);
      case Routes.teacherLogin:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginView(),
        );
      case Routes.forgotPassword:
        final email = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              ForgotPasswordView(initialEmail: email is String ? email : ''),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ResetPasswordView(),
        );
      case Routes.addVideo:
        final initialPlaylist = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<VideosCubit>()),
              BlocProvider(create: (_) => sl<PlaylistsCubit>()..getPlaylists()),
            ],
            child: AddVideoView(
              initialPlaylist: initialPlaylist is PlaylistModel
                  ? initialPlaylist
                  : null,
            ),
          ),
        );
      case Routes.playlistVideos:
        final playlist = settings.arguments;
        if (playlist is PlaylistModel) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (_) => sl<VideosCubit>()..getVideos(playlist.id),
              child: PlaylistVideosView(playlist: playlist),
            ),
          );
        }
        return _notFound(settings);
      default:
        return _notFound(settings);
    }
  }

  Route<dynamic> _notFound(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: const Center(child: Text('This page is not available.')),
      ),
    );
  }
}
