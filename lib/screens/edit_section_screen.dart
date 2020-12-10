import 'package:bd_app_full/data/category_store_data.dart';
import 'package:bd_app_full/tabs/edit_section_tab.dart';
import 'package:flutter/material.dart';

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
