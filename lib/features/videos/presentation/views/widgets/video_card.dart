import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/themes/app_color.dart';
import 'package:e_learning/features/videos/data/models/video_item.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    this.onDelete,
    this.deleting = false,
    this.deleteEnabled = true,
  });

  final VideoItem video;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool deleting;
  final bool deleteEnabled;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          video.thumbnailUrl ??
              'https://i.ytimg.com/vi/${video.id}/mqdefault.jpg',
          width: 76,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: 76,
            height: 48,
            color: AppColor.background,
            child: const Icon(Icons.play_arrow_rounded),
          ),
        ),
      ),
      title: Text(video.name, maxLines: 3, overflow: TextOverflow.ellipsis),
      trailing: deleting
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : onDelete == null
          ? const Icon(
              Icons.play_circle_outline_rounded,
              color: AppColor.primary,
            )
          : IconButton(
              onPressed: deleteEnabled ? onDelete : null,
              tooltip: AppStrings.deleteVideo,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColor.danger,
              ),
            ),
      onTap: onTap,
    ),
  );
}
