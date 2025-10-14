import 'package:flutter/material.dart';

class GenreChips extends StatelessWidget {
  final List<String> selectedGenres;
  final Function(String) onGenreSelected;

  const GenreChips({
    Key? key,
    required this.selectedGenres,
    required this.onGenreSelected,
  }) : super(key: key);

  static const List<String> popularGenres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'Horror',
    'Mystery',
    'Slice of Life',
    'Sports',
    'Supernatural',
    'Military',
    'School',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Browse by Genre',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularGenres.length,
            itemBuilder: (context, index) {
              final genre = popularGenres[index];
              final isSelected = selectedGenres.contains(genre);
              
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (_) => onGenreSelected(genre),
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}