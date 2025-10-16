import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/usecases.dart';

// Use case providers
final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  try {
    return GetIt.instance<SendMessageUseCase>();
  } catch (e) {
    throw StateError('SendMessageUseCase not initialized. Did you call init()?');
  }
});

final checkConnectionUseCaseProvider = Provider<CheckConnectionUseCase>((ref) {
  try {
    return GetIt.instance<CheckConnectionUseCase>();
  } catch (e) {
    throw StateError('CheckConnectionUseCase not initialized. Did you call init()?');
  }
});

final searchAnimeUseCaseProvider = Provider<SearchAnimeUseCase>((ref) {
  try {
    return GetIt.instance<SearchAnimeUseCase>();
  } catch (e) {
    throw StateError('SearchAnimeUseCase not initialized. Did you call init()?');
  }
});

final getTopAnimeUseCaseProvider = Provider<GetTopAnimeUseCase>((ref) {
  try {
    return GetIt.instance<GetTopAnimeUseCase>();
  } catch (e) {
    throw StateError('GetTopAnimeUseCase not initialized. Did you call init()?');
  }
});

final getRecommendationsUseCaseProvider = Provider<GetRecommendationsUseCase>((ref) {
  try {
    return GetIt.instance<GetRecommendationsUseCase>();
  } catch (e) {
    throw StateError('GetRecommendationsUseCase not initialized. Did you call init()?');
  }
});