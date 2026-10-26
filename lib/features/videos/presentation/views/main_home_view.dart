import 'package:e_learning/core/constants/app_image.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/extensions/snack_bar_context_extension.dart';
import 'package:e_learning/core/routing/routes.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_state.dart';
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

  void _handleAuth(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    if (authCubit.currentAccount == null) {
      Navigator.of(context).pushNamed(Routes.teacherLogin);
    } else {
      authCubit.signOut();
    }
  }

  Future<void> _addVideo(BuildContext context) async {
    final saved = await Navigator.of(context).pushNamed(Routes.addVideo);
    if (context.mounted && saved == true) {
      context.read<PlaylistsCubit>().getPlaylists();
      context.showSuccessSnackBar(AppStrings.videoAddedSuccessfully);
    }
  }

  Future<void> _deletePlaylist(
    BuildContext context,
    PlaylistModel playlist,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deletePlaylist),
        content: Text(AppStrings.confirmPlaylistDeletion(playlist.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.deletePlaylist),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    if (context.read<AuthCubit>().currentAccount == null) return;
    context.read<PlaylistsCubit>().deletePlaylist(playlist.id);
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
  Widget build(BuildContext context) => BlocConsumer<AuthCubit, AuthState>(
    listener: (context, state) {
      if (state is SignOutSuccess) {
        context.showSuccessSnackBar(state.message);
      } else if (state is SignOutFailure) {
        context.showErrorSnackBar(state.errorMessage);
      }
    },
    builder: (context, authState) {
      final authCubit = context.read<AuthCubit>();
      final signedIn = authCubit.currentAccount != null;
      return Scaffold(
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
                child: Text(
                  AppStrings.appName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            if (signedIn)
              IconButton(
                onPressed: authCubit.isBusy ? null : () => _addVideo(context),
                tooltip: AppStrings.addVideo,
                icon: const Icon(Icons.add_rounded),
              ),
            TextButton.icon(
              onPressed: authCubit.isBusy ? null : () => _handleAuth(context),
              icon: authState is SignOutLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(signedIn ? Icons.logout_rounded : Icons.login_rounded),
              label: Text(signedIn ? AppStrings.signOut : AppStrings.signIn),
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
                child: BlocConsumer<PlaylistsCubit, PlaylistsState>(
                  listener: (context, state) {
                    if (state is DeletePlaylistSuccess) {
                      context.showSuccessSnackBar(state.message);
                    } else if (state is DeletePlaylistFailure) {
                      context.showErrorSnackBar(state.errorMessage);
                    }
                  },
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
                            onAddVideo: signedIn && !authCubit.isBusy
                                ? () => _addVideo(context)
                                : null,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppStrings.playlists,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
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
                                deleting:
                                    state is DeletePlaylistLoading &&
                                    state.playlistId == playlist.id,
                                deleteEnabled:
                                    state is! DeletePlaylistLoading &&
                                    !authCubit.isBusy,
                                onTap: () => _openPlaylist(context, playlist),
                                onDelete: signedIn
                                    ? () => _deletePlaylist(context, playlist)
                                    : null,
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
    },
  );
}
