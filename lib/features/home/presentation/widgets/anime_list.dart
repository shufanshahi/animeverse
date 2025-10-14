import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import 'anime_card.dart';

class AnimeList extends StatelessWidget {
  final List<AnimeEntity> animeList;
  final String title;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const AnimeList({
    Key? key,
    required this.animeList,
    required this.title,
    this.isLoading = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onLoadMore != null)
                TextButton(
                  onPressed: isLoading ? null : onLoadMore,
                  child: Text(isLoading ? 'Loading...' : 'View All'),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: animeList.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == animeList.length && isLoading) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              return AnimeCard(anime: animeList[index]);
            },
          ),
        ),
      ],
    );
  }
}