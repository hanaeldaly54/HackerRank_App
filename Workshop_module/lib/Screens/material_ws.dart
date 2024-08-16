import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/controllar/matrial_wsprovider.dart';
import 'package:workshop/widgets/lessoncardws.dart';

class MaterialWs extends StatefulWidget {
  final bool isAdmin;

  const MaterialWs({super.key, required this.isAdmin});

  @override
  State<MaterialWs> createState() => _MaterialWsState();
}

class _MaterialWsState extends State<MaterialWs> {
  late MatrialWsprovider matrialws;

  @override
  void initState() {
    super.initState();
    matrialws = Provider.of<MatrialWsprovider>(context, listen: false);
    matrialws.filteredLessons = matrialws.lessons;

    matrialws.searchController.addListener(() {
      matrialws.filterLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatrialWsprovider>(
      builder: (context, matrialwsprovider, _) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: matrialwsprovider.searchController,
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
                    if (widget.isAdmin)
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          matrialwsprovider.showAddLessonBottomSheet(context);
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: matrialwsprovider.filteredLessons.length,
                  itemBuilder: (context, index) {
                    return LessonCard(
                      lesson: matrialwsprovider.filteredLessons[index],
                      isAdmin: widget.isAdmin,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          matrialwsprovider.filteredLessons[index]
                                              .lessonName,
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          matrialwsprovider.filteredLessons[index]
                                              .description,
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
                                          leading: const Icon(Icons.download,
                                              color: Colors.green),
                                          title: Text(matrialwsprovider
                                              .filteredLessons[index].fileName),
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
                        matrialwsprovider.removeLesson(index);
                      },
                      onEdit: () {
                        matrialwsprovider
                            .showEditLessonBottomSheet(context, index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
