import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import 'anime_card.dart';

class AnimeList extends StatefulWidget {
  final List<AnimeEntity> animeList;
  final String title;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final int maxDisplayCount;

  const AnimeList({
    super.key,
    required this.animeList,
    required this.title,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.maxDisplayCount = 20,
  });

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Limit the display to maxDisplayCount items initially
    final displayList = widget.animeList.length > widget.maxDisplayCount 
        ? widget.animeList.sublist(0, widget.maxDisplayCount) 
        : widget.animeList;
    final hasMore = widget.animeList.length >= widget.maxDisplayCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 6,
            radius: const Radius.circular(10),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              itemCount: displayList.length + (hasMore && widget.onLoadMore != null ? 1 : 0),
              itemBuilder: (context, index) {
                // Show "View More" button at the end
                if (index == displayList.length && hasMore && widget.onLoadMore != null) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    child: Material(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: widget.isLoadingMore ? null : widget.onLoadMore,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: widget.isLoadingMore
                              ? const CircularProgressIndicator()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      size: 48,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'View More',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }
                
                return AnimeCard(anime: displayList[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}