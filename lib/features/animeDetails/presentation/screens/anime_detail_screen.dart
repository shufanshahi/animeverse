import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/anime_detail.dart';
import '../bloc/anime_detail_bloc.dart';
import '../widgets/anime_detail_info_widget.dart';
import '../widgets/anime_detail_synopsis_widget.dart';
import '../widgets/anime_detail_genres_widget.dart';

class AnimeDetailScreen extends StatelessWidget {
  final int animeId;

  const AnimeDetailScreen({
    Key? key,
    required this.animeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
        builder: (context, state) {
          if (state is AnimeDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AnimeDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AnimeDetailBloc>().add(
                            GetAnimeDetailEvent(animeId),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is AnimeDetailLoaded) {
            return _buildAnimeDetailContent(context, state.animeDetail);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAnimeDetailContent(BuildContext context, AnimeDetail anime) {
    final imageUrl = anime.images.isNotEmpty
        ? anime.images.first.imageUrls.largeImageUrl ??
            anime.images.first.imageUrls.imageUrl
        : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              anime.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            background: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AnimeDetailInfoWidget(anime: anime),
              const SizedBox(height: 24),
              AnimeDetailGenresWidget(genres: anime.genres),
              const SizedBox(height: 24),
              AnimeDetailSynopsisWidget(synopsis: anime.synopsis ?? 'No synopsis available'),
              const SizedBox(height: 100), // Extra space at bottom
            ]),
          ),
        ),
      ],
    );
  }
}