import 'package:flutter/material.dart';
import 'package:pr/controllar/pollprovider.dart';
import 'package:pr/controllar/postprovider.dart';

import 'package:pr/widgets/AdminPostRwquest.dart';
import 'package:pr/widgets/AdminRequestCard.dart';

import 'package:pr/widgets/Pollbottomsheet.dart';
import 'package:pr/widgets/pollcard.dart';
import 'package:pr/widgets/post.dart';

import 'package:provider/provider.dart';



class Deals extends StatefulWidget {
  final bool isAdmin;
  const Deals({
    super.key, required this.isAdmin,
  });

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.isAdmin ? 2 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pollprovider =Provider.of<Pollprovider>(context);
    final postprovider=Provider.of<Postprovider>(context);
      return Scaffold(
        body: Column(
          children: [
            if (widget.isAdmin)
              SizedBox(
                height: kToolbarHeight, // Same height as AppBar
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Deals'),
                    Tab(text: 'Requests'),
                  ],
                  indicatorColor: Colors.green,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                ),
              ),
            Expanded(
              child: widget.isAdmin
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        // Deals Tab
                        ListView.builder(
                          itemCount: pollprovider.polls.length +
                              postprovider.posts.length,
                          itemBuilder: (context, index) {
                            if (index < pollprovider.polls.length) {
                              final poll = pollprovider.polls[index];
                              return PollCard(
                                  poll: poll,
                                  isAdmin: widget.isAdmin,
                                  pollProvider: pollprovider);
                            } else {
                              final postIndex =
                                  index - pollprovider.polls.length;
                              final post = postprovider.posts[postIndex];
                              return CustomCard(
                                  index: postIndex,
                                  post: post,
                                  onEdit: (updatedPost) {
                                    postprovider.editPost(
                                        post['description'], updatedPost);
                                  },  isAdmin: widget.isAdmin, postProvider: postprovider,);
                            }
                          },
                        ),
                        // Requests Tab
                        ListView.builder(
                          itemCount: pollprovider.pendingPolls.length +
                              postprovider.pendingPosts.length,
                          itemBuilder: (context, index) {
                            if (index < pollprovider.pendingPolls.length) {
                              final pendingIndex = index;
                              final request =
                                  pollprovider.pendingPolls[pendingIndex];
                              return AdminRequestCard(
                                  request: request, pendingIndex: pendingIndex);
                            } else {
                              final pendingPostIndex =
                                  index - pollprovider.pendingPolls.length;
                              final postRequest =
                                  postprovider.pendingPosts[pendingPostIndex];
                              return AdminPostRequestCard(
                                  request: postRequest,
                                  pendingIndex: pendingPostIndex);
                            }
                          },
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount:
                          pollprovider.polls.length + postprovider.posts.length,
                      itemBuilder: (context, index) {
                        if (index < pollprovider.polls.length) {
                          final poll = pollprovider.polls[index];
                          return PollCard(
                              poll: poll,
                              isAdmin: widget.isAdmin,
                              pollProvider: pollprovider);
                        } else {
                          final postIndex = index - pollprovider.polls.length;
                          final post = postprovider.posts[postIndex];
                          return CustomCard(
                              index: postIndex,
                              post: post,
                              onEdit: (updatedPost) {
                                postprovider.editPost(
                                    post['description'], updatedPost);
                              }, isAdmin: widget.isAdmin, postProvider:postprovider,);
                        }
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add Options'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                             
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddPostBottomSheet(
                                    onSavePoll: (newPost) {
                                      postprovider.addPost(newPost);
                                   Navigator.of(context).pop();
                                    }, isAdmin: widget.isAdmin, postProvider: postprovider,
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Add Post',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return PollBottomSheet(
                                    isAdmin: widget.isAdmin,
                                    onSavePoll: (newPoll) {
                                      widget.isAdmin
                                          ? pollprovider.addPoll(newPoll)
                                          : pollprovider.addpollrequestApproval(
                                              context, pollprovider, newPoll);
                                              },
                                    pollProvider: pollprovider,
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Add Vote',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
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
