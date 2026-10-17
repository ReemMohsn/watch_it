class PlaylistModel {
  const PlaylistModel({
    required this.id,
    required this.name,
    this.videoCount = 0,
  });

  final String id;
  final String name;
  final int videoCount;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final counts = json['youtube_videos'] as List<dynamic>? ?? const [];
    return PlaylistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      videoCount: counts.isEmpty ? 0 : (counts.first['count'] as num).toInt(),
    );
  }
}
