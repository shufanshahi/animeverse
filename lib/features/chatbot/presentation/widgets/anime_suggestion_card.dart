import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/entities.dart';

class AnimeSuggestionCard extends ConsumerWidget {
  final AnimeSuggestionEntity anime;
  final VoidCallback? onNavigate;

  const AnimeSuggestionCard({
    super.key,
    required this.anime,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Close the chatbot overlay before navigating
        onNavigate?.call();
        // Navigate to anime details page
        context.pushNamed('animeDetail', pathParameters: {'id': anime.id.toString()});
      },
      child: Container(
        width: 130, // Reduced width to fit better
        height: 140, // Set explicit height to prevent overflow
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anime Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: anime.imageUrl,
                height: 80, // Further reduced height
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 80,
                  color: theme.colorScheme.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 80,
                  color: theme.colorScheme.surfaceVariant,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
            // Anime Info - Use Expanded to prevent overflow
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4), // Further reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Flexible(
                    child: Text(
                      anime.title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 11, // Reduced font size
                        fontWeight: FontWeight.w600,
                        height: 1.2, // Reduced line height
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced spacing
                  if (anime.score != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 10, // Smaller icon
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 1),
                        Text(
                          '${anime.score!.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 9, // Smaller text
                          ),
                        ),
                      ],
                    ),
                  if (anime.year != null)
                    Text(
                      '${anime.year}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 9, // Smaller text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}