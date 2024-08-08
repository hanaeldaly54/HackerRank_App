import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaterialScreen extends StatefulWidget {
   final bool isAdmin ;
  const MaterialScreen({super.key, required this.isAdmin});

  @override
  _MaterialScreenState createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  TextEditingController searchController = TextEditingController();
  List<Lesson> lessons = [
    Lesson(
      lessonName: 'Lesson 1',
      description: 'Rational Numbers assignment, Very important for your next exam...',
      date: '18 Sep',
      fileName: '115_Attacking_LDAP_Based_Implementations.pdf',
    ),
    Lesson(
      lessonName: 'Lesson 2',
      description: 'Whole Numbers, Fraction, Decimals, Percentage, Ratio, Time, Measurement, Geometry, Data Analysis, Algebra, Speed ...',
      date: '15 Nov',
      fileName: 'CYBER SECURITY ITI 9 MONTHS.pdf',
    ),
  ];
  List<Lesson> filteredLessons = [];
  


  // Adding isAdmin boolean


  @override
  void initState() {
    super.initState();
    filteredLessons = lessons;
    searchController.addListener(() {
      filterLessons();
    });
  }

  void filterLessons() {
    List<Lesson> tempList = [];
    String query = searchController.text.toLowerCase();
    tempList.addAll(lessons.where((lesson) {
      bool nameMatches = lesson.lessonName.toLowerCase().contains(query);
      bool dateMatches = lesson.date.toLowerCase().contains(query) || _matchesDate(lesson.date, query);
      return nameMatches || dateMatches;
    }));

    setState(() {
      filteredLessons = tempList;
    });
  }

  bool _matchesDate(String date, String query) {
    try {
      DateFormat format = DateFormat('d MMM');
      DateTime lessonDate = format.parse(date);
      DateTime? queryDate;
      List<DateFormat> formats = [
        DateFormat('d/M'),
        DateFormat('d MMM'),
        DateFormat('d MMMM'),
      ];

      for (DateFormat fmt in formats) {
        try {
          queryDate = fmt.parse(query);
          // ignore: unnecessary_null_comparison
          if (queryDate != null) break;
        } catch (_) {}
      }

      if (queryDate != null) {
        return lessonDate.day == queryDate.day && lessonDate.month == queryDate.month;
      }
    } catch (_) {}

    return false;
  }

  void removeLesson(int index) {
    setState(() {
      lessons.removeAt(index);
      filteredLessons = lessons;
    });
  }

  void showAddLessonBottomSheet(BuildContext context) {
    TextEditingController lessonNameController = TextEditingController();
    TextEditingController lessonDescriptionController = TextEditingController();
    String? fileName;
    bool showError = false;
  bool showFileError = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: lessonNameController,
                        decoration: InputDecoration(
                          labelText: 'Lesson Name',
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          fillColor: Colors.grey[400],
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: lessonDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          fillColor: Colors.grey[400],
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.upload_file_outlined, color: Colors.black),
                        label: Text(
                          fileName == null ? 'Choose File' : fileName!,
                          style: TextStyle(color: const Color.fromARGB(255, 28, 59, 29)),
                        ),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();

                          if (result != null) {
                            setState(() {
                              fileName = result.files.single.name;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          String lessonName = lessonNameController.text;
                          String description = lessonDescriptionController.text.isEmpty
                              ? 'No description provided'
                              : lessonDescriptionController.text;

                          if (lessonName.isEmpty) {
                            setState(() {
                              showError = true;
                            });
                          } else {
                            if (fileName == null) {
                              setState(() {
                                showFileError = true;
                              });
                            } else {
                              setState(() {
                                lessons.add(Lesson(
                                  lessonName: lessonName,
                                  description: description,
                                  date: DateFormat('d MMM').format(DateTime.now()),
                                  fileName: fileName!,
                                ));
                                filteredLessons = List.from(lessons); // Update filtered lessons
                                showError = false;
                                showFileError = false;
                              });
                              Navigator.pop(context); // Close the bottom sheet after adding lesson
                            }
                          }
                        },
                        child: Text('Add Lesson', style: TextStyle(color: const Color.fromARGB(255, 28, 59, 29))),
                      ),
                      Visibility(
                        visible: showError,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Please enter the Lesson Name.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showFileError,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Please select a file to upload.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
  }

  void addLesson(String lessonName, String description) {
    setState(() {
      lessons.add(Lesson(
        lessonName: lessonName,
        description: description.isEmpty ? 'No description provided' : description,
        date: DateFormat('d MMM').format(DateTime.now()),
        fileName: 'New_Lesson_File.pdf', // You can update this to be dynamic if needed
      ));
      filteredLessons = lessons;
    });
  }

  void showEditLessonBottomSheet(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditDialog(context, 'Change Lesson Name', (newValue) {
                    setState(() {
                      lessons[index].lessonName = newValue;
                      filteredLessons = lessons;
                    });
                  });
                },
                child: const Text(
                  'Change Lesson Name',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditDialog(context, 'Change Description', (newValue) {
                    setState(() {
                      lessons[index].description = newValue;
                      filteredLessons = lessons;
                    });
                  });
                },
                child: const Text(
                  'Change Description',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  String? fileName = await _pickFile();
                  if (fileName != null) {
                    setState(() {
                      lessons[index].fileName = fileName;
                      filteredLessons = lessons;
                    });
                  }
                },
                child: const Text(
                  'Change File',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return result.files.single.name;
    } else {
      return null;
    }
  }

  void _showEditDialog(BuildContext context, String title, Function(String) onSave) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: TextStyle(color: Colors.green),),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text('Save',style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showDatePickerDialog(BuildContext context, Function(String) onSave) {
    DateTime selectedDate = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate != null) {
        onSave(DateFormat('d MMM').format(pickedDate));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.green),
                    hintText: 'Search with Lesson Name or Date',
                    filled: true,
                    fillColor: Color.fromARGB(176, 179, 176, 176),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  ),
                ),
              ),
              // Show add button if isAdmin is true
              if (widget.isAdmin)
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    showAddLessonBottomSheet(context);
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredLessons.length,
            itemBuilder: (context, index) {
              return LessonCard(
                lesson: filteredLessons[index],
                isAdmin:widget.isAdmin,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.5,
                        minChildSize: 0.3,
                        maxChildSize: 0.9,
                        expand: false,
                        builder: (context, scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    filteredLessons[index].lessonName,
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    filteredLessons[index].description,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                  const SizedBox(height: 20.0),
                                  const Text(
                                    'Attachments',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  ListTile(
                                    leading: const Icon(Icons.download, color: Colors.green),
                                    title: Text(filteredLessons[index].fileName),
                                    onTap: () {
                                      // Handle the download action
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                onRemove: () {
                  removeLesson(index);
                },
                onEdit: () {
                  showEditLessonBottomSheet(context, index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class Lesson {
  String lessonName;
  String description;
  String date;
  String fileName;

  Lesson({
    required this.lessonName,
    required this.description,
    required this.date,
    required this.fileName,
  });
}

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
                      icon: Icon(Icons.more_vert, color: Colors.green),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Options"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.edit, color: Colors.green),
                                    title: Text("Edit"),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onEdit();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.delete, color: Colors.green),
                                    title: Text("Remove"),
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