class VideoItem {
  const VideoItem({
    required this.databaseId,
    required this.name,
    required this.id,
    required this.playlistId,
    this.thumbnailUrl,
  });

  final String databaseId;
  final String name;
  // YouTube ID is used by the player; databaseId is used for deleting the row.
  final String id;
  final String playlistId;
  final String? thumbnailUrl;

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
    databaseId: json['id'] as String,
    name: json['title'] as String,
    id: json['youtube_id'] as String,
    playlistId: json['playlist_id'] as String,
    thumbnailUrl: json['thumbnail_url'] as String?,
  );
}
