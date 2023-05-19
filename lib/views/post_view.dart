import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posts/model/post.dart';
import 'package:posts/service/api_service.dart';
import 'package:posts/view_models/post_view_model.dart';
import 'package:pulse/pulse.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final postViewModel = PostViewModel(service: PostService());
  late PulseReaction reaction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reaction = PulseReaction(postViewModel, (value, dispose) {
      if (value.status == PulseStatus.loaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                '🥳 Hooray!!, Posts have been loaded!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.indigo,
                ),
              ),
            ),
            backgroundColor: Colors.indigo.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 8.0,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: PulseFutureBuilder(
        viewModel: postViewModel,
        builder: (_, PulseState<dynamic> state, __) {
          if (state.status == PulseStatus.error) {
            return ErrorMessage(message: '${state.message}');
          } else if (state.status == PulseStatus.loaded) {
            return const PostList();
          }
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: Colors.amber,
            ),
          );
        },
      ),
    );
  }
}


class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = PulseStateManager.of<PostViewModel>(context);
    PulseState? state = viewModel?.value;
    List<Post> posts = state?.value as List<Post>;
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.amber.shade200,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(
              8.0,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  posts[index].title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  posts[index].body,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ));
      },
    );
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.red.shade500,
        ),
      ),
    );
  }
}
