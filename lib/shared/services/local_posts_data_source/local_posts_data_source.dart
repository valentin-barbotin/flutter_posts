import '../../models/post.dart';
import '../remote_posts_data_source/remote_posts_data_source.dart';

abstract class LocalPostsDataSource extends RemotePostsDataSource {
  Future<void> save(List<Post> posts);
}
