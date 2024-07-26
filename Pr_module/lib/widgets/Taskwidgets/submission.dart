import 'package:flutter/material.dart';
import 'package:pr/Taskwidgets/Taskprovider.dart';
import 'package:pr/provider.dart';
import 'package:pr/taskmodel/taskdata.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubmissionListItem extends StatefulWidget {
  final MemberSubmission submission;
  final int taskIndex;
  final int submissionIndex;

  SubmissionListItem({
    required this.submission,
    required this.taskIndex,
    required this.submissionIndex,
  });

  @override
  _SubmissionListItemState createState() => _SubmissionListItemState();
}

class _SubmissionListItemState extends State<SubmissionListItem> {
  late TextEditingController _degreeController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.submission.degree.toString());
    _commentController = TextEditingController(text: widget.submission.comments);
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Member: ${widget.submission.memberName}'), 
            InkWell(
              onTap: () {
                _openFile(widget.submission.filePath);
              },
              child: Text(
                'File Path: ${widget.submission.filePath}',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _degreeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Degree'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Comment'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                _submitDetails(context);
              },
              child: Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                _openFile(widget.submission.filePath);
              },
              child: Text('Download and Open File'),
            ),
          ],
        ),
      ),
    );
  }

  void _openFile(String filePath) async {
    final Uri fileUri = Uri.file(filePath);
    if (await canLaunchUrlString(fileUri.toString())) {
      await launchUrlString(fileUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the file.')),
      );
    }
  }

  void _submitDetails(BuildContext context) {
    final degree = int.tryParse(_degreeController.text) ?? 0;
    final comment = _commentController.text;
    Provider.of<ProviderService>(context, listen: false).updateSubmissionDetails(
      widget.taskIndex,
      widget.submissionIndex,
      degree,
      comment,
    );
  }
}
