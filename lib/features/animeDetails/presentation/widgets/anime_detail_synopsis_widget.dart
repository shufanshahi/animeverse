import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/providers/locale_provider.dart';

class AnimeDetailSynopsisWidget extends ConsumerWidget {
  final String synopsis;

  const AnimeDetailSynopsisWidget({
    super.key,
    required this.synopsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final lang = locale.languageCode;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.translate('synopsis', lang),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              synopsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}