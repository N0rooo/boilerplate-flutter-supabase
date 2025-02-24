import 'package:boilerplate_flutter/core/utils/calculate_reading_time.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:boilerplate_flutter/features/post/presentation/pages/post_viewer_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Color color;
  const PostCard({super.key, required this.post, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PostViewerPage.route(post),
        );
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...post.topics.map(
                        (topic) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(
                            label: Text(topic),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text('${calculateReadingTime(post.content)} min')
          ],
        ),
      ),
    );
  }
}
