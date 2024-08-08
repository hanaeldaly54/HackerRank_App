import 'package:flutter/material.dart';

class Pollprovider extends ChangeNotifier {
  List<Map<String, dynamic>> pendingPolls = [
    {
      'type': 'add',
      'poll': {
        'id': '2',
        'title': 'Which is your favorite color?',
        'options': [
          {'id': '1', 'title': 'Red', 'votes': 5},
          {'id': '2', 'title': 'Blue', 'votes': 10},
          {'id': '3', 'title': 'Green', 'votes': 8},
        ],
      },
    },
    {
      'type': 'edit',
      'pollId': '1',
      'updatedPoll': {
        'id': '1',
        'title': 'What is your favorite programming language? (Updated)',
        'options': [
          {'id': '1', 'title': 'Java', 'votes': 10},
          {'id': '2', 'title': 'Python', 'votes': 20},
          {'id': '3', 'title': 'c++', 'votes': 30},
        ],
      },
    },
    {
      'type': 'delete',
      'pollId': '1',
    },
  ];

  List<Map<String, dynamic>> polls = [
    {
      'id': '1',
      'title': 'What is your favorite programming language?',
      'options': [
        {'id': '1', 'title': 'Java', 'votes': 10},
        {'id': '2', 'title': 'Python', 'votes': 20},
        {'id': '3', 'title': 'JavaScript', 'votes': 30},
      ],
    }
  ];

  void addPoll(Map<String, dynamic> newpoll) {
    polls.add(newpoll);
    notifyListeners();
  }

  void editPoll(String pollid, Map<String, dynamic> updatedpoll) {
    int index = polls.indexWhere((poll) => poll['id'] == pollid);
    if (index != -1) {
      polls[index] = updatedpoll;
      notifyListeners();
    }
  }

  void deletepoll(String pollid) {
    polls.removeWhere((poll) => poll['id'] == pollid);
    notifyListeners();
  }

  void onVote(String pollId, String? optionId) {
    if (optionId != null) {
      int pollIndex = polls.indexWhere((poll) => poll['id'] == pollId);
      if (pollIndex != -1) {
        int optionIndex = polls[pollIndex]['options']
            .indexWhere((option) => option['id'] == optionId);
        if (optionIndex != -1) {
          polls[pollIndex]['options'][optionIndex]['votes']++;
          notifyListeners();
        }
      }
    }
  }

  void deletepollrequestApproval(
      BuildContext context, Pollprovider pollProvider, String pollId) {
    pendingPolls.add({
      'type': 'delete',
      'pollId': pollId,
    });
    notifyListeners();
    showApprovalDialog(context, 'delete');
  }

  void editpollrequestApproval(BuildContext context, Pollprovider pollProvider,
      Map<String, dynamic> updatedPoll, String pollId) {
    pendingPolls.add({
      'type': 'edit',
      'pollId': pollId,
      'updatedPoll': updatedPoll,
    });
    notifyListeners();
    showApprovalDialog(context, 'edit');
  }

  void addpollrequestApproval(BuildContext context, Pollprovider pollProvider,
      Map<String, dynamic> newPoll) {
    pendingPolls.add({
      'type': 'add',
      'poll': newPoll,
    });
    notifyListeners();
    showApprovalDialog(context, 'add');
  }

  void approveRequest(int index) {
    final request = pendingPolls[index];
    if (request['type'] == 'add') {
      addPoll(request['poll']);
    } else if (request['type'] == 'edit') {
      editPoll(request['pollId'], request['updatedPoll']);
    } else if (request['type'] == 'delete') {
      deletepoll(request['pollId']);
    }
    pendingPolls.removeAt(index);
    notifyListeners();
  }

  void rejectRequest(int index) {
    pendingPolls.removeAt(index);
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
}
