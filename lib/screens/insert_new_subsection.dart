import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
