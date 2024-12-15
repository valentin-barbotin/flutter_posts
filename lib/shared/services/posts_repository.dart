import '../models/post.dart';
import 'local_posts_data_source/local_posts_data_source.dart';
import 'remote_posts_data_source/remote_posts_data_source.dart';

class PostsRepository {
  final RemotePostsDataSource remotePostsDataSource;
  final LocalPostsDataSource localDataSource;

  const PostsRepository({
    required this.remotePostsDataSource,
    required this.localDataSource,
  });

  Future<List<Post>> getAllPosts() async {
    try {
      final posts = await remotePostsDataSource.getAllPosts();
      await localDataSource.save(posts);
      return posts;
    } catch (error) {
      return localDataSource.getAllPosts();
    }
  }

  Future<Post> createPost(Post postToAdd) async {
    final post = await remotePostsDataSource.createPost(postToAdd);
    await localDataSource.save([...await localDataSource.getAllPosts(), post]);
    return post;
  }

  Future<Post> updatePost(Post newPost) async {
    final post = await remotePostsDataSource.updatePost(newPost);
    final posts = await localDataSource.getAllPosts();
    final updatedPosts = posts.map((post) {
      if (post.id == newPost.id) {
        return newPost;
      }
      return post;
    }).toList();
    await localDataSource.save(updatedPosts);
    return post;
  }

  Future<void> deletePost(Post postToDelete) async {
    await remotePostsDataSource.deletePost(postToDelete);
    final posts = await localDataSource.getAllPosts();
    final updatedPosts = posts.where((post) => post.id != postToDelete.id).toList();
    await localDataSource.save(updatedPosts);
  }
}
