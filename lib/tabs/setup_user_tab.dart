import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';

class SetupUserTab extends StatefulWidget {
  @override
  _SetupUserTabState createState() => _SetupUserTabState();
}

class _SetupUserTabState extends State<SetupUserTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxScrolled,
        ) {
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
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      onTap: () {
                        UserModel.of(context).signOut(
                          onSuccess: _onSuccess,
                        );
                      },
                      dense: true,
                      leading: Icon(
                        Icons.phonelink_setup,
                      ),
                      title: Text(
                        "Sair",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Faça logout na sua conta",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }
}
