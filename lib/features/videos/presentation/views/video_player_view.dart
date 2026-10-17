import 'package:e_learning/features/videos/data/models/video_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.video});

  final VideoItem video;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // The installed player supports Android, iOS, macOS and web.
    final supported =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    if (supported) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: widget.video.id,
        autoPlay: true,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.video.name)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (controller != null) ...[
                  YoutubePlayer(
                    controller: controller,
                    backgroundColor: Colors.black,
                  ),
                  StreamBuilder<YoutubePlayerValue>(
                    stream: controller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.data!.error == YoutubeError.none) {
                        return const SizedBox.shrink();
                      }
                      return const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'تعذر تشغيل الفيديو. تحققي من الاتصال أو جربي فيديو آخر.',
                        ),
                      );
                    },
                  ),
                ] else
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'لمشاهدة الفيديو افتحي التطبيق على Android أو iOS أو macOS أو متصفح الويب.',
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(widget.video.name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'فيديو من قناة بسمة على YouTube',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
