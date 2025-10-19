import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../anime_wishlist/domain/entities/anime_wishlist.dart';
import '../../../anime_wishlist/presentation/providers/anime_wishlist_provider.dart';
import '../../../auth/presentation/riverpod/auth_provider.dart';
import '../../../comments/presentation/widgets/comment_section_widget.dart';
import '../../domain/entities/anime_detail.dart';
import '../../domain/usecases/get_anime_detail.dart';
import '../providers/anime_detail_provider.dart';
import '../widgets/anime_detail_genres_widget.dart';
import '../widgets/anime_detail_info_widget.dart';
import '../widgets/anime_detail_synopsis_widget.dart';
import '../widgets/anime_external_widget.dart';
import '../widgets/anime_relations_widget.dart';
import '../widgets/anime_streaming_widget.dart';
import '../widgets/anime_themes_widget.dart';
import '../widgets/anime_trailer_widget.dart';

class AnimeDetailScreen extends ConsumerStatefulWidget {
  final int animeId;

  const AnimeDetailScreen({
    Key? key,
    required this.animeId,
  }) : super(key: key);

  @override
  ConsumerState<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends ConsumerState<AnimeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(animeDetailProvider.notifier)
            .getAnimeDetail(GetAnimeDetailParams(id: widget.animeId));
        // Check if this anime is in wishlist
        ref.read(wishlistProvider.notifier).checkWishlistStatus(widget.animeId);
      }
    });
  }

  Future<void> _toggleWishlist(AnimeDetail anime) async {
    final auth = ref.read(authProvider);
    final userEmail = auth.user?.email;

    if (userEmail == null || userEmail.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to add to wishlist')),
        );
      }
      return;
    }

    final wishlistItem = AnimeWishlist(
      id: '${userEmail}_${anime.malId}',
      userId: userEmail, // Using email as userId
      animeId: anime.malId,
      title: anime.title,
      imageUrl: anime.images['jpg']?.imageUrl,
      score: anime.score,
      type: anime.type,
      episodes: anime.episodes,
      addedAt: DateTime.now(),
    );

    final success = await ref.read(wishlistProvider.notifier).toggleWishlist(wishlistItem);

    if (mounted && success) {
      final isInWishlist = ref.read(wishlistProvider.notifier).isInWishlist(anime.malId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isInWishlist ? 'Added to wishlist' : 'Removed from wishlist'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(animeDetailProvider);
    final wishlistState = ref.watch(wishlistProvider);
    final isInWishlist = state.animeDetail != null 
        ? wishlistState.wishlistStatus[state.animeDetail!.malId] ?? false
        : false;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.animeDetail?.title ?? 'Anime Details'),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        actions: [
          if (state.animeDetail != null)
            IconButton(
              icon: Icon(
                isInWishlist ? Icons.bookmark : Icons.bookmark_border,
              ),
              color: isInWishlist ? Theme.of(context).primaryColor : null,
              tooltip: isInWishlist ? 'Remove from wishlist' : 'Add to wishlist',
              onPressed: () => _toggleWishlist(state.animeDetail!),
            ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state.error != null
                ? _buildError(context, state.error!)
                : state.animeDetail == null
                    ? const Center(child: Text('No data available'))
                    : _buildContent(context, state.animeDetail!),
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(animeDetailProvider.notifier)
                .getAnimeDetail(GetAnimeDetailParams(id: widget.animeId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnimeDetail anime) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (anime.images.isNotEmpty)
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: anime.images['jpg']?.largeImageUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimeDetailInfoWidget(anime: anime),
                const SizedBox(height: 16),
                if (anime.synopsis != null) AnimeDetailSynopsisWidget(synopsis: anime.synopsis!),
                const SizedBox(height: 16),
                AnimeDetailGenresWidget(genres: anime.genres),
                if (anime.trailer != null) ...[
                  const SizedBox(height: 16),
                  AnimeTrailerWidget(trailer: anime.trailer!),
                ],
                if (anime.relations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  AnimeRelationsWidget(relations: anime.relations),
                ],
                if (anime.theme != null) ...[
                  const SizedBox(height: 16),
                  AnimeThemesWidget(theme: anime.theme!),
                ],
                if (anime.streaming.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  AnimeStreamingWidget(streaming: anime.streaming),
                ],
                if (anime.external.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  AnimeExternalWidget(external: anime.external),
                ],
              ],
            ),
          ),
          // Comment Section
          const Divider(height: 32, thickness: 2),
          CommentSectionWidget(animeId: anime.malId),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
