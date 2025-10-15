import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/entities.dart';

class AnimeSuggestionCard extends ConsumerWidget {
  final AnimeSuggestionEntity anime;

  const AnimeSuggestionCard({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Navigate to anime details page
        context.pushNamed('animeDetail', pathParameters: {'id': anime.id.toString()});
      },
      child: Container(
        width: 140,
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
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 100,
                  color: theme.colorScheme.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  color: theme.colorScheme.surfaceVariant,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            // Anime Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (anime.score != null)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${anime.score!.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  if (anime.year != null)
                    Text(
                      '${anime.year}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}