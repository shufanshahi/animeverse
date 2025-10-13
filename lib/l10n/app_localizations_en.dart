// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AnimeHub';

  @override
  String get welcomeTitle => 'Welcome to AnimeHub';

  @override
  String get welcomeSubtitle => 'Your anime discovery platform';

  @override
  String get trendingNow => 'Trending Now';

  @override
  String get popular => 'Popular';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get watchlist => 'Watchlist';

  @override
  String get profile => 'Profile';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get information => 'Information';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get genres => 'Genres';

  @override
  String get type => 'Type';

  @override
  String get episodes => 'Episodes';

  @override
  String get status => 'Status';

  @override
  String get aired => 'Aired';

  @override
  String get source => 'Source';

  @override
  String get duration => 'Duration';

  @override
  String get score => 'Score';

  @override
  String get rank => 'Rank';

  @override
  String get popularity => 'Popularity';

  @override
  String get members => 'Members';

  @override
  String get favorites => 'Favorites';

  @override
  String get studios => 'Studios';

  @override
  String get trailer => 'Trailer';

  @override
  String get relations => 'Relations';

  @override
  String get themes => 'Themes';

  @override
  String get streaming => 'Streaming';

  @override
  String get external => 'External Links';

  @override
  String get openings => 'Opening Themes';

  @override
  String get endings => 'Ending Themes';

  @override
  String get unknown => 'Unknown';

  @override
  String get noSynopsisAvailable => 'No synopsis available';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get watchTrailer => 'Watch Trailer';

  @override
  String get language => 'Language';

  @override
  String rating(String rating) {
    return 'Rating: $rating';
  }

  @override
  String animeTitle(int number) {
    return 'Anime Title $number';
  }
}
