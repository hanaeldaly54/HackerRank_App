import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/controllar/TaskMm_wsprovider.dart';

class MemberTaskScreenWs extends StatefulWidget {
  const MemberTaskScreenWs({super.key});

  @override
  MemberTaskScreenWsState createState() => MemberTaskScreenWsState();
}

class MemberTaskScreenWsState extends State<MemberTaskScreenWs> {
  late TaskmmWsprovider taskmmprovider;

  @override
  void initState() {
    super.initState();
    taskmmprovider = Provider.of<TaskmmWsprovider>(context, listen: false);
    taskmmprovider.filteredAssignments = taskmmprovider.assignments;
    taskmmprovider.searchController.addListener(() {
      taskmmprovider.filterAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskmmWsprovider>(
      builder: (context, taskmmprovider, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchBar(
                  controller: taskmmprovider.searchController,
                  showSubmittedOnly: taskmmprovider.showSubmittedOnly,
                  onToggleSubmitted: (value) {
                    setState(() {
                      taskmmprovider.showSubmittedOnly = value;
                      taskmmprovider.filterAssignments();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: taskmmprovider.filteredAssignments.length,
                    itemBuilder: (context, index) {
                      return taskmmprovider.filteredAssignments[index];
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool showSubmittedOnly;
  final ValueChanged<bool> onToggleSubmitted;

  const SearchBar({
    required this.controller,
    required this.showSubmittedOnly,
    required this.onToggleSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search Task',
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.green,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 237, 235, 235),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            const Text(
              'Submitted',
              style: TextStyle(color: Colors.black),
            ),
            Switch(
              activeColor: const Color.fromARGB(255, 19, 84, 22),
              value: showSubmittedOnly,
              onChanged: onToggleSubmitted,
            ),
          ],
        ),
      ],
    );
  }
}
