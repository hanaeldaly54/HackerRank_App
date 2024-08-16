import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Taskmmcardbuttomsheet extends StatefulWidget {
  final String title;
  final String description;
  final List<String> initialFiles;
  final Function(String fileName) onFileUploaded;

  const Taskmmcardbuttomsheet({super.key, 
    required this.title,
    required this.description,
    required this.initialFiles,
    required this.onFileUploaded,
  });

  @override
  TaskmmcardbuttomsheetState createState() => TaskmmcardbuttomsheetState();
}

class TaskmmcardbuttomsheetState extends State<Taskmmcardbuttomsheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  String? _errorMessage;
  TextEditingController commentController = TextEditingController();
  List<String> comments = [];

  Future<void> _pickFile() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedFile = file;
      _errorMessage = null;
    });
  }

  void _submitFile() {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'Please select a file to upload.';
      });
    } else {
      widget.onFileUploaded(_selectedFile!.name);
      Navigator.pop(context);
    }
  }

  void _addComment() {
    if (commentController.text.isNotEmpty) {
      setState(() {
        comments.add(commentController.text);
        commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:const  EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.description),
              const SizedBox(height: 2),
              ListView.builder(
                shrinkWrap: true,
                physics:const  NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.comment, color: Colors.green),
                    title: Text(comments[index]),
                  );
                },
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: _addComment,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file, color: Colors.black),
                label: const Text('Choose File', style: TextStyle(color: Colors.green)),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 8),
              if (_selectedFile != null)
                Text('Selected File: ${_selectedFile!.name}'),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(_selectedFile != null ? Colors.green : Colors.grey),
                ),
                onPressed: _selectedFile != null ? _submitFile : null,
                child: const Text('Submit', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


