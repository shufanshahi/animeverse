import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'AnimeHub'**
  String get appTitle;

  /// Welcome message title
  ///
  /// In en, this message translates to:
  /// **'Welcome to AnimeHub'**
  String get welcomeTitle;

  /// Welcome message subtitle
  ///
  /// In en, this message translates to:
  /// **'Your anime discovery platform'**
  String get welcomeSubtitle;

  /// Trending section title
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// Popular section title
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Search tab label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Watchlist tab label
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlist;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Light mode tooltip
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Dark mode tooltip
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Information section title
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// Synopsis section title
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// Genres section title
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// Anime type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Episodes label
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Aired label
  ///
  /// In en, this message translates to:
  /// **'Aired'**
  String get aired;

  /// Source label
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Rank label
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// Popularity label
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// Members label
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// Favorites label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Studios label
  ///
  /// In en, this message translates to:
  /// **'Studios'**
  String get studios;

  /// Trailer section title
  ///
  /// In en, this message translates to:
  /// **'Trailer'**
  String get trailer;

  /// Relations section title
  ///
  /// In en, this message translates to:
  /// **'Relations'**
  String get relations;

  /// Theme songs section title
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// Streaming platforms section title
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streaming;

  /// External links section title
  ///
  /// In en, this message translates to:
  /// **'External Links'**
  String get external;

  /// Opening themes label
  ///
  /// In en, this message translates to:
  /// **'Opening Themes'**
  String get openings;

  /// Ending themes label
  ///
  /// In en, this message translates to:
  /// **'Ending Themes'**
  String get endings;

  /// Unknown value placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Message when synopsis is not available
  ///
  /// In en, this message translates to:
  /// **'No synopsis available'**
  String get noSynopsisAvailable;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Watch trailer button text
  ///
  /// In en, this message translates to:
  /// **'Watch Trailer'**
  String get watchTrailer;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Rating with placeholder
  ///
  /// In en, this message translates to:
  /// **'Rating: {rating}'**
  String rating(String rating);

  /// Anime title with number placeholder
  ///
  /// In en, this message translates to:
  /// **'Anime Title {number}'**
  String animeTitle(int number);

  /// Chatbot header title
  ///
  /// In en, this message translates to:
  /// **'Anime Assistant'**
  String get animeAssistant;

  /// Chat input placeholder when connected
  ///
  /// In en, this message translates to:
  /// **'Ask about anime...'**
  String get askAboutAnime;

  /// Chat input placeholder when not connected
  ///
  /// In en, this message translates to:
  /// **'LM Studio not connected'**
  String get lmStudioNotConnected;

  /// Empty chat welcome message
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about anime!'**
  String get askMeAnything;

  /// Chatbot capabilities description
  ///
  /// In en, this message translates to:
  /// **'I can help with recommendations,\ncharacter info, and more!'**
  String get chatbotDescription;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// Anime suggestions section header
  ///
  /// In en, this message translates to:
  /// **'Similar Anime:'**
  String get similarAnime;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Failed to get response.'**
  String get failedToGetResponse;

  /// Error when no model is loaded
  ///
  /// In en, this message translates to:
  /// **'🤖 No model loaded in LM Studio. Please load a model first!'**
  String get noModelLoaded;

  /// CORS error message
  ///
  /// In en, this message translates to:
  /// **'🌐 CORS error detected. Please run: flutter run -d chrome --web-browser-flag \"--disable-web-security\"'**
  String get corsError;

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'🔌 Cannot connect to LM Studio. Make sure it\'s running on localhost:1234'**
  String get connectionRefused;

  /// Server running but no model error
  ///
  /// In en, this message translates to:
  /// **'⚠️ LM Studio server is running but no model is loaded. Please load a model!'**
  String get serverRunningNoModel;

  /// Timeout error message
  ///
  /// In en, this message translates to:
  /// **'⏱️ Request timed out. The model might be processing a complex response. Try a simpler question or check if your model is responsive.'**
  String get requestTimeout;

  /// Response timeout error message
  ///
  /// In en, this message translates to:
  /// **'⏱️ Response took too long. Try breaking down your question into smaller parts or use a faster model.'**
  String get responseTimeout;

  /// LM Studio not running error
  ///
  /// In en, this message translates to:
  /// **'⚠️ LM Studio server is not running on localhost:1234'**
  String get lmStudioNotRunning;

  /// Connection failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to LM Studio'**
  String get failedToConnect;

  /// Wishlist screen title
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get myWishlist;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Empty wishlist message
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get yourWishlistIsEmpty;

  /// Empty wishlist description
  ///
  /// In en, this message translates to:
  /// **'Add anime to watch later'**
  String get addAnimeToWatchLater;

  /// Explore anime button text
  ///
  /// In en, this message translates to:
  /// **'Explore Anime'**
  String get exploreAnime;

  /// Episodes count text
  ///
  /// In en, this message translates to:
  /// **'{count} episodes'**
  String episodesCount(int count);

  /// Snackbar message when item removed from wishlist
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get removedFromWishlist;

  /// Loading profile message
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Create profile header text
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// Edit profile header text
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Sign in to save profile warning
  ///
  /// In en, this message translates to:
  /// **'You can fill out your profile information, but you\'ll need to sign in to save it.'**
  String get signInToSave;

  /// Sign in required snackbar message
  ///
  /// In en, this message translates to:
  /// **'Please sign in to save your profile'**
  String get pleaseSignInToSave;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Email address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmail;

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get emailRequired;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// First name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// First name required validation message
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Last name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// Last name required validation message
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// Address information section title
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get addressInformation;

  /// Street address field label
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// Street address required validation message
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get streetRequired;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// State required validation message
  ///
  /// In en, this message translates to:
  /// **'State is required'**
  String get stateRequired;

  /// ZIP code field label
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// ZIP code required validation message
  ///
  /// In en, this message translates to:
  /// **'ZIP code is required'**
  String get zipRequired;

  /// ZIP code minimum length validation message
  ///
  /// In en, this message translates to:
  /// **'ZIP code must be at least 5 characters'**
  String get zipMinLength;

  /// Contact information section title
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'(123) 456-7890'**
  String get phoneHint;

  /// Phone number required validation message
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Valid phone validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhone;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Welcome message in profile display
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get profileWelcomeBack;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profilePersonalInformation;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get profileEmailAddress;

  /// Street address field label
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get profileStreetAddress;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get profileState;

  /// ZIP code field label
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get profileZipCode;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// Text shown when a field value is empty
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get profileNotProvided;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
