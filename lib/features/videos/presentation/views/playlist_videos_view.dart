import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/extensions/snack_bar_context_extension.dart';
import 'package:e_learning/core/routing/routes.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_cubit.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_state.dart';
import 'package:e_learning/features/videos/presentation/views/widgets/library_status.dart';
import 'package:e_learning/features/videos/presentation/views/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistVideosView extends StatelessWidget {
  const PlaylistVideosView({super.key, required this.playlist});

  final PlaylistModel playlist;

  Future<void> _addVideo(BuildContext context) async {
    final saved = await Navigator.of(
      context,
    ).pushNamed(Routes.addVideo, arguments: playlist);
    if (context.mounted && saved == true) {
      context.read<VideosCubit>().getVideos(playlist.id);
      context.showSuccessSnackBar(AppStrings.videoAddedSuccessfully);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = context.read<AuthCubit>().currentAccount != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        actions: [
          if (signedIn)
            IconButton(
              onPressed: () => _addVideo(context),
              tooltip: 'إضافة فيديو جديد',
              icon: const Icon(Icons.add_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<VideosCubit>().getVideos(playlist.id),
              child: BlocConsumer<VideosCubit, VideosState>(
                listener: (context, state) {
                  if (state is DeleteVideoSuccess) {
                    context.showSuccessSnackBar(state.message);
                  } else if (state is DeleteVideoFailure) {
                    context.showErrorSnackBar(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  final canDelete =
                      context.read<AuthCubit>().currentAccount != null;
                  if (state is VideosFailure) {
                    return LibraryStatus(
                      message: state.errorMessage,
                      onRetry: () =>
                          context.read<VideosCubit>().getVideos(playlist.id),
                    );
                  }
                  if (state is VideosSuccess) {
                    if (state.videos.isEmpty) {
                      return const LibraryStatus(
                        message: AppStrings.noPlaylistVideos,
                      );
                    }
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: state.videos.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final video = state.videos[index];
                        return VideoCard(
                          video: video,
                          deleting:
                              state is DeleteVideoLoading &&
                              state.videoId == video.databaseId,
                          deleteEnabled: state is! DeleteVideoLoading,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(Routes.video, arguments: video),
                          onDelete: canDelete
                              ? () => context.read<VideosCubit>().deleteVideo(
                                  video.databaseId,
                                )
                              : null,
                        );
                      },
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
}
