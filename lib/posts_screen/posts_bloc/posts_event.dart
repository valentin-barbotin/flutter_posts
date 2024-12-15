part of 'posts_bloc.dart';

@immutable
sealed class PostsEvent {}

class GetAllPosts extends PostsEvent {}
class CreatePost extends PostsEvent {
  final Post post;

  CreatePost(this.post);
}

class DeletePost extends PostsEvent {
  final Post post;

  DeletePost(this.post);
}

class ClearPosts extends PostsEvent {}
class UpdatePost extends PostsEvent {
  final Post post;

  UpdatePost(this.post);
}

class GetPost extends PostsEvent {
  final int id;

  GetPost(this.id);
}
