import 'package:tpval/shared/models/post.dart';
import 'package:dio/dio.dart';

import 'remote_posts_data_source.dart';

class ApiPostsDataSource extends RemotePostsDataSource {
  @override
  Future<List<Post>> getAllPosts() async {
    final response = await Dio().get('https://dummyjson.com/post');
    final jsonList = response.data['posts'] as List;
    return jsonList.map((jsonElement) => Post.fromJson(jsonElement)).toList();
  }

  @override
  Future<Post> createPost(Post postToAdd) async {
    final response = await Dio().post('https://dummyjson.com/post', data: postToAdd.toJson());
    return Post.fromJson(response.data);
  }

  @override
  Future<Post> updatePost(Post newPost) async {
    final response = await Dio().put('https://dummyjson.com/post/${newPost.id}', data: newPost.toJson());
    return Post.fromJson(response.data);
  }

  @override
  Future<void> deletePost(Post postToDelete) async {
    await Dio().delete('https://dummyjson.com/post/${postToDelete.id}');
  }
}
