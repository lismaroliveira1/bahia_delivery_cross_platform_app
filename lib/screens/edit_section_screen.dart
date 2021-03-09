import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class EditSectionScreen extends StatelessWidget {
  final CategoryStoreData section;
  EditSectionScreen(this.section);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditSectionTab(section),
    );
  }
}
