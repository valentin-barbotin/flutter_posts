import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpval/posts_screen/posts_bloc/posts_bloc.dart';

import '../../shared/models/post.dart';


class PostDetailScreen extends StatelessWidget {
  static Future<void> navigateTo(BuildContext context, Post post) {
    return Navigator.pushNamed(context, 'postDetail', arguments: post);
  }

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => _onDeletePost(context),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => _onEditPost(context),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        final updatedPost = state.posts.firstWhere((p) => p.id == post.id, orElse: () => post);

        return Column(
          children: [
            Text(updatedPost.body),
          ],
        );
      },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  void _onDeletePost(BuildContext context) {
    context.read<PostsBloc>().add(DeletePost(post));
    Navigator.pop(context);
  }

  void _onEditPost(BuildContext context) {
    _showTextInputDialog(context).then((value) {
      if (value != null) {
        context.read<PostsBloc>().add(UpdatePost(post.copyWith(body: value)));
      }
    });
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    String inputText = '';

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Entrez un texte'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: const InputDecoration(
              hintText: 'Message :',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(inputText);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
