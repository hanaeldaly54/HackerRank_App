import 'package:flutter/material.dart';

class Postprovider extends ChangeNotifier {
  
  List<Map<String, dynamic>> pendingPosts = [
    {
      'type': 'add',
      'post': {
        'description': 'Check out my new post!',
        'image': '',
      },
    },
    {
      'type': 'edit',
      'postDescription': 'Big Sale',
      'updatedPost': {
        'description': 'Updated description of the post',
        'image': 'assets/download (5).jpeg',
      },
    },
    {
      'type': 'delete',
      'postDescription': 'Big Sale',
    },
  ];

  List<Map<String, dynamic>> posts = [
    {
      'image': '',
      'description': 'Big Sale',
    }
  ];

  void addPost(Map<String, dynamic> newpost) {
    posts.add(newpost);
    notifyListeners();
  }

  void editPost(String postdescription, Map<String, dynamic> updatedpost) {
    int index =
        posts.indexWhere((post) => post['description'] == postdescription);
    if (index != -1) {
      posts[index] = updatedpost;
      notifyListeners();
    }
  }

  void deletePost(String postdescription) {
    posts.removeWhere((post) => post['description'] == postdescription);
    notifyListeners();
  }







  void showApprovalDialog(BuildContext context, String type) {
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Approval Required'),
            content: Text(
                'Your $type request has been sent to the admin for approval.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  void addPostRequestApproval(
      BuildContext context, Map<String, dynamic> newPost) {
    pendingPosts.add({
      'type': 'add',
      'post': newPost,
    });
    notifyListeners();
    showApprovalDialog(context, 'add post');
  }

  void editPostRequestApproval(BuildContext context, String postDescription,
      Map<String, dynamic> updatedPost) {
    pendingPosts.add({
      'type': 'edit',
      'postDescription': postDescription,
      'updatedPost': updatedPost,
    });
    notifyListeners();
    showApprovalDialog(context, 'edit post');
  }

  void deletePostRequestApproval(BuildContext context, String postDescription) {
    pendingPosts.add({
      'type': 'delete',
      'postDescription': postDescription,
    });
    notifyListeners();
    showApprovalDialog(context, 'delete post');
  }

  void approvePostRequest(int index) {
    final request = pendingPosts[index];
    if (request['type'] == 'add') {
      addPost(request['post']);
    } else if (request['type'] == 'edit') {
      editPost(request['postDescription'], request['updatedPost']);
    } else if (request['type'] == 'delete') {
      deletePost(request['postDescription']);
    }
    pendingPosts.removeAt(index);
    notifyListeners();
  }

  void rejectPostRequest(int index) {
    pendingPosts.removeAt(index);
    notifyListeners();
  }
}
