
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/controllar/TaskMm_wsprovider.dart';


import 'package:workshop/widgets/TaskMmcardbuttomsheet.dart';


           class AssignmentCard extends StatefulWidget {
   final String title;
  final String subject;
  final String description;
  final String dueDate;
  final String initialDaysLeft;
  final bool initiallySubmitted;
  final List<String> initialFiles;

  AssignmentCard({required this.title,
   required this.subject, 
   required this.description,
    required this.dueDate, 
    required this.initialDaysLeft, 
    required this.initiallySubmitted, 
    required this.initialFiles});


  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  bool isSubmitted = false;
  late String daysLeft;
  late List<String> submittedFiles;
  bool isTaskDetailsButtonClicked = false;
  

  @override
  void initState() {
    super.initState();
    isSubmitted = widget.initiallySubmitted;
    daysLeft = widget.initialDaysLeft;
    submittedFiles = widget.initialFiles;
  }

  void _showDetailsBottomSheet() {
    setState(() {
      isTaskDetailsButtonClicked = true;
    });
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      isScrollControlled: true,
      builder:(context) => DraggableScrollableSheet(
        expand:false ,
      builder: (context,scrollController){
        return SingleChildScrollView(
          controller: scrollController,
        child: Taskmmcardbuttomsheet(
    
          title: widget.title,
          description: widget.description,
          initialFiles: submittedFiles,
          onFileUploaded: (String fileName) {
            setState(() {
              isSubmitted = true;
              daysLeft = '';
              submittedFiles.add(fileName);
            });
          },
         ) );
      },),
    ).whenComplete(() {
      setState(() {
        isTaskDetailsButtonClicked = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<TaskmmWsprovider>(
      builder: (BuildContext context,taskmmwsprovider,_) { 
     return Card(
        color: const Color.fromARGB(255, 193, 205, 193),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.subject, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 8),
              Text(
                widget.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.dueDate),
                  if (isSubmitted) const  Chip(label: Text('Submitted')),
                  if (daysLeft.isNotEmpty && !isSubmitted)
                    Text(daysLeft, style: const  TextStyle(color: Colors.red)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: _showDetailsBottomSheet,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      'Task Details',
                      style: TextStyle(color: isTaskDetailsButtonClicked ? Colors.green : Colors.black),
                    ),
                  ),
                ],
              ),
              if (submittedFiles.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text('Submitted Files:', style: TextStyle(fontWeight: FontWeight.bold)),
                    for (var file in submittedFiles)
                      ListTile(
                        leading: const Icon(Icons.attach_file, color: Colors.green),
                        title: GestureDetector(
                          onTap: () => taskmmwsprovider.openFile(file),
                          child: Text(file),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      );
    }  );
  }
}