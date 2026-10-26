import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    super.key,
    required this.videoCount,
    required this.playlistCount,
    this.onAddVideo,
  });

  final int videoCount;
  final int playlistCount;
  final VoidCallback? onAddVideo;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColor.primary, Color(0xFF0F8992)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلاً بك في ${AppStrings.appName}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$playlistCount قائمة تشغيل · $videoCount فيديو تعليمي',
                style: const TextStyle(color: Colors.white70),
              ),
              if (onAddVideo != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onAddVideo,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(AppStrings.addVideo),
                ),
              ],
            ],
          ),
        ),
        const Icon(Icons.science_rounded, color: Colors.white54, size: 74),
      ],
    ),
  );
}
