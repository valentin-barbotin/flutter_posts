import 'package:tpval/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:tpval/shared/models/post.dart';

import 'local_posts_data_source.dart';

class FakeLocalPostsDataSource extends LocalPostsDataSource {
  @override
  Future<List<Post>> getAllPosts() async {
    return const [
      Post(
        id: 0,
        title: 'Hello world',
        body: 'This is the content'
      ),
      Post(
        id: 1,
        title: 'Okay bro',
        body: 'This is the content 2'
      ),
    ];
  }

   @override
  Future<void> save(List<Post> posts) async {
    return;
  }

  @override
  Future<Post> createPost(Post postToAdd) {
    throw UnimplementedError();
  }

  @override
  Future<Post> updatePost(Post newPost) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(Post postToDelete) {
    throw UnimplementedError();
  }
}
