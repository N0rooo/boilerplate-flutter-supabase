import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/core/utils/calculate_reading_time.dart';
import 'package:boilerplate_flutter/core/utils/format_date.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostViewerPage extends StatelessWidget {
  static route(Post post) => MaterialPageRoute(
        builder: (context) => PostViewerPage(post: post),
      );
  final Post post;
  const PostViewerPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${post.userName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(post.updatedAt)} . ${calculateReadingTime(post.content)} min',
                  style: const TextStyle(
                    color: AppPalette.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    post.imageUrl,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
