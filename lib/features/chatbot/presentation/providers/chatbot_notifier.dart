import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../state/state.dart';
import 'chatbot_providers.dart';

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final SendMessageUseCase _sendMessageUseCase;
  final CheckConnectionUseCase _checkConnectionUseCase;
  final SearchAnimeUseCase _searchAnimeUseCase;
  final GetTopAnimeUseCase _getTopAnimeUseCase;
  final Uuid _uuid = const Uuid();

  ChatbotNotifier({
    required SendMessageUseCase sendMessageUseCase,
    required CheckConnectionUseCase checkConnectionUseCase,
    required SearchAnimeUseCase searchAnimeUseCase,
    required GetTopAnimeUseCase getTopAnimeUseCase,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _checkConnectionUseCase = checkConnectionUseCase,
        _searchAnimeUseCase = searchAnimeUseCase,
        _getTopAnimeUseCase = getTopAnimeUseCase,
        super(const ChatbotState()) {
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    final result = await _checkConnectionUseCase(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isConnected: false,
        error: 'Failed to connect to LM Studio',
      ),
      (isConnected) => state = state.copyWith(
        isConnected: isConnected,
        error: isConnected ? null : '⚠️ LM Studio server is not running on localhost:1234',
      ),
    );
  }

  void toggleChat() {
    state = state.copyWith(isChatOpen: !state.isChatOpen);
  }

  void closeChat() {
    state = state.copyWith(isChatOpen: false);
  }

  void openChat() {
    state = state.copyWith(isChatOpen: true);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.isLoading) return;

    // Add user message
    final userMessage = MessageEntity(
      id: _uuid.v4(),
      content: content.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    // Add loading message for assistant
    final loadingMessage = MessageEntity(
      id: _uuid.v4(),
      content: 'Processing your request... This may take up to 2 minutes for complex questions.',
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    state = state.copyWith(
      messages: [...state.messages, loadingMessage],
    );

    // Send message to AI
    final result = await _sendMessageUseCase(
      SendMessageParams(
        message: content.trim(),
        conversationHistory: state.messages
            .where((msg) => !msg.isLoading)
            .toList(),
      ),
    );

    result.fold(
      (failure) {
        // Remove loading message and show error
        final messagesWithoutLoading = state.messages
            .where((msg) => !msg.isLoading)
            .toList();
        
        String errorMessage = 'Failed to get response.';
        if (failure is ServerFailure) {
          if (failure.message.contains('No models loaded')) {
            errorMessage = '🤖 No model loaded in LM Studio. Please load a model first!';
          } else if (failure.message.contains('CORS')) {
            errorMessage = '🌐 CORS error detected. Please run: flutter run -d chrome --web-browser-flag "--disable-web-security"';
          } else if (failure.message.contains('Connection refused') || failure.message.contains('SocketException')) {
            errorMessage = '🔌 Cannot connect to LM Studio. Make sure it\'s running on localhost:1234';
          } else if (failure.message.contains('404')) {
            errorMessage = '⚠️ LM Studio server is running but no model is loaded. Please load a model!';
          } else if (failure.message.contains('timed out')) {
            errorMessage = '⏱️ Request timed out. The model might be processing a complex response. Try a simpler question or check if your model is responsive.';
          } else if (failure.message.contains('TimeoutException')) {
            errorMessage = '⏱️ Response took too long. Try breaking down your question into smaller parts or use a faster model.';
          } else {
            errorMessage = '❌ ${failure.message}';
          }
        }
        
        state = state.copyWith(
          messages: messagesWithoutLoading,
          isLoading: false,
          error: errorMessage,
        );
      },
      (response) async {
        // Replace loading message with actual response
        final messagesWithoutLoading = state.messages
            .where((msg) => !msg.isLoading)
            .toList();

        // Extract anime titles from the AI response and fetch suggestions
        List<AnimeSuggestionEntity>? animeSuggestions;
        if (_isRecommendationRequest(content.trim()) || _containsAnimeTitles(response)) {
          animeSuggestions = await _extractAndFetchAnimeFromResponse(response);
          if (animeSuggestions.isEmpty) {
            // Fallback to general search if no specific titles were found
            animeSuggestions = await _fetchAnimeSuggestions(content.trim());
          }
        }

        final assistantMessage = MessageEntity(
          id: _uuid.v4(),
          content: response,
          type: MessageType.assistant,
          timestamp: DateTime.now(),
          animeSuggestions: animeSuggestions,
        );

        state = state.copyWith(
          messages: [...messagesWithoutLoading, assistantMessage],
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> checkConnection() async {
    final result = await _checkConnectionUseCase(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isConnected: false,
        error: 'Failed to connect to LM Studio',
      ),
      (isConnected) => state = state.copyWith(
        isConnected: isConnected,
        error: isConnected ? null : '⚠️ LM Studio server is not running on localhost:1234',
      ),
    );
  }

  void clearMessages() {
    state = state.copyWith(messages: []);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  bool _isRecommendationRequest(String message) {
    final lowercaseMessage = message.toLowerCase();
    final recommendationKeywords = [
      'recommend',
      'suggestion',
      'suggest',
      'what should i watch',
      'anime like',
      'similar to',
      'top anime',
      'best anime',
      'good anime',
      'popular anime',
    ];
    
    return recommendationKeywords.any((keyword) => lowercaseMessage.contains(keyword));
  }

  Future<List<AnimeSuggestionEntity>> _fetchAnimeSuggestions(String message) async {
    try {
      final lowercaseMessage = message.toLowerCase();
      
      // Try to extract anime titles or genres from the message
      if (lowercaseMessage.contains('top') || lowercaseMessage.contains('popular') || lowercaseMessage.contains('best')) {
        // Get top anime
        final result = await _getTopAnimeUseCase(GetTopAnimeParams(limit: 6));
        return result.fold(
          (failure) => [],
          (suggestions) => suggestions,
        );
      } else {
        // Search for anime based on the message content
        String searchQuery = message;
        
        // Extract potential anime title from phrases like "anime like Naruto"
        final likePattern = RegExp(r'(?:anime )?(?:like|similar to) ([^.!?]+)', caseSensitive: false);
        final match = likePattern.firstMatch(message);
        if (match != null) {
          searchQuery = match.group(1)?.trim() ?? message;
        }
        
        final result = await _searchAnimeUseCase(SearchAnimeParams(query: searchQuery, limit: 6));
        return result.fold(
          (failure) => [],
          (suggestions) => suggestions,
        );
      }
    } catch (e) {
      print('Error fetching anime suggestions: $e');
      return [];
    }
  }

  bool _containsAnimeTitles(String response) {
    // Look for patterns that suggest anime titles are mentioned
    final patterns = [
      RegExp(r'\*\*([^*]+)\*\*.*\(20\d{2}', caseSensitive: false), // **Title** (year)
      RegExp(r'\d+\.\s+\*\*([^*]+)\*\*', caseSensitive: false), // 1. **Title**
      RegExp(r'(Attack on Titan|Demon Slayer|Your Name|Spirited Away|Fruits Basket)', caseSensitive: false), // Common anime titles
    ];
    
    return patterns.any((pattern) => pattern.hasMatch(response));
  }

  Future<List<AnimeSuggestionEntity>> _extractAndFetchAnimeFromResponse(String response) async {
    try {
      final List<AnimeSuggestionEntity> suggestions = [];
      final Set<String> processedTitles = {}; // Avoid duplicates
      
      // Comprehensive patterns to extract anime titles
      final patterns = [
        // Numbered lists with years: "1. **Title** (2020)"
        RegExp(r'\d+\.\s*\*\*([^*]{3,40}?)\*\*\s*\(20\d{2}\)', caseSensitive: false),
        // Bold titles with years: "**Title** (2020)"
        RegExp(r'\*\*([^*]{3,40}?)\*\*\s*\(20\d{2}\)', caseSensitive: false),
        // Numbered lists without years: "1. **Title**"
        RegExp(r'\d+\.\s*\*\*([^*]{3,40}?)\*\*(?!\s*[-–—(])', caseSensitive: false),
        // Simple bold titles: "**Title**" (not followed by description indicators)
        RegExp(r'\*\*([^*]{3,40}?)\*\*(?!\s*[-–—:(\*])', caseSensitive: false),
        // Title with colon format: "Title:" or "Title -"
        RegExp(r'^([A-Z][^:\n-]{2,39}?)(?:\s*[-:]|\s*\(20\d{2}\))', caseSensitive: false, multiLine: true),
      ];
      
      // Expanded list of well-known anime titles
      final knownAnimeTitles = [
        'Attack on Titan', 'Demon Slayer', 'Your Name', 'Spirited Away', 'Fruits Basket',
        'Steins;Gate', 'Ghost in the Shell', 'K-On!', 'My Hero Academia', 'One Piece',
        'Naruto', 'Dragon Ball', 'Death Note', 'Fullmetal Alchemist', 'Tokyo Ghoul',
        'Chainsaw Man', 'Jujutsu Kaisen', 'Spy x Family', 'The Promised Neverland',
        'School Days', 'Cowboy Bebop', 'One Punch Man', 'Hunter x Hunter', 'Bleach',
        'Mob Psycho 100', 'Violet Evergarden', 'Princess Mononoke', 'Totoro', 'Akira',
        'Evangelion', 'Code Geass', 'JoJo', 'Overlord', 'Re:Zero', 'Konosuba',
        'Dr. Stone', 'Fire Force', 'Black Clover', 'Fairy Tail', 'Seven Deadly Sins',
        'Toradora', 'Clannad', 'Angel Beats', 'Your Lie in April', 'A Silent Voice',
        'Weathering with You', 'Perfect Blue', 'Castle in the Sky', 'Kiki\'s Delivery Service',
        'Howl\'s Moving Castle', 'The Wind Rises', 'Ponyo', 'Grave of the Fireflies'
      ];
      
      // First, check for known anime titles in the response
      for (final animeTitle in knownAnimeTitles) {
        if (response.toLowerCase().contains(animeTitle.toLowerCase()) && 
            !processedTitles.contains(animeTitle.toLowerCase())) {
          processedTitles.add(animeTitle.toLowerCase());
          
          // Search for this anime with delay to respect rate limits
          await Future.delayed(const Duration(milliseconds: 300)); // Reduced delay
          final result = await _searchAnimeUseCase(SearchAnimeParams(query: animeTitle, limit: 1));
          final animeList = result.fold(
            (failure) => <AnimeSuggestionEntity>[],
            (animeList) => animeList,
          );
          
          if (animeList.isNotEmpty) {
            suggestions.add(animeList.first);
          }
          
          // Limit to avoid too many API calls
          if (suggestions.length >= 6) break; // Allow more suggestions
        }
      }
      
      // Then use patterns for titles we might have missed
      if (suggestions.length < 6) {
        for (final pattern in patterns) {
          final matches = pattern.allMatches(response);
          
          for (final match in matches) {
            final title = match.group(1)?.trim();
            if (title != null && 
                title.length >= 3 && 
                title.length <= 40 && // Reasonable title length
                !title.contains('–') && // Avoid descriptions with dashes
                !title.contains('Genre:') && // Avoid genre descriptions
                !title.contains('Why?') && // Avoid explanation text
                !processedTitles.contains(title.toLowerCase())) {
              
              processedTitles.add(title.toLowerCase());
              
              // Search for this anime with delay to respect rate limits
              await Future.delayed(const Duration(milliseconds: 300));
              final result = await _searchAnimeUseCase(SearchAnimeParams(query: title, limit: 1));
              final animeList = result.fold(
                (failure) => <AnimeSuggestionEntity>[],
                (animeList) => animeList,
              );
              
              if (animeList.isNotEmpty) {
                suggestions.add(animeList.first);
              }
              
              // Limit to avoid too many API calls
              if (suggestions.length >= 6) break;
            }
          }
          
          if (suggestions.length >= 6) break;
        }
      }
      
      print('Extracted ${suggestions.length} anime suggestions from AI response');
      return suggestions;
    } catch (e) {
      print('Error extracting anime from response: $e');
      return [];
    }
  }
}

// Global provider for chatbot state
final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier(
    sendMessageUseCase: ref.watch(sendMessageUseCaseProvider),
    checkConnectionUseCase: ref.watch(checkConnectionUseCaseProvider),
    searchAnimeUseCase: ref.watch(searchAnimeUseCaseProvider),
    getTopAnimeUseCase: ref.watch(getTopAnimeUseCaseProvider),
  );
});