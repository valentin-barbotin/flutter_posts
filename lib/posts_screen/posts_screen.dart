import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpval/posts_screen/post_detail_screen/post_detail_screen.dart';
import 'package:tpval/posts_screen/posts_bloc/posts_bloc.dart';

import '../shared/app_exception.dart';
import '../shared/models/post.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}


class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    _getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Posts'),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                onPressed: _showCreatePostDialog,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: switch (state.status) {
                  PostsStatus.loading || PostsStatus.initial => _buildLoading(context),
                  PostsStatus.error => _buildError(context, state.exception),
                  PostsStatus.success => _buildSuccess(context, state.posts),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, AppException? exception) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $exception'),
          ElevatedButton(
            onPressed: () => _getAllPosts(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('Aucun post à afficher.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _getAllPosts();
      },
      child: ListView.separated(
        itemCount: posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post.title),
            tileColor: Colors.grey[200],
            onTap: () => _onPostTap(context, post),
          );
        },
      ),
    );
  }

  void _getAllPosts() {
    final postsBloc = context.read<PostsBloc>();
    postsBloc.add(GetAllPosts());
  }

  void _onPostTap(BuildContext context, Post post) {
    PostDetailScreen.navigateTo(context, post);
  }

  void _showCreatePostDialog() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouveau post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Titre'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: 'Contenu'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Créer'),
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                if (title.isNotEmpty && content.isNotEmpty) {
                  _createPost(title, content);
                  Navigator.of(context).pop();
                } else {
                  // Vous pouvez ajouter une validation ici, par exemple, montrer un snackbar pour informer que tous les champs doivent être remplis
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir tous les champs.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _createPost(String title, String content) {
    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: content,
    );
    context.read<PostsBloc>().add(CreatePost(post));
  }
}
