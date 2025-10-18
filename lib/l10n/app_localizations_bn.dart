// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'অ্যানিমেহাব';

  @override
  String get welcomeTitle => 'অ্যানিমেহাব এ স্বাগতম';

  @override
  String get welcomeSubtitle => 'আপনার অ্যানিমে আবিষ্কারের প্ল্যাটফর্ম';

  @override
  String get trendingNow => 'এখন ট্রেন্ডিং';

  @override
  String get popular => 'জনপ্রিয়';

  @override
  String get home => 'হোম';

  @override
  String get search => 'খুঁজুন';

  @override
  String get watchlist => 'ওয়াচলিস্ট';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get lightMode => 'লাইট মোড';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get information => 'তথ্য';

  @override
  String get synopsis => 'সংক্ষিপ্ত বিবরণ';

  @override
  String get genres => 'ধরন';

  @override
  String get type => 'প্রকার';

  @override
  String get episodes => 'পর্ব';

  @override
  String get status => 'অবস্থা';

  @override
  String get aired => 'প্রচারিত';

  @override
  String get source => 'উৎস';

  @override
  String get duration => 'সময়কাল';

  @override
  String get score => 'স্কোর';

  @override
  String get rank => 'র‍্যাঙ্ক';

  @override
  String get popularity => 'জনপ্রিয়তা';

  @override
  String get members => 'সদস্য';

  @override
  String get favorites => 'প্রিয়';

  @override
  String get studios => 'স্টুডিও';

  @override
  String get trailer => 'ট্রেইলার';

  @override
  String get relations => 'সম্পর্ক';

  @override
  String get themes => 'থিম';

  @override
  String get streaming => 'স্ট্রিমিং';

  @override
  String get external => 'বাহ্যিক লিংক';

  @override
  String get openings => 'ওপেনিং থিম';

  @override
  String get endings => 'এন্ডিং থিম';

  @override
  String get unknown => 'অজানা';

  @override
  String get noSynopsisAvailable => 'কোন সংক্ষিপ্ত বিবরণ উপলব্ধ নেই';

  @override
  String get error => 'ত্রুটি';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get watchTrailer => 'ট্রেইলার দেখুন';

  @override
  String get language => 'ভাষা';

  @override
  String rating(String rating) {
    return 'রেটিং: $rating';
  }

  @override
  String animeTitle(int number) {
    return 'অ্যানিমে শিরোনাম $number';
  }

  @override
  String get animeAssistant => 'অ্যানিমে সহায়ক';

  @override
  String get askAboutAnime => 'অ্যানিমে সম্পর্কে জিজ্ঞাসা করুন...';

  @override
  String get lmStudioNotConnected => 'LM Studio সংযুক্ত নয়';

  @override
  String get askMeAnything => 'অ্যানিমে সম্পর্কে যেকোনো কিছু জিজ্ঞাসা করুন!';

  @override
  String get chatbotDescription =>
      'আমি সুপারিশ, চরিত্রের তথ্য\nএবং আরও অনেক কিছুতে সাহায্য করতে পারি!';

  @override
  String get thinking => 'ভাবছি...';

  @override
  String get similarAnime => 'অনুরূপ অ্যানিমে:';

  @override
  String get failedToGetResponse => 'প্রতিক্রিয়া পেতে ব্যর্থ।';

  @override
  String get noModelLoaded =>
      '🤖 LM Studio তে কোন মডেল লোড নেই। অনুগ্রহ করে প্রথমে একটি মডেল লোড করুন!';

  @override
  String get corsError =>
      '🌐 CORS ত্রুটি শনাক্ত করা হয়েছে। অনুগ্রহ করে চালান: flutter run -d chrome --web-browser-flag \"--disable-web-security\"';

  @override
  String get connectionRefused =>
      '🔌 LM Studio এর সাথে সংযোগ করতে পারছি না। নিশ্চিত করুন এটি localhost:1234 এ চলছে';

  @override
  String get serverRunningNoModel =>
      '⚠️ LM Studio সার্ভার চলছে কিন্তু কোন মডেল লোড নেই। অনুগ্রহ করে একটি মডেল লোড করুন!';

  @override
  String get requestTimeout =>
      '⏱️ অনুরোধের সময় শেষ। মডেল একটি জটিল প্রতিক্রিয়া প্রক্রিয়া করছে হতে পারে। একটি সহজ প্রশ্ন চেষ্টা করুন বা আপনার মডেল প্রতিক্রিয়াশীল কিনা পরীক্ষা করুন।';

  @override
  String get responseTimeout =>
      '⏱️ প্রতিক্রিয়া খুব বেশি সময় নিয়েছে। আপনার প্রশ্নকে ছোট অংশে ভাগ করে চেষ্টা করুন বা একটি দ্রুত মডেল ব্যবহার করুন।';

  @override
  String get lmStudioNotRunning =>
      '⚠️ LM Studio সার্ভার localhost:1234 এ চলছে না';

  @override
  String get failedToConnect => 'LM Studio এর সাথে সংযোগ করতে ব্যর্থ';

  @override
  String get myWishlist => 'আমার ইচ্ছালিস্ট';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get yourWishlistIsEmpty => 'আপনার ইচ্ছালিস্ট খালি';

  @override
  String get addAnimeToWatchLater => 'পরে দেখার জন্য অ্যানিমে যোগ করুন';

  @override
  String get exploreAnime => 'অ্যানিমে অন্বেষণ করুন';

  @override
  String episodesCount(int count) {
    return '$count পর্ব';
  }

  @override
  String get removedFromWishlist => 'ইচ্ছালিস্ট থেকে সরানো হয়েছে';

  @override
  String get loadingProfile => 'প্রোফাইল লোড হচ্ছে...';

  @override
  String get retryButton => 'আবার চেষ্টা করুন';

  @override
  String get createProfile => 'প্রোফাইল তৈরি করুন';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get signInToSave =>
      'আপনি আপনার প্রোফাইল তথ্য পূরণ করতে পারেন, তবে এটি সংরক্ষণ করতে আপনাকে সাইন ইন করতে হবে।';

  @override
  String get pleaseSignInToSave =>
      'আপনার প্রোফাইল সংরক্ষণ করতে অনুগ্রহ করে সাইন ইন করুন';

  @override
  String get personalInformation => 'ব্যক্তিগত তথ্য';

  @override
  String get emailAddress => 'ইমেইল ঠিকানা';

  @override
  String get enterYourEmail => 'আপনার ইমেইল ঠিকানা লিখুন';

  @override
  String get emailRequired => 'ইমেইল ঠিকানা প্রয়োজন';

  @override
  String get enterValidEmail => 'অনুগ্রহ করে একটি বৈধ ইমেইল ঠিকানা লিখুন';

  @override
  String get firstName => 'প্রথম নাম';

  @override
  String get enterFirstName => 'আপনার প্রথম নাম লিখুন';

  @override
  String get firstNameRequired => 'প্রথম নাম প্রয়োজন';

  @override
  String get lastName => 'শেষ নাম';

  @override
  String get enterLastName => 'আপনার শেষ নাম লিখুন';

  @override
  String get lastNameRequired => 'শেষ নাম প্রয়োজন';

  @override
  String get addressInformation => 'ঠিকানার তথ্য';

  @override
  String get streetAddress => 'রাস্তার ঠিকানা';

  @override
  String get streetRequired => 'রাস্তার ঠিকানা প্রয়োজন';

  @override
  String get state => 'রাজ্য/প্রদেশ';

  @override
  String get stateRequired => 'রাজ্য/প্রদেশ প্রয়োজন';

  @override
  String get zipCode => 'পোস্টাল কোড';

  @override
  String get zipRequired => 'পোস্টাল কোড প্রয়োজন';

  @override
  String get zipMinLength => 'পোস্টাল কোড কমপক্ষে ৫ অক্ষরের হতে হবে';

  @override
  String get contactInformation => 'যোগাযোগের তথ্য';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get phoneHint => '(০১৭) ১২৩-৪৫৬৭';

  @override
  String get phoneRequired => 'ফোন নম্বর প্রয়োজন';

  @override
  String get enterValidPhone => 'অনুগ্রহ করে একটি বৈধ ফোন নম্বর লিখুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get saveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get profileWelcomeBack => 'স্বাগতম!';

  @override
  String get profilePersonalInformation => 'ব্যক্তিগত তথ্য';

  @override
  String get profileFullName => 'পূর্ণ নাম';

  @override
  String get profileEmailAddress => 'ইমেইল ঠিকানা';

  @override
  String get profileStreetAddress => 'রাস্তার ঠিকানা';

  @override
  String get profileState => 'রাজ্য/প্রদেশ';

  @override
  String get profileZipCode => 'জিপ কোড';

  @override
  String get profilePhone => 'ফোন';

  @override
  String get profileNotProvided => 'প্রদান করা হয়নি';
}
