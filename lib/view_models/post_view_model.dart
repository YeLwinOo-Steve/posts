
import 'package:posts/model/post.dart';
import 'package:posts/service/api_service.dart';
import 'package:pulse/pulse.dart';

class PostViewModel extends PulseFutureViewModel {
  final ApiService service;
  PostViewModel({required this.service});
  @override
  void onInit() {
    super.onInit();
    _fetchPosts();
  }

  void _fetchPosts() async {
    changeState(PulseState.loading());
    try {
      List<Post> posts = await service.getPosts();
      changeState(PulseState.loaded(
        posts,
      ));
    } catch (ex) {
      changeState(PulseState.error(ex.toString()));
    }
  }
}
