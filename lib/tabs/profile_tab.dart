import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/be_a_partener_screen.dart';
import 'package:bahia_delivery/screens/order_screen.dart';
import 'package:bahia_delivery/tiles/profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                  title: "Chats",
                  description: "Minhas Conversas",
                  icon: Icons.message),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                  title: "Pagamentos",
                  description: "Minhas formas de pagamento",
                  icon: Icons.payment),
            ),
            FlatButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              child: ProfileTile(
                  title: "Cupons",
                  description: "Meus Cupons",
                  icon: Icons.money_off),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white),
                            height: 400,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red[50]),
                                  height: 150,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Image.asset("images/logo.png"),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        "Bem vindo ao Bahia Delivery Partners",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Algumas informações a mais serão requeridas.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          height: 50,
                                          width: 140,
                                          child: RaisedButton(
                                            padding: EdgeInsets.zero,
                                            color: Colors.red,
                                            child: Text(
                                              "Voltar",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            textColor: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            disabledColor: Colors.grey,
                                            disabledTextColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            height: 50,
                                            width: 140,
                                            child: RaisedButton(
                                              padding: EdgeInsets.zero,
                                              color: Colors.red,
                                              child: Text(
                                                "Ok, vamos lá!",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              textColor: Colors.white,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      BeAParterScreen(),
                                                ));
                                              },
                                              disabledColor: Colors.grey,
                                              disabledTextColor: Colors.black,
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    });
              },
              child: ProfileTile(
                  title: model.updateUser()
                      ? "Gerencie sua loja"
                      : "Crie sua loja",
                  description: "Venda seus produtos através do nosso app",
                  icon: Icons.scatter_plot),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                  title: "Notificações",
                  description: "Gerencie as suas notificações",
                  icon: Icons.notifications_active),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderScreen(),
                ));
              },
              child: ProfileTile(
                  title: "Pedidos",
                  description: "Aconpanhe seus pedidos",
                  icon: Icons.list),
            ),
            FlatButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              child: ProfileTile(
                  title: "Minha Conta",
                  description: "Aconpanhe seus pedidos",
                  icon: Icons.list),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                title: "Configurações",
                description: "Configure o app do seu jeito",
                icon: Icons.phonelink_setup,
              ),
            ),
          ],
        ),
      );
    });
  }
}
