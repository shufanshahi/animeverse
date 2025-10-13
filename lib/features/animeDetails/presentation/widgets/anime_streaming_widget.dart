import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/anime_detail.dart';
import '../../../../l10n/app_localizations.dart';

class AnimeStreamingWidget extends StatelessWidget {
  final List<AnimeStreaming> streaming;

  const AnimeStreamingWidget({
    Key? key,
    required this.streaming,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (streaming.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.streaming,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: streaming
                  .map((platform) => _buildStreamingChip(context, platform))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamingChip(BuildContext context, AnimeStreaming platform) {
    return InkWell(
      onTap: () => _launchURL(platform.url),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStreamingIcon(platform.name),
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              platform.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.open_in_new,
              size: 14,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStreamingIcon(String platformName) {
    switch (platformName.toLowerCase()) {
      case 'crunchyroll':
        return Icons.play_circle;
      case 'netflix':
        return Icons.movie;
      case 'funimation':
        return Icons.tv;
      case 'hulu':
        return Icons.live_tv;
      default:
        return Icons.video_library;
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}