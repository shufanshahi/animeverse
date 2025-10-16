import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/providers/locale_provider.dart';

class GenreChips extends ConsumerStatefulWidget {
  final List<String> selectedGenres;
  final Function(String) onGenreSelected;

  const GenreChips({
    Key? key,
    required this.selectedGenres,
    required this.onGenreSelected,
  }) : super(key: key);

  @override
  ConsumerState<GenreChips> createState() => _GenreChipsState();
}

class _GenreChipsState extends ConsumerState<GenreChips> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    final locale = ref.watch(localeProvider);
    final lang = locale.languageCode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            AppLocalizations.translate('browse_by_genre', lang),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 6,
            radius: const Radius.circular(10),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              itemCount: popularGenres.length,
              itemBuilder: (context, index) {
                final genre = popularGenres[index];
                final isSelected = widget.selectedGenres.contains(genre);
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(AppLocalizations.translateGenre(genre, lang)),
                    selected: isSelected,
                    onSelected: (_) => widget.onGenreSelected(genre),
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}