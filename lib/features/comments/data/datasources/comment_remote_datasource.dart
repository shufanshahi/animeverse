import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/comment_entity.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentEntity>> getCommentsByAnimeId(int animeId);
  Future<CommentEntity> createComment(CommentEntity comment);
  Future<CommentEntity> updateComment(CommentEntity comment);
  Future<void> deleteComment(String commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final SupabaseClient supabaseClient;

  CommentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<CommentEntity>> getCommentsByAnimeId(int animeId) async {
    try {
      print('🔍 Fetching comments for anime ID: $animeId');
      
      final response = await supabaseClient
          .from('comments')
          .select()
          .eq('anime_id', animeId)
          .order('created_at', ascending: false);

      print('📦 Comments response: $response');

      if (response == null || response.isEmpty) {
        print('📭 No comments found for anime ID: $animeId');
        return [];
      }

      final comments = (response as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();

      print('✅ Fetched ${comments.length} comments');
      return comments;
    } catch (e) {
      print('❌ Error fetching comments: $e');
      throw Exception('Failed to fetch comments: $e');
    }
  }

  @override
  Future<CommentEntity> createComment(CommentEntity comment) async {
    try {
      print('📝 Creating comment for anime ID: ${comment.animeId}');
      
      final commentModel = CommentModel.fromEntity(comment);
      final commentData = commentModel.toJson();
      
      // Generate UUID for the comment
      commentData['id'] = const Uuid().v4();
      commentData['created_at'] = DateTime.now().toIso8601String();
      commentData['updated_at'] = DateTime.now().toIso8601String();

      final response = await supabaseClient
          .from('comments')
          .insert(commentData)
          .select()
          .single();

      print('✅ Comment created successfully');
      return CommentModel.fromJson(response);
    } catch (e) {
      print('❌ Error creating comment: $e');
      throw Exception('Failed to create comment: $e');
    }
  }

  @override
  Future<CommentEntity> updateComment(CommentEntity comment) async {
    try {
      print('✏️ Updating comment ID: ${comment.id}');
      
      final commentModel = CommentModel.fromEntity(comment);
      final commentData = commentModel.toJson();
      
      commentData['updated_at'] = DateTime.now().toIso8601String();
      commentData.remove('created_at'); // Don't update created_at

      final response = await supabaseClient
          .from('comments')
          .update(commentData)
          .eq('id', comment.id)
          .select()
          .single();

      print('✅ Comment updated successfully');
      return CommentModel.fromJson(response);
    } catch (e) {
      print('❌ Error updating comment: $e');
      throw Exception('Failed to update comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      print('🗑️ Deleting comment ID: $commentId');
      
      await supabaseClient
          .from('comments')
          .delete()
          .eq('id', commentId);

      print('✅ Comment deleted successfully');
    } catch (e) {
      print('❌ Error deleting comment: $e');
      throw Exception('Failed to delete comment: $e');
    }
  }
}
