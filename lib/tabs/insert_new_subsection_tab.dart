import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/data.dart';
import '../models/models.dart';

class InsertNewSubSectionTab extends StatefulWidget {
  final List<SubSectionData> subsections;
  final String sectionId;
  final bool isFirstSection;
  InsertNewSubSectionTab(
    this.subsections,
    this.sectionId,
    this.isFirstSection,
  );
  @override
  _InsertNewSubSectionTabState createState() => _InsertNewSubSectionTabState();
}

class _InsertNewSubSectionTabState extends State<InsertNewSubSectionTab> {
  int order = 5;
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 45, 8, 4),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                child: Container(
                  height: 45,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black38,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _onPositionButtonPressed();
                    },
                    child: Text("Ordem"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: TextButton(
                  onPressed: () {
                    final subSectionData = SubSectionData(
                      order: order,
                      title: _nameController.text,
                      sectionId: widget.sectionId,
                    );
                    UserModel.of(context).insertNewSubsection(
                      subSectionData: subSectionData,
                      onSucess: _onSuccess,
                      onFail: _onFail,
                    );
                  },
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                        if (model.isLoading) {
                          return Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            "Enviar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          );
                        }
                      },
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPositionButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        content: widget.subsections.length > 0
            ? Container()
            : Container(
                height: 50,
                child: Text(
                  "Esta é a primeira subseção desta seção",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
