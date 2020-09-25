import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/insert_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentsMethodsTab extends StatefulWidget {
  @override
  _PaymentsMethodsTabState createState() => _PaymentsMethodsTabState();
}

class _PaymentsMethodsTabState extends State<PaymentsMethodsTab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 8, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            "Cartões",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                            if (model.creditDebitCardList.length != 0) {
                              return IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InsertPaymentScreen()));
                                  });
                            } else {
                              return Container(
                                height: 0,
                                width: 0,
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                        if (model.creditDebitCardList.length == 0) {
                          return Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.yellow,
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Adcionar novo cartão",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            InsertPaymentScreen(),
                                      ));
                                    })
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            height: 100,
                            child: ListView(
                                children: model.creditDebitCardList.map(
                              (card) {
                                return Text(card.cardId);
                              },
                            ).toList()),
                          );
                        }
                      }),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
