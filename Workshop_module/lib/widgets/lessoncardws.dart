import 'package:flutter/material.dart';
import 'package:workshop/models/Lessons_wsmodel.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool isAdmin;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    required this.isAdmin,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(11.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 193, 205, 193),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.green),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lesson.lessonName,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Show three dots if isAdmin is true
                  if (isAdmin)
                    IconButton(
                      icon:const  Icon(Icons.more_vert, color: Colors.green),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const  Text("Options"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const  Icon(Icons.edit, color: Colors.green),
                                    title: const  Text("Edit"),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onEdit();
                                    },
                                  ),
                                  ListTile(
                                    leading:const  Icon(Icons.delete, color: Colors.green),
                                    title:  const Text("Remove"),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onRemove();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 5.0),
              Text(
                lesson.description.length > 60
                    ? '${lesson.description.substring(0, 60)}...'
                    : lesson.description,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10.0),
              Text(
                lesson.date,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const Icon(Icons.attach_file, color: Colors.green),
                  const SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      lesson.fileName,
                      style: const TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}