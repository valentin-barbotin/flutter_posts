import 'package:tpval/shared/models/post.dart';

import 'remote_posts_data_source.dart';

class FakeRemotePostDataSource extends RemotePostsDataSource {
  @override
  Future<List<Post>> getAllPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(2, (index) {
      return Post(
        id: index,
        title: 'Cached post $index',
        body: 'This is the body of the post $index',
      );
    });
  }

  @override
  Future<Post> createPost(Post postToAdd) async {
    await Future.delayed(const Duration(seconds: 1));
    return Post(
      id: 3,
      title: postToAdd.title,
      body: postToAdd.body,
    );
  }

  @override
  Future<Post> updatePost(Post newPost) async {
    await Future.delayed(const Duration(seconds: 1));
    return newPost;
  }

  @override
  Future<void> deletePost(Post postToDelete) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
