import 'package:e_learning/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class LibraryStatus extends StatelessWidget {
  const LibraryStatus({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(24),
    children: [
      Icon(
        onRetry == null
            ? Icons.video_library_outlined
            : Icons.cloud_off_outlined,
        size: 48,
      ),
      const SizedBox(height: 12),
      Text(message, textAlign: TextAlign.center),
      if (onRetry != null) ...[
        const SizedBox(height: 12),
        TextButton(onPressed: onRetry, child: const Text(AppStrings.tryAgain)),
      ],
    ],
  );
}
