abstract final class YoutubeUrl {
  static String? videoId(String input) {
    final uri = Uri.tryParse(input.trim());
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      return null;
    }
    String? id;
    if (uri.host == 'youtu.be' || uri.host == 'www.youtu.be') {
      id = uri.pathSegments.firstOrNull;
    } else if (const [
      'youtube.com',
      'www.youtube.com',
      'm.youtube.com',
      'music.youtube.com',
    ].contains(uri.host)) {
      if (uri.path == '/watch') {
        id = uri.queryParameters['v'];
      } else if (uri.pathSegments.length == 2 &&
          const ['shorts', 'embed', 'live'].contains(uri.pathSegments.first)) {
        id = uri.pathSegments[1];
      }
    }
    return id != null && RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(id)
        ? id
        : null;
  }
}
