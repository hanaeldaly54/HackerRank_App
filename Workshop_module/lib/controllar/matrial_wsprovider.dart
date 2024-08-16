import 'package:flutter/material.dart';
import 'package:workshop/models/Lessons_wsmodel.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class MatrialWsprovider with ChangeNotifier {
    TextEditingController searchController = TextEditingController();
  List<Lesson> lessons = [
    Lesson(
      lessonName: 'Lesson 1',
      description:
          'Rational Numbers assignment, Very important for your next exam...',
      date: '18 Sep',
      fileName: '115_Attacking_LDAP_Based_Implementations.pdf',
    ),
    Lesson(
      lessonName: 'Lesson 2',
      description:
          'Whole Numbers, Fraction, Decimals, Percentage, Ratio, Time, Measurement, Geometry, Data Analysis, Algebra, Speed ...',
      date: '15 Nov',
      fileName: 'CYBER SECURITY ITI 9 MONTHS.pdf',
    ),
  ];

  List<Lesson> filteredLessons = [];

  void filterLessons() {
    List<Lesson> tempList = [];
    String query = searchController.text.toLowerCase();
    tempList.addAll(lessons.where((lesson) {
      bool nameMatches = lesson.lessonName.toLowerCase().contains(query);
      bool dateMatches = lesson.date.toLowerCase().contains(query) ||
          matchesDate(lesson.date, query);
      return nameMatches || dateMatches;
    }));

    filteredLessons = tempList;
    notifyListeners();
  }

  bool matchesDate(String date, String query) {
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
        return lessonDate.day == queryDate.day &&
            lessonDate.month == queryDate.month;
      }
    } catch (_) {}

    return false;
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
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            fillColor: Colors.grey[400],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: lessonDescriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description (optional)',
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            fillColor: Colors.grey[400],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file_outlined,
                              color: Colors.black),
                          label: Text(
                            fileName == null ? 'Choose File' : fileName!,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 28, 59, 29)),
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();

                            if (result != null) {
                              setState(() {
                                fileName = result.files.single.name;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            String lessonName = lessonNameController.text;
                            String description =
                                lessonDescriptionController.text.isEmpty
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
                                    date: DateFormat('d MMM')
                                        .format(DateTime.now()),
                                    fileName: fileName!,
                                  ));
                                  filteredLessons = List.from(
                                      lessons); // Update filtered lessons
                                  showError = false;
                                  showFileError = false;
                                });
                                Navigator.pop(
                                    context); // Close the bottom sheet after adding lesson
                              }
                            }
                          },
                          child: const Text('Add Lesson',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 28, 59, 29))),
                        ),
                        Visibility(
                          visible: showError,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Please enter the Lesson Name.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showFileError,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10.0),
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
    notifyListeners();
  }

  void removeLesson(int index) {
    lessons.removeAt(index);
    filteredLessons = lessons;
    notifyListeners();
  }

  void addLesson(String lessonName, String description) {
    lessons.add(Lesson(
      lessonName: lessonName,
      description:
          description.isEmpty ? 'No description provided' : description,
      date: DateFormat('d MMM').format(DateTime.now()),
      fileName:
          'New_Lesson_File.pdf', // You can update this to be dynamic if needed
    ));
    filteredLessons = lessons;
    notifyListeners();
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
                      lessons[index].lessonName = newValue;
                      filteredLessons = lessons;
               
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
                   
                      lessons[index].description = newValue;
                      filteredLessons = lessons;
               
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
                    lessons[index].fileName = fileName;
                    filteredLessons = lessons;
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
    notifyListeners();
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
            decoration:const  InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',style: TextStyle(color: Colors.green),),
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
    void showDatePickerDialog(BuildContext context, Function(String) onSave) {
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
}
