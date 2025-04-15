import 'dart:io';

import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/common/screens/main_screen.dart';
import 'package:boilerplate_flutter/core/common/widgets/input.dart';
import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/core/utils/pick_image.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:boilerplate_flutter/features/post/presentation/bloc/post_bloc.dart';
import 'package:boilerplate_flutter/features/post/presentation/pages/post_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewPostPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewPostPage());
  const AddNewPostPage({super.key});

  @override
  State<AddNewPostPage> createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadPost() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<PostBloc>().add(
            PostUpload(
              title: titleController.text.trim(),
              userId: userId,
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
            ),
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
        actions: [
          IconButton(
            onPressed: () => uploadPost(),
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostFailure) {
            showSnackBar(context, state.error);
          } else if (state is PostUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MainScreen.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () => selectImage(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () => selectImage(),
                            child: DottedBorder(
                              color: AppPalette.borderColor,
                              dashPattern: [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open_rounded,
                                      size: 40,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Select your Image',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...Constants.topics.map(
                            (topic) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopics.contains(topic)) {
                                    selectedTopics.remove(topic);
                                  } else {
                                    selectedTopics.add(topic);
                                  }
                                  setState(() {});
                                },
                                child: Chip(
                                  color: selectedTopics.contains(topic)
                                      ? const WidgetStatePropertyAll(
                                          AppPalette.gradient1)
                                      : null,
                                  label: Text(topic),
                                  side: selectedTopics.contains(topic)
                                      ? null
                                      : const BorderSide(
                                          color: AppPalette.borderColor,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Input(
                      controller: titleController,
                      hintText: 'Post title',
                    ),
                    const SizedBox(height: 10),
                    Input(
                      controller: contentController,
                      hintText: 'Post content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
