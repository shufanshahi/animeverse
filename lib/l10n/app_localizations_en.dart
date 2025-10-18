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

  @override
  String get animeAssistant => 'Anime Assistant';

  @override
  String get askAboutAnime => 'Ask about anime...';

  @override
  String get lmStudioNotConnected => 'LM Studio not connected';

  @override
  String get askMeAnything => 'Ask me anything about anime!';

  @override
  String get chatbotDescription =>
      'I can help with recommendations,\ncharacter info, and more!';

  @override
  String get thinking => 'Thinking...';

  @override
  String get similarAnime => 'Similar Anime:';

  @override
  String get failedToGetResponse => 'Failed to get response.';

  @override
  String get noModelLoaded =>
      '🤖 No model loaded in LM Studio. Please load a model first!';

  @override
  String get corsError =>
      '🌐 CORS error detected. Please run: flutter run -d chrome --web-browser-flag \"--disable-web-security\"';

  @override
  String get connectionRefused =>
      '🔌 Cannot connect to LM Studio. Make sure it\'s running on localhost:1234';

  @override
  String get serverRunningNoModel =>
      '⚠️ LM Studio server is running but no model is loaded. Please load a model!';

  @override
  String get requestTimeout =>
      '⏱️ Request timed out. The model might be processing a complex response. Try a simpler question or check if your model is responsive.';

  @override
  String get responseTimeout =>
      '⏱️ Response took too long. Try breaking down your question into smaller parts or use a faster model.';

  @override
  String get lmStudioNotRunning =>
      '⚠️ LM Studio server is not running on localhost:1234';

  @override
  String get failedToConnect => 'Failed to connect to LM Studio';

  @override
  String get myWishlist => 'My Wishlist';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get yourWishlistIsEmpty => 'Your wishlist is empty';

  @override
  String get addAnimeToWatchLater => 'Add anime to watch later';

  @override
  String get exploreAnime => 'Explore Anime';

  @override
  String episodesCount(int count) {
    return '$count episodes';
  }

  @override
  String get removedFromWishlist => 'Removed from wishlist';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get retryButton => 'Retry';

  @override
  String get createProfile => 'Create Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get signInToSave =>
      'You can fill out your profile information, but you\'ll need to sign in to save it.';

  @override
  String get pleaseSignInToSave => 'Please sign in to save your profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterYourEmail => 'Enter your email address';

  @override
  String get emailRequired => 'Email address is required';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get firstName => 'First Name';

  @override
  String get enterFirstName => 'Enter your first name';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastName => 'Last Name';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get addressInformation => 'Address Information';

  @override
  String get streetAddress => 'Street Address';

  @override
  String get streetRequired => 'Street address is required';

  @override
  String get state => 'State';

  @override
  String get stateRequired => 'State is required';

  @override
  String get zipCode => 'ZIP Code';

  @override
  String get zipRequired => 'ZIP code is required';

  @override
  String get zipMinLength => 'ZIP code must be at least 5 characters';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneHint => '(123) 456-7890';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get enterValidPhone => 'Please enter a valid phone number';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileWelcomeBack => 'Welcome back!';

  @override
  String get profilePersonalInformation => 'Personal Information';

  @override
  String get profileFullName => 'Full Name';

  @override
  String get profileEmailAddress => 'Email Address';

  @override
  String get profileStreetAddress => 'Street Address';

  @override
  String get profileState => 'State';

  @override
  String get profileZipCode => 'ZIP Code';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileNotProvided => 'Not provided';
}
