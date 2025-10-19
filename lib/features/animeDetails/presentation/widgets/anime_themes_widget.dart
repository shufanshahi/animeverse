import 'package:flutter/material.dart';
import '../../domain/entities/anime_detail.dart';
import '../../../../l10n/app_localizations.dart';

class AnimeThemesWidget extends StatelessWidget {
  final AnimeTheme? theme;

  const AnimeThemesWidget({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    if (theme == null || (theme!.openings.isEmpty && theme!.endings.isEmpty)) {
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
              localizations.themes,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (theme!.openings.isNotEmpty) ...[
              Text(
                localizations.openings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              ...theme!.openings.asMap().entries.map((entry) => 
                _buildThemeItem(context, entry.key + 1, entry.value, true)),
              const SizedBox(height: 16),
            ],
            if (theme!.endings.isNotEmpty) ...[
              Text(
                localizations.endings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 8),
              ...theme!.endings.asMap().entries.map((entry) => 
                _buildThemeItem(context, entry.key + 1, entry.value, false)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThemeItem(BuildContext context, int index, String theme, bool isOpening) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isOpening 
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOpening 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              theme,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}