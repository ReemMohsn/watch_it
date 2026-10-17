import 'package:e_learning/core/common/utils/youtube_url.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_cubit.dart';
import 'package:e_learning/features/playlists/presentation/view_model/playlists_state.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_cubit.dart';
import 'package:e_learning/features/videos/presentation/view_model/videos_state.dart';
import 'package:e_learning/features/videos/presentation/views/widgets/library_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key, this.initialPlaylist});

  final PlaylistModel? initialPlaylist;

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  static const _newPlaylistOption = 'new-playlist';
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _url = TextEditingController();
  final _newPlaylistName = TextEditingController();
  String? _selectedOption;

  @override
  void dispose() {
    _title.dispose();
    _url.dispose();
    _newPlaylistName.dispose();
    super.dispose();
  }

  String _selection(List<PlaylistModel> playlists) {
    if (_selectedOption == _newPlaylistOption) return _newPlaylistOption;
    final selectedId = _selectedOption ?? widget.initialPlaylist?.id;
    if (playlists.any((playlist) => playlist.id == selectedId))
      return selectedId!;
    return playlists.isEmpty ? _newPlaylistOption : playlists.first.id;
  }

  void _save(String selection) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final creatingPlaylist = selection == _newPlaylistOption;
    context.read<VideosCubit>().addVideo(
      title: _title.text,
      url: _url.text,
      playlistId: creatingPlaylist ? null : selection,
      newPlaylistName: creatingPlaylist ? _newPlaylistName.text : null,
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<VideosCubit, VideosState>(
    listener: (context, state) {
      if (state is AddVideoSuccess) Navigator.of(context).pop(true);
    },
    builder: (context, state) {
      final saving = state is AddVideoLoading;
      final error = state is AddVideoFailure ? state.errorMessage : null;
      return Scaffold(
        appBar: AppBar(title: const Text('إضافة فيديو جديد')),
        body: SafeArea(
          child: BlocBuilder<PlaylistsCubit, PlaylistsState>(
            builder: (context, playlistsState) {
              if (playlistsState is PlaylistsFailure) {
                return LibraryStatus(
                  message: playlistsState.errorMessage,
                  onRetry: () => context.read<PlaylistsCubit>().getPlaylists(),
                );
              }
              if (playlistsState is! PlaylistsSuccess) {
                return const Center(child: CircularProgressIndicator());
              }
              final playlists = playlistsState.playlists;
              final selection = _selection(playlists);
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'اختاري قائمة تشغيل أو أضيفي قائمة جديدة، ثم أدخلي رابط الفيديو.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            key: ValueKey(selection),
                            initialValue: selection,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: AppStrings.playlists,
                              prefixIcon: Icon(Icons.folder_copy_outlined),
                            ),
                            items: [
                              ...playlists.map(
                                (playlist) => DropdownMenuItem(
                                  value: playlist.id,
                                  child: Text(
                                    playlist.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const DropdownMenuItem(
                                value: _newPlaylistOption,
                                child: Text(AppStrings.newPlaylist),
                              ),
                            ],
                            onChanged: saving
                                ? null
                                : (value) =>
                                      setState(() => _selectedOption = value),
                            validator: (value) => value == null
                                ? AppStrings.choosePlaylist
                                : null,
                          ),
                          if (selection == _newPlaylistOption) ...[
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _newPlaylistName,
                              enabled: !saving,
                              maxLength: 120,
                              decoration: const InputDecoration(
                                labelText: AppStrings.newPlaylistName,
                                prefixIcon: Icon(
                                  Icons.create_new_folder_outlined,
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? AppStrings.enterPlaylistName
                                  : null,
                            ),
                          ],
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _url,
                            enabled: !saving,
                            keyboardType: TextInputType.url,
                            textDirection: TextDirection.ltr,
                            decoration: const InputDecoration(
                              labelText: 'رابط الفيديو *',
                              hintText: 'https://www.youtube.com/watch?v=...',
                              prefixIcon: Icon(Icons.link_rounded),
                            ),
                            validator: (value) =>
                                YoutubeUrl.videoId(value ?? '') == null
                                ? AppStrings.invalidYoutubeUrl
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _title,
                            enabled: !saving,
                            decoration: const InputDecoration(
                              labelText: 'عنوان الفيديو (اختياري)',
                              prefixIcon: Icon(Icons.title_rounded),
                            ),
                          ),
                          if (error != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              error,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 22),
                          ElevatedButton.icon(
                            onPressed: saving ? null : () => _save(selection),
                            icon: saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add_link_rounded),
                            label: Text(
                              saving ? 'جارٍ الحفظ...' : 'حفظ الفيديو',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
