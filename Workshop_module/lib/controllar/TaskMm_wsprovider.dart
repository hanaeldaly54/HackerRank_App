import 'package:flutter/material.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workshop/widgets/TaskMmcard_ws.dart';

class TaskmmWsprovider with ChangeNotifier {
  late BuildContext context;
  TextEditingController searchController = TextEditingController();
  bool showSubmittedOnly = false;
  Future<void> openFile(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filePath');

    if (await file.exists()) {
      OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File not found')),
      );
    }
  }

  List<AssignmentCard> assignments = [
    AssignmentCard(
      title: 'Assignment 1',
      subject: 'Maths',
      description:
          'Rational Numbers assignment, Very important for your next exam',
      dueDate: '18 Sep',
      initialDaysLeft: '',
      initiallySubmitted: true,
      initialFiles: const ['file1.jpg'],
    ),
    AssignmentCard(
      title: 'Assignment 2',
      subject: 'Maths',
      description:
          'Whole Numbers, Fraction, Decimals, Percentage, Ratio, Time, Measurement, Geometry, Data Analysis, Algebra, Speed',
      dueDate: '18 Sep',
      initialDaysLeft: '1 Day Left',
      initiallySubmitted: false,
      initialFiles: const [],
    ),
    AssignmentCard(
      title: 'Assignment 3',
      subject: 'Science',
      description: 'Crop Production & Mgt. Very important for your next exam',
      dueDate: '20 Sep',
      initialDaysLeft: '4 Days Left',
      initiallySubmitted: false,
      initialFiles: const [],
    ),
  ];

  List<AssignmentCard> filteredAssignments = [];

  void filterAssignments() {
    List<AssignmentCard> _assignments = [];
    _assignments.addAll(assignments);
    if (searchController.text.isNotEmpty) {
      _assignments.retainWhere((assignment) {
        String searchTerm = searchController.text.toLowerCase();
        String assignmentTitle = assignment.title.toLowerCase();
        return assignmentTitle.contains(searchTerm);
      });
    }
    if (showSubmittedOnly) {
      _assignments.retainWhere((assignment) => assignment.initiallySubmitted);
    }
    filteredAssignments = _assignments;
    notifyListeners();
  }
}
