// lib/core/localization/app_localizations.dart

class AppLocalizations {
  static Map<String, Map<String, String>> translations = {
    'en': {
      'app_name': 'Anime Verse',
      'app_title': 'Anime Verse',
      'language': 'Language',
      'welcome_back': 'Welcome Back!',
      'create_account': 'Create Account',
      'email': 'Email',
      'password': 'Password',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'login': 'Login',
      'signup': 'Sign Up',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'reset_password': 'Reset Password',
      'send_reset_link': 'Send Reset Link',
      'back_to_login': 'Back to Login',
      'reset_instructions': 'Enter your email address and we\'ll send you a link to reset your password.',
      'reset_email_sent': 'Password reset email sent! Check your inbox.',
      'login_success': 'Login successful!',
      'signup_success': 'Account created successfully!',
      'error': 'Error',
      'loading': 'Loading...',
      'or': 'OR',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'enter_name': 'Enter your full name',
      'sign_in_to_continue': 'Sign in to discover amazing anime!',
      'join_us': 'Join us to get personalized anime suggestions',
      'featured_anime': 'Featured Anime',
      'currently_airing': 'Currently Airing',
      'seasonal_anime': 'Seasonal Anime',
      'top_anime': 'Top Anime',
      'browse_by_genre': 'Browse by Genre',
      'anime': 'Anime',
      'information': 'Information',
      'genres': 'Genres',
      'synopsis': 'Synopsis',
      // Genre names
      'action': 'Action',
      'adventure': 'Adventure',
      'comedy': 'Comedy',
      'drama': 'Drama',
      'fantasy': 'Fantasy',
      'romance': 'Romance',
      'sci_fi': 'Sci-Fi',
      'thriller': 'Thriller',
      'horror': 'Horror',
      'mystery': 'Mystery',
      'slice_of_life': 'Slice of Life',
      'sports': 'Sports',
      'supernatural': 'Supernatural',
      'military': 'Military',
      'school': 'School',
    },
    'bn': {
      'app_name': 'এনিমে ভার্স',
      'app_title': 'এনিমে ভার্স',
      'language': 'ভাষা',
      'welcome_back': 'স্বাগতম!',
      'create_account': 'অ্যাকাউন্ট তৈরি করুন',
      'email': 'ইমেইল',
      'password': 'পাসওয়ার্ড',
      'full_name': 'পূর্ণ নাম',
      'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
      'login': 'লগইন',
      'signup': 'সাইন আপ',
      'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'dont_have_account': 'অ্যাকাউন্ট নেই?',
      'already_have_account': 'ইতিমধ্যে অ্যাকাউন্ট আছে?',
      'reset_password': 'পাসওয়ার্ড রিসেট করুন',
      'send_reset_link': 'রিসেট লিঙ্ক পাঠান',
      'back_to_login': 'লগইনে ফিরে যান',
      'reset_instructions': 'আপনার ইমেইল ঠিকানা লিখুন এবং আমরা আপনাকে পাসওয়ার্ড রিসেট করার জন্য একটি লিঙ্ক পাঠাব।',
      'reset_email_sent': 'পাসওয়ার্ড রিসেট ইমেইল পাঠানো হয়েছে! আপনার ইনবক্স চেক করুন।',
      'login_success': 'লগইন সফল হয়েছে!',
      'signup_success': 'অ্যাকাউন্ট সফলভাবে তৈরি হয়েছে!',
      'error': 'ত্রুটি',
      'loading': 'লোড হচ্ছে...',
      'or': 'অথবা',
      'enter_email': 'আপনার ইমেইল লিখুন',
      'enter_password': 'আপনার পাসওয়ার্ড লিখুন',
      'enter_name': 'আপনার পূর্ণ নাম লিখুন',
      'sign_in_to_continue': 'অসাধারণ এনিমে আবিষ্কার করতে সাইন ইন করুন!',
      'join_us': 'ব্যক্তিগত এনিমে সাজেশন পেতে আমাদের সাথে যোগ দিন',
      'featured_anime': 'ফিচার্ড এনিমে',
      'currently_airing': 'বর্তমানে প্রচারিত',
      'seasonal_anime': 'সিজনাল এনিমে',
      'top_anime': 'শীর্ষ এনিমে',
      'browse_by_genre': 'ধরন অনুসারে ব্রাউজ করুন',
      'anime': 'এনিমে',
      'information': 'তথ্য',
      'genres': 'ধরন',
      'synopsis': 'সংক্ষিপ্ত বিবরণ',
      // Genre names in Bengali
      'action': 'অ্যাকশন',
      'adventure': 'অ্যাডভেঞ্চার',
      'comedy': 'কমেডি',
      'drama': 'ড্রামা',
      'fantasy': 'ফ্যান্টাসি',
      'romance': 'রোম্যান্স',
      'sci_fi': 'সাই-ফাই',
      'thriller': 'থ্রিলার',
      'horror': 'হরর',
      'mystery': 'রহস্য',
      'slice_of_life': 'স্লাইস অফ লাইফ',
      'sports': 'ক্রীড়া',
      'supernatural': 'অতিপ্রাকৃত',
      'military': 'মিলিটারি',
      'school': 'স্কুল',
    },
  };

  static String translate(String key, String locale) {
    return translations[locale]?[key] ?? 
           translations['en']?[key] ?? 
           key; // Return the key itself if translation not found
  }

  // Helper method to convert genre name to translation key
  static String getGenreKey(String genreName) {
    return genreName.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
  }

  // Helper method to translate genre name
  static String translateGenre(String genreName, String locale) {
    final key = getGenreKey(genreName);
    return translate(key, locale);
  }
}