import 'package:boilerplate_flutter/features/post/data/models/post_model.dart';
import 'package:hive/hive.dart';

abstract interface class PostLocalDataSource {
  void uploadLocalPosts({required List<PostModel> posts});
  List<PostModel> loadPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box box;
  PostLocalDataSourceImpl(this.box);

  @override
  List<PostModel> loadPosts() {
    List<PostModel> posts = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        posts.add(PostModel.fromJson(box.get(i.toString())));
      }
    });
    return posts;
  }

  @override
  void uploadLocalPosts({required List<PostModel> posts}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < posts.length; i++) {
        box.put(i.toString(), posts[i].toJson());
      }
    });
  }
}
