import 'package:bd_app_full/data/subsection_data.dart';
import 'package:bd_app_full/screens/insert_new_subsection.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SubSectionStoreTab extends StatefulWidget {
  final List<SubSectionData> subsections;
  final String sectionId;
  SubSectionStoreTab(
    this.subsections,
    this.sectionId,
  );
  @override
  _SubSectionStoreTabState createState() => _SubSectionStoreTabState();
}

class _SubSectionStoreTabState extends State<SubSectionStoreTab> {
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
                padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 35,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: InsertNewSubSectionScreen(
                            widget.subsections,
                            widget.sectionId,
                          ),
                          inheritTheme: true,
                          duration: Duration(
                            milliseconds: 350,
                          ),
                          ctx: context,
                        ),
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.add_circle),
                    title: Text("Nova Subseção"),
                    subtitle: Text(
                      "Insira uma nova subseção nesta seção",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: widget.subsections.map((subsection) {
                    return ListTile(
                      title: Text(
                        subsection.title,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        subsection.order.toString(),
                        textAlign: TextAlign.end,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
