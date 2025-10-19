import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_search_entity.dart';
import '../repositories/social_chat_repository.dart';

class SearchUsersUseCase implements UseCase<List<UserSearchEntity>, SearchUsersParams> {
  final SocialChatRepository repository;

  SearchUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserSearchEntity>>> call(SearchUsersParams params) async {
    return await repository.searchUsers(params.query);
  }
}

class SearchUsersParams extends Equatable {
  final String query;

  const SearchUsersParams({required this.query});

  @override
  List<Object> get props => [query];
}
