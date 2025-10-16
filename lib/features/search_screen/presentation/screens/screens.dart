import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  const SearchScreen({Key? key, this.initialQuery}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  void _triggerSearch() {
    ref.read(searchStateProvider.notifier).search(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    if ((widget.initialQuery ?? '').isNotEmpty) {
      _controller.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerSearch());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);
    final notifier = ref.read(searchStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Anime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBox(
              controller: _controller,
              onSubmitted: (_) => _triggerSearch(),
              onSearch: _triggerSearch,
              onChanged: notifier.onQueryChanged, // live updates with debounce
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchState.when(
                data: (animes) {
                  if (animes.isEmpty) {
                    return const Center(child: Text('No anime found.'));
                  }
                  return ListView.builder(
                    itemCount: animes.length,
                    itemBuilder: (context, index) {
                      final anime = animes[index];
                      return AnimeCard(anime: anime);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}