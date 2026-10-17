import 'package:e_learning/core/constants/app_image.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/routing/routes.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_cubit.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_state.dart';
import 'package:e_learning/features/playlists/presentation/views/widgets/playlist_card.dart';
import 'package:e_learning/features/videos/presentation/views/widgets/library_status.dart';
import 'package:e_learning/features/videos/presentation/views/widgets/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  Future<void> _openTeacherArea(BuildContext context) async {
    if (context.read<AuthCubit>().currentAccount == null) {
      final loggedIn = await Navigator.of(
        context,
      ).pushNamed(Routes.teacherLogin);
      if (!context.mounted || loggedIn != true) return;
    }
    if (!context.mounted) return;
    final saved = await Navigator.of(context).pushNamed(Routes.addVideo);
    if (context.mounted && saved == true) {
      context.read<PlaylistsCubit>().getPlaylists();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.videoAddedSuccessfully)),
      );
    }
  }

  Future<void> _openPlaylist(
    BuildContext context,
    PlaylistModel playlist,
  ) async {
    await Navigator.of(
      context,
    ).pushNamed(Routes.playlistVideos, arguments: playlist);
    if (context.mounted) {
      context.read<PlaylistsCubit>().getPlaylists();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(AppImage.logo, width: 42, height: 42),
          ),
          const SizedBox(width: 10),
          const Flexible(
            child: Text(AppStrings.appName, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _openTeacherArea(context),
          tooltip: 'دخول المعلمة',
          icon: const Icon(Icons.admin_panel_settings_outlined),
        ),
        const SizedBox(width: 6),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: RefreshIndicator(
            onRefresh: () => context.read<PlaylistsCubit>().getPlaylists(),
            child: BlocBuilder<PlaylistsCubit, PlaylistsState>(
              builder: (context, state) {
                if (state is PlaylistsFailure) {
                  return LibraryStatus(
                    message: state.errorMessage,
                    onRetry: () =>
                        context.read<PlaylistsCubit>().getPlaylists(),
                  );
                }
                if (state is PlaylistsSuccess) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                    children: [
                      WelcomeCard(
                        playlistCount: state.playlists.length,
                        videoCount: state.videoCount,
                        onTeacherTap: () => _openTeacherArea(context),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppStrings.playlists,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (state.playlists.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            AppStrings.noPlaylistsYet,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ...state.playlists.map(
                        (playlist) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PlaylistCard(
                            playlist: playlist,
                            onTap: () => _openPlaylist(context, playlist),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    ),
  );
}
