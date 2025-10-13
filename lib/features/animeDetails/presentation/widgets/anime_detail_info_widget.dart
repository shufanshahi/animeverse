import 'package:flutter/material.dart';
import '../../domain/entities/anime_detail.dart';

class AnimeDetailInfoWidget extends StatelessWidget {
  final AnimeDetail anime;

  const AnimeDetailInfoWidget({
    Key? key,
    required this.anime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Type', anime.type ?? 'Unknown'),
            _buildInfoRow('Episodes', anime.episodes?.toString() ?? 'Unknown'),
            _buildInfoRow('Status', anime.status ?? 'Unknown'),
            _buildInfoRow('Aired', anime.aired?.string ?? 'Unknown'),
            _buildInfoRow('Source', anime.source ?? 'Unknown'),
            _buildInfoRow('Duration', anime.duration ?? 'Unknown'),
            if (anime.score != null) _buildInfoRow('Score', '${anime.score}/10'),
            if (anime.rank != null) _buildInfoRow('Rank', '#${anime.rank}'),
            if (anime.popularity != null) _buildInfoRow('Popularity', '#${anime.popularity}'),
            if (anime.members != null) _buildInfoRow('Members', anime.members.toString()),
            if (anime.favorites != null) _buildInfoRow('Favorites', anime.favorites.toString()),
            if (anime.studios.isNotEmpty)
              _buildInfoRow('Studios', anime.studios.map((s) => s.name).join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}