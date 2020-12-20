import 'package:bd_app_full/data/subsection_data.dart';
import 'package:bd_app_full/tabs/insert_new_subsection_tab.dart';
import 'package:flutter/material.dart';

class InsertNewSubSectionScreen extends StatelessWidget {
  final List<SubSectionData> subsections;
  final String sectionId;
  final isFirstSection;
  InsertNewSubSectionScreen(
    this.subsections,
    this.sectionId,
    this.isFirstSection,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InsertNewSubSectionTab(
        subsections,
        sectionId,
        isFirstSection,
      ),
    );
  }
}
