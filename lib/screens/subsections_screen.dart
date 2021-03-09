import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
