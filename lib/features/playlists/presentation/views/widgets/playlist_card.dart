import 'package:e_learning/core/themes/app_color.dart';
import 'package:e_learning/features/playlists/data/models/playlist_model.dart';
import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({super.key, required this.playlist, required this.onTap});

  final PlaylistModel playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE8F5F3),
        child: Icon(Icons.video_library_rounded, color: AppColor.primary),
      ),
      title: Text(
        playlist.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('${playlist.videoCount} فيديو'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    ),
  );
}
