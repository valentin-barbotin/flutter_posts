import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../shared/app_exception.dart';
import '../../shared/models/post.dart';
import '../../shared/services/posts_repository.dart';
import '../../shared/services/remote_posts_data_source/remote_posts_data_source.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;

  PostsBloc({required this.postsRepository}) : super(const PostsState()) {
    on<GetAllPosts>((event, emit) async {
      try {
        emit(state.copyWith(status: PostsStatus.loading));
        final posts = await postsRepository.getAllPosts();
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: posts,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostsStatus.error,
          exception: appException,
        ));
      }
    });

    on<CreatePost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostsStatus.loading));
        final post = await postsRepository.createPost(event.post);
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: [...state.posts, post],
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostsStatus.error,
          exception: appException,
        ));
      }
    });

    on<UpdatePost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostsStatus.loading));
        final post = await postsRepository.updatePost(event.post);
        final updatedPosts = state.posts.map((oldPost) {
          return oldPost.id == post.id ? post : oldPost;
        }).toList();
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: updatedPosts,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostsStatus.error,
          exception: appException,
        ));
      }
    });

    on<DeletePost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostsStatus.loading));
        await postsRepository.deletePost(event.post);
        final updatedPosts = state.posts.where((oldPost) => oldPost.id != event.post.id).toList();
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: updatedPosts,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostsStatus.error,
          exception: appException,
        ));
      }
    });
  }
}
