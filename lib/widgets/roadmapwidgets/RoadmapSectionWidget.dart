import 'package:flutter/material.dart';
import 'package:it_module/models/roadmapmodel/section.dart';
import 'package:it_module/widgets/roadmapwidgets/RoadmapStep.dart';




class RoadmapSectionWidget extends StatelessWidget {
  final Section section;

  RoadmapSectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.sectiontitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromARGB(255, 50, 123, 90),
            )),
         ...section.steps
              .map((step) => RoadmapStepWidget(step: step))
              .toList(),
        ],
      ),
    );
  }
}