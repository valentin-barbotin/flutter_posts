import 'package:tpval/posts_screen/posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpval/shared/services/remote_posts_data_source/fake_remote_posts_data_source.dart';

import 'posts_screen/post_detail_screen/post_detail_screen.dart';
import 'posts_screen/posts_bloc/posts_bloc.dart';
import 'shared/models/post.dart';
import 'shared/services/local_posts_data_source/fake_local_posts_data_source.dart';
import 'shared/services/posts_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(
        remotePostsDataSource: FakeRemotePostDataSource(),
        // remotePostsDataSource: ApiPostsDataSource(),
        localDataSource: FakeLocalPostsDataSource(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostsBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const PostsScreen(),
          },
          onGenerateRoute: (routeSettings) {
            Widget screen = Container(color: Colors.pink);
            final argument = routeSettings.arguments;
            switch (routeSettings.name) {
              case 'postDetail':
                if (argument is Post) {
                  screen = PostDetailScreen(post: argument);
                }
                break;
            }

            return MaterialPageRoute(builder: (context) => screen);
          },
        ),
      ),
    );
  }
}
