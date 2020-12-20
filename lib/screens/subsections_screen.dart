import 'package:bd_app_full/data/subsection_data.dart';
import 'package:bd_app_full/tabs/subsection_store_tab.dart';
import 'package:flutter/material.dart';

class SubSectionStoreScren extends StatelessWidget {
  final List<SubSectionData> subsections;
  final String sectionId;
  final bool isFirstSubsection;
  SubSectionStoreScren(
      this.subsections, this.sectionId, this.isFirstSubsection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubSectionStoreTab(
        subsections,
        sectionId,
        isFirstSubsection,
      ),
    );
  }
}
