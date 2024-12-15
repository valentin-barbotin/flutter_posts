import '../../models/post.dart';

abstract class RemotePostsDataSource {
  Future<List<Post>> getAllPosts();
  Future<Post> createPost(Post postToAdd);
  Future<Post> updatePost(Post newPost);
  Future<void> deletePost(Post postToDelete);
}