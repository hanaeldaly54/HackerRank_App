import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:workshop/controllar/postswsprovider.dart';
import 'package:workshop/widgets/postwscard.dart';

class Postswsscreen extends StatefulWidget {
  final bool isAdmin;
  const Postswsscreen({super.key, required this.isAdmin});

  @override
  State<Postswsscreen> createState() => _PostswsscreenState();
}

class _PostswsscreenState extends State<Postswsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Postswsprovider>(
        builder: (context, postprovider, child) {
          return ListView.builder(
            itemCount: postprovider.posts.length,
            itemBuilder: (context, index) {
              final post = postprovider.posts[index];
              return CustomwsCard(
                index: index,
                post: post,
                onEdit: (updatedPost) {
                  postprovider.editPost(post['description'], updatedPost);
                },
                isAdmin: widget.isAdmin,
                postProvider: postprovider,
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Consumer<Postswsprovider>(
                    builder: (context, postprovider, child) {
                      return AddPostBottomSheet(
                        onSavePoll: (newPost) {
                          postprovider.addPost(newPost);
                          Navigator.of(context).pop();
                        },
                        isAdmin: widget.isAdmin,
                        postProvider: postprovider,
                      );
                    },
                  );
                },
              );
            },
            backgroundColor: Colors.green,
            label: const Text('Add', style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}
