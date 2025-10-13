import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entities/anime_detail.dart';
import '../../../../l10n/app_localizations.dart';

class AnimeTrailerWidget extends StatefulWidget {
  final AnimeTrailer trailer;

  const AnimeTrailerWidget({
    Key? key,
    required this.trailer,
  }) : super(key: key);

  @override
  State<AnimeTrailerWidget> createState() => _AnimeTrailerWidgetState();
}

class _AnimeTrailerWidgetState extends State<AnimeTrailerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.trailer.youtubeId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.trailer.youtubeId!,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (widget.trailer.youtubeId != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (widget.trailer.youtubeId == null) {
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
              localizations.trailer,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {
                  // Handle video end
                },
              ),
            ),
            const SizedBox(height: 12),
            if (widget.trailer.url != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // You can add additional functionality here
                    // like opening in external YouTube app
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(localizations.watchTrailer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}