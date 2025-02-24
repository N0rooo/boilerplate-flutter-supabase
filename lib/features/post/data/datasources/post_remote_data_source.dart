import 'dart:io';

import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/core/error/exceptions.dart';
import 'package:boilerplate_flutter/features/post/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PostRemoteDataSource {
  Future<PostModel> uploadPost(PostModel post);
  Future<String> uploadPostImage({
    required File image,
    required PostModel post,
  });
  Future<List<PostModel>> getAllPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabaseClient;
  PostRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<PostModel> uploadPost(PostModel post) async {
    try {
      final postData = await supabaseClient
          .from(SupabaseTables.blogs)
          .insert(post.toJson())
          .select();
      return PostModel.fromJson(postData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadPostImage(
      {required File image, required PostModel post}) async {
    try {
      await supabaseClient.storage.from("blog_images").upload(post.id, image);
      return supabaseClient.storage.from("blog_images").getPublicUrl(post.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final posts = await supabaseClient
          .from(SupabaseTables.blogs)
          .select('*, profiles(name)');
      return posts
          .map(
            (post) => PostModel.fromJson(post)
                .copyWith(userName: post['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
