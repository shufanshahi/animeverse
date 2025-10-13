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
}
