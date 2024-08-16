import 'package:flutter/material.dart';

class Postswsprovider with ChangeNotifier{
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







}

